// LizardScene.swift
import SpriteKit
import UIKit
@preconcurrency internal import CoreMotion   // quiets the implicit access warning

final class LizardScene: SKScene {

    // MARK: Public callback to UI
    /// Set by ContentView to bump counters safely on the main thread.
    var onSpawn: (() -> Void)?
    
    /// Callback for lizard count changes
    var onLizardCountChange: ((Int) -> Void)?

    // MARK: Configuration (using centralized AppConfiguration)
    private let gravityDown: CGFloat = AppConfiguration.Physics.gravityDown
    private var maxPhysicsLizards = AppConfiguration.Physics.maxPhysicsLizards
    private var baseLizardSize: CGFloat = AppConfiguration.Physics.baseLizardSize
    private var rainIntensity = AppConfiguration.Physics.rainDropsPerBurst
    private let lifetime: TimeInterval = AppConfiguration.Physics.lizardLifetime
    private var randomSizeLizards: Bool = false

    // MARK: Nodes/Assets
    private let physicsLayer = SKNode()
    private let weatherLayer = SKNode()
    private var lizardTexture: SKTexture?
    
    // MARK: Weather Effects
    private var currentWeatherCondition: WeatherCondition = .clear
    private var weatherTimer: Timer?

    // MARK: Debug overlay and performance tracking
    private let fpsLabel = SKLabelNode(fontNamed: "Menlo")
    private var smoothedDT: Double = 1.0 / 60.0
    private var lastUpdate: TimeInterval = 0
    private(set) var currentFPS: Double = 60
    private var consecutiveLowFPSFrames = 0
    private let lowFPSThreshold: Double = AppConfiguration.Performance.lowFPSThreshold
    private let maxConsecutiveLowFPS = AppConfiguration.Performance.maxConsecutiveLowFPS
    private var showFPSCounter: Bool {
        UserDefaults.standard.bool(forKey: "showFPSCounter")
    }

    // MARK: Lifetime pause
    private var agingPaused = false

    // MARK: Tilt
    private let motionMgr = CMMotionManager()
    private var tiltEnabled = false

    // MARK: Lifecycle
    override func didMove(to view: SKView) {
        super.didMove(to: view)

        // Essential setup first for immediate visual feedback
        backgroundColor = .clear
        view.allowsTransparency = true
        view.isOpaque = false
        view.ignoresSiblingOrder = true
        view.shouldCullNonVisibleNodes = true
        view.isAsynchronous = true
        view.preferredFramesPerSecond = 120   // ProMotion

        physicsWorld.gravity = CGVector(dx: 0, dy: gravityDown)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.categoryBitMask = 0x1 << 1

        addChild(physicsLayer)
        addChild(weatherLayer)
        
        // Setup minimal FPS overlay immediately for performance monitoring
        setupBasicFPSOverlay()
        
        // Defer ALL heavy initialization to avoid blocking startup
        Task.detached(priority: .utility) { [weak self] in
            // Small delay to let UI render first
            try? await Task.sleep(nanoseconds: 100_000_000) // 100ms
            await self?.performHeavyInitialization(view: view)
        }
    }
    
    private func setupBasicFPSOverlay() {
        fpsLabel.fontSize = 12
        fpsLabel.fontColor = .white
        fpsLabel.alpha = 0.9
        fpsLabel.zPosition = 9999
        fpsLabel.horizontalAlignmentMode = .right
        fpsLabel.verticalAlignmentMode = .top
        fpsLabel.isHidden = true  // Start hidden, will be shown after initialization
        addChild(fpsLabel)
        layoutFPSOverlay()
    }
    
    private func performHeavyInitialization(view: SKView) async {
        await MainActor.run {
            setupNotificationObservers()
            // Show FPS counter after initialization if enabled
            fpsLabel.isHidden = !showFPSCounter
            // Initialize weather effects after scene setup is complete
            updateWeatherEffects()
        }
        
        // Texture preparation happens lazily now - no preloading
        // Sound preloading deferred until first use
    }
    
    // MARK: - Notification Observers
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleFPSCounterToggled(_:)),
            name: .fpsCounterToggled,
            object: nil
        )
    }
    
    @objc private func handleFPSCounterToggled(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let enabled = userInfo["enabled"] as? Bool else { return }
        
        fpsLabel.isHidden = !enabled
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        // Note: Cannot access tiltEnabled or motionMgr properties from deinit
        // due to @MainActor isolation. The motion manager will be cleaned up
        // automatically when the scene is deallocated.
    }

    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.categoryBitMask = 0x1 << 1
        layoutFPSOverlay()
    }

    // MARK: Public API ---------------------------------------------------------

    func clearAll() {
        physicsLayer.removeAllActions()
        physicsLayer.removeAllChildren()
        updateLizardCount()
    }

    /// Pause/resume the lifetime actions (physics keeps running).
    func setAgingPaused(_ paused: Bool) {
        agingPaused = paused
        physicsLayer.children.forEach { $0.speed = paused ? 0 : 1 }
    }

    func emitBurstFromCenter(countRange: ClosedRange<Int>) {
        guard size != .zero else { return }
        let count = Int.random(in: countRange)
        for _ in 0..<count {
            let scale = randomSizeLizards ?
                CGFloat.random(in: 0.5...1.5) :
                CGFloat.random(in: 0.7...1.1)
            
            spawnLizard(
                at: CGPoint(x: size.width/2, y: size.height * 0.55),
                impulse: CGVector(dx: CGFloat.random(in: -150...150),
                                  dy: CGFloat.random(in: 140...280)),
                scale: scale,
                playSound: true
            )
        }
    }

    func emitFromCircleCenterRandom(sizeJitter: CGFloat) {
        guard size != .zero else { return }
        let scale = randomSizeLizards ?
            CGFloat.random(in: 0.4...1.6) :
            CGFloat.random(in: max(0.4, 1.0 - sizeJitter)...(1.0 + sizeJitter))
        
        spawnLizard(
            at: CGPoint(x: size.width/2, y: size.height * 0.55),
            impulse: CGVector(dx: CGFloat.random(in: -90...90),
                              dy: CGFloat.random(in: 120...220)),
            scale: scale,
            playSound: true
        )
    }
    
    /// Async version of emitFromCircleCenterRandom for better performance
    func emitFromCircleCenterRandomAsync(sizeJitter: CGFloat) {
        guard size != .zero else { return }
        
        // Check performance before spawning
        let tooManyLizards = physicsLayer.children.count >= maxPhysicsLizards - 5
        let shouldThrottle = consecutiveLowFPSFrames > maxConsecutiveLowFPS / 2
        
        if tooManyLizards || shouldThrottle { return }
        
        let scale = randomSizeLizards ?
            CGFloat.random(in: 0.4...1.6) :
            CGFloat.random(in: max(0.4, 1.0 - sizeJitter)...(1.0 + sizeJitter))
        
        spawnLizardAsync(
            at: CGPoint(x: size.width/2, y: size.height * 0.55),
            impulse: CGVector(dx: CGFloat.random(in: -90...90),
                              dy: CGFloat.random(in: 120...220)),
            scale: scale,
            playSound: true
        )
    }

    func rainOnce() {
        for _ in 0..<rainIntensity { rainStep() }
    }

    func rainStep() {
        guard size != .zero else { return }
        
        // Check if we have too many lizards or sustained low performance
        let tooManyLizards = physicsLayer.children.count > maxPhysicsLizards - 10
        let shouldThrottle = consecutiveLowFPSFrames > maxConsecutiveLowFPS
        
        if tooManyLizards || shouldThrottle { return }

        let x = CGFloat.random(in: 30...(size.width - 30))
        let y = size.height - 2
        let impulse = CGVector(dx: CGFloat.random(in: -40...40),
                               dy: CGFloat.random(in: -10...30))
        
        let scale = randomSizeLizards ?
            CGFloat.random(in: 0.3...1.2) :
            CGFloat.random(in: 0.45...0.9)
        
        spawnLizard(
            at: CGPoint(x: x, y: y),
            impulse: impulse,
            scale: scale,
            playSound: false
        )
    }

    // Tilt control
    func startTilt() {
        guard motionMgr.isDeviceMotionAvailable else { return }
        tiltEnabled = true
        motionMgr.deviceMotionUpdateInterval = AppConfiguration.Physics.motionUpdateInterval
        // Portrait-friendly frame
        motionMgr.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: .main) { [weak self] motion, _ in
            guard let self, self.tiltEnabled, let m = motion else { return }
            let gScale: CGFloat = AppConfiguration.Physics.gravityScale
            let deviceGx = CGFloat(m.gravity.x) * gScale
            let deviceGy = CGFloat(m.gravity.y) * gScale
            
            // Transform gravity based on interface orientation
            let transformedGravity = self.transformGravityForOrientation(deviceGx: deviceGx, deviceGy: deviceGy)
            self.physicsWorld.gravity = transformedGravity
        }
    }
    
    /// Transforms device motion gravity to interface coordinate system based on current orientation
    private func transformGravityForOrientation(deviceGx: CGFloat, deviceGy: CGFloat) -> CGVector {
        let orientation = currentInterfaceOrientation()
        
        switch orientation {
        case .portrait:
            // Portrait: device coordinates match interface coordinates
            return CGVector(dx: deviceGx, dy: deviceGy)
            
        case .landscapeLeft:
            // Landscape left: device is rotated 90° counter-clockwise
            // Device Y becomes screen X, Device X becomes screen -Y
            let dx = deviceGy
            let dy = -deviceGx
            return CGVector(dx: dx, dy: dy)
            
        case .landscapeRight:
            // Landscape right: device is rotated 90° clockwise
            // Device Y becomes screen -X, Device X becomes screen Y
            let dx = -deviceGy
            let dy = deviceGx
            return CGVector(dx: dx, dy: dy)
            
        case .portraitUpsideDown:
            // Portrait upside down: rotate gravity 180°
            // Device X becomes interface -X, Device Y becomes interface -Y
            // Prevent upward gravity: clamp Y component to be non-positive
            let dx = -deviceGx
            let dy = min(0, -deviceGy)  // Prevent lizards from falling toward top
            return CGVector(dx: dx, dy: dy)
            
        default:
            // Fallback to portrait mapping
            return CGVector(dx: deviceGx, dy: deviceGy)
        }
    }

    func stopTilt() {
        tiltEnabled = false
        motionMgr.stopDeviceMotionUpdates()
        physicsWorld.gravity = CGVector(dx: 0, dy: gravityDown)
    }
    
    // MARK: - Configuration Updates
    
    /// Updates the scene configuration with user settings
    func updateConfiguration(maxLizards: Int, lizardSize: CGFloat, rainIntensity: Int, randomSizeLizards: Bool = false) {
        self.maxPhysicsLizards = maxLizards
        self.rainIntensity = rainIntensity
        self.randomSizeLizards = randomSizeLizards
        
        // If lizard size changed, regenerate texture and update existing lizards
        if self.baseLizardSize != lizardSize {
            self.baseLizardSize = lizardSize
            regenerateLizardTexture()
        }
        
        // If max lizards was reduced, remove excess lizards
        let currentCount = physicsLayer.children.count
        if currentCount > maxLizards {
            let excessCount = currentCount - maxLizards
            for _ in 0..<excessCount {
                physicsLayer.children.first?.removeFromParent()
            }
            updateLizardCount()
        }
    }
    
    private func regenerateLizardTexture() {
        guard let view = self.view else { return }
        
        // Clear old texture
        lizardTexture = nil
        
        // Generate new texture with updated size
        let label = SKLabelNode(text: "🦎")
        label.fontSize = baseLizardSize
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        
        if let tex = view.texture(from: label) {
            tex.filteringMode = .nearest
            lizardTexture = tex
        } else {
            let dot = SKShapeNode(circleOfRadius: baseLizardSize * 0.5)
            dot.fillColor = .systemGreen
            dot.strokeColor = .clear
            lizardTexture = view.texture(from: dot)
        }
    }

    // MARK: Internals ----------------------------------------------------------

    private func prepareAssets(on view: SKView) {
        guard lizardTexture == nil else { return }
        let label = SKLabelNode(text: "🦎")
        label.fontSize = baseLizardSize
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        if let tex = view.texture(from: label) {
            tex.filteringMode = .nearest
            lizardTexture = tex
        } else {
            let dot = SKShapeNode(circleOfRadius: baseLizardSize * 0.5)
            dot.fillColor = .systemGreen
            dot.strokeColor = .clear
            lizardTexture = view.texture(from: dot)
        }
    }

    private func spawnLizard(at point: CGPoint,
                             impulse: CGVector,
                             scale: CGFloat,
                             playSound: Bool) {

        if playSound { SoundPlayer.shared.play(name: "lizard", ext: "wav") }

        if physicsLayer.children.count >= maxPhysicsLizards {
            physicsLayer.children.first?.removeFromParent()
        }

        // Lazy texture preparation - only create when first needed
        if lizardTexture == nil, let view = self.view {
            prepareAssets(on: view)
        }

        let node: SKSpriteNode
        if let t = lizardTexture {
            node = SKSpriteNode(texture: t, size: CGSize(width: baseLizardSize, height: baseLizardSize))
        } else {
            // Fallback without texture generation if view is not available
            node = SKSpriteNode(color: .systemGreen, size: CGSize(width: baseLizardSize, height: baseLizardSize))
        }

        node.name = "lizard"
        node.setScale(scale)
        node.position = point
        node.zPosition = 1
        node.speed = agingPaused ? 0 : 1
        physicsLayer.addChild(node)
        updateLizardCount()

        // 🔔 Notify UI
        onSpawn?() // direct callback to ContentView
        NotificationCenter.default.post(name: .lizardSpawned, object: nil) // optional for any other listeners

        // Physics
        let radius = (baseLizardSize * 0.45) * scale
        let body = SKPhysicsBody(circleOfRadius: radius)
        body.affectedByGravity = true
        body.usesPreciseCollisionDetection = false
        body.mass = 0.08
        body.restitution = 0.25
        body.friction = 0.8
        body.linearDamping = 0.1
        node.physicsBody = body

        body.applyImpulse(impulse)

        node.run(.sequence([
            .wait(forDuration: lifetime),
            .fadeOut(withDuration: 0.25),
            .run { [weak self] in
                self?.updateLizardCount()
            },
            .removeFromParent()
        ]))
    }
    
    /// Async version of spawnLizard for better performance
    private func spawnLizardAsync(at point: CGPoint,
                                  impulse: CGVector,
                                  scale: CGFloat,
                                  playSound: Bool) {
        
        // Perform expensive operations on background thread
        Task.detached(priority: .userInitiated) { [weak self] in
            guard let self = self else { return }
            
            // Pre-calculate physics properties off main thread
            let radius = (self.baseLizardSize * 0.45) * scale
            let physicsProperties = PhysicsProperties(
                radius: radius,
                mass: 0.08,
                restitution: 0.25,
                friction: 0.8,
                linearDamping: 0.1,
                impulse: impulse
            )
            
            // Switch back to main thread only for scene modifications
            await MainActor.run {
                self.createLizardNode(at: point, scale: scale, playSound: playSound, physicsProperties: physicsProperties)
            }
        }
    }
    
    /// Helper struct for pre-calculated physics properties
    private struct PhysicsProperties {
        let radius: CGFloat
        let mass: CGFloat
        let restitution: CGFloat
        let friction: CGFloat
        let linearDamping: CGFloat
        let impulse: CGVector
    }
    
    /// Creates the lizard node with pre-calculated physics properties
    private func createLizardNode(at point: CGPoint,
                                  scale: CGFloat,
                                  playSound: Bool,
                                  physicsProperties: PhysicsProperties) {
        
        if playSound { SoundPlayer.shared.play(name: "lizard", ext: "wav") }
        
        if physicsLayer.children.count >= maxPhysicsLizards {
            physicsLayer.children.first?.removeFromParent()
        }
        
        // Lazy texture preparation - only create when first needed
        if lizardTexture == nil, let view = self.view {
            prepareAssets(on: view)
        }
        
        let node: SKSpriteNode
        if let t = lizardTexture {
            node = SKSpriteNode(texture: t, size: CGSize(width: baseLizardSize, height: baseLizardSize))
        } else {
            // Fallback without texture generation if view is not available
            node = SKSpriteNode(color: .systemGreen, size: CGSize(width: baseLizardSize, height: baseLizardSize))
        }
        
        node.name = "lizard"
        node.setScale(scale)
        node.position = point
        node.zPosition = 1
        node.speed = agingPaused ? 0 : 1
        physicsLayer.addChild(node)
        updateLizardCount()
        
        // 🔔 Notify UI
        onSpawn?() // direct callback to ContentView
        NotificationCenter.default.post(name: .lizardSpawned, object: nil) // optional for any other listeners
        
        // Apply pre-calculated physics properties
        let body = SKPhysicsBody(circleOfRadius: physicsProperties.radius)
        body.affectedByGravity = true
        body.usesPreciseCollisionDetection = false
        body.mass = physicsProperties.mass
        body.restitution = physicsProperties.restitution
        body.friction = physicsProperties.friction
        body.linearDamping = physicsProperties.linearDamping
        node.physicsBody = body
        
        body.applyImpulse(physicsProperties.impulse)
        
        node.run(.sequence([
            .wait(forDuration: lifetime),
            .fadeOut(withDuration: 0.25),
            .run { [weak self] in
                self?.updateLizardCount()
            },
            .removeFromParent()
        ]))
    }
    
    // MARK: - Lizard Count Tracking
    
    private func updateLizardCount() {
        let count = physicsLayer.children.count
        DispatchQueue.main.async { [weak self] in
            self?.onLizardCountChange?(count)
        }
    }

    // MARK: FPS overlay
    private func setupFPSOverlay() {
        fpsLabel.fontSize = 12
        fpsLabel.fontColor = .white
        fpsLabel.alpha = 0.9
        fpsLabel.zPosition = 9999
        fpsLabel.horizontalAlignmentMode = .right
        fpsLabel.verticalAlignmentMode = .top
        fpsLabel.isHidden = !showFPSCounter  // Initially hidden based on user setting
        addChild(fpsLabel)
        layoutFPSOverlay()
    }

    private func layoutFPSOverlay() {
        fpsLabel.position = CGPoint(x: size.width - 15, y: size.height - 40)
    }

    override func update(_ currentTime: TimeInterval) {
        if lastUpdate == 0 { lastUpdate = currentTime }
        let dt = max(0.0001, currentTime - lastUpdate)
        lastUpdate = currentTime

        let alpha = AppConfiguration.Performance.fpsUpdateAlpha
        smoothedDT = smoothedDT * (1 - alpha) + dt * alpha
        currentFPS = 1.0 / smoothedDT

        // Track consecutive low FPS frames for performance throttling
        if currentFPS < lowFPSThreshold {
            consecutiveLowFPSFrames += 1
            
            // Performance degradation protection
            if consecutiveLowFPSFrames > maxConsecutiveLowFPS {
                // Remove oldest lizards to improve performance
                let currentCount = physicsLayer.children.count
                let removalCount = min(currentCount / 4, 10) // Remove up to 25% but max 10
                for _ in 0..<removalCount {
                    physicsLayer.children.first?.removeFromParent()
                }
                consecutiveLowFPSFrames = 0 // Reset counter after cleanup
            }
        } else {
            consecutiveLowFPSFrames = 0
        }

        // Update FPS display only if it's significantly different (reduce UI updates)
        let roundedFPS = currentFPS.rounded()
        if let currentText = fpsLabel.text,
           let currentFPSFromText = Double(currentText.replacingOccurrences(of: " FPS", with: "")),
           abs(currentFPSFromText - roundedFPS) < 1.0 {
            // Skip update if change is less than 1 FPS
        } else {
            fpsLabel.text = String(format: "%.0f FPS", roundedFPS)
        }
    }
    
    // MARK: - Interface Orientation Helper
    
    /// Gets the current interface orientation for gravity transformation
    private func currentInterfaceOrientation() -> UIInterfaceOrientation {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .portrait
        }
        return windowScene.interfaceOrientation
    }
    
    // MARK: - Weather Effects
    
    enum WeatherCondition {
        case clear
        case rain
    }
    
    func setWeatherCondition(_ condition: WeatherCondition) {
        currentWeatherCondition = condition
        
        switch condition {
        case .clear:
            // Clear weather: no effects
            weatherLayer.removeAllChildren()
            
        case .rain:
            // Rainy weather: implement rain effect (not yet available)
            weatherLayer.isHidden = true
        }
    }
    
    /// Call this method when weather settings change
    func refreshWeatherEffects() {
        updateWeatherEffects()
    }
    
    /// Updates weather effects based on current weather condition and user settings
    func updateWeatherEffects() {
        let weatherOffMode = UserDefaults.standard.bool(forKey: "weatherOffMode")
        let weatherAutoMode = UserDefaults.standard.bool(forKey: "weatherAutoMode")
        let manualWeatherCondition = UserDefaults.standard.string(forKey: "manualWeatherCondition") ?? "clear"
        
        // Debug logging to help identify issues
        print("🌦️ Weather Debug - Off: \(weatherOffMode), Auto: \(weatherAutoMode), Manual: \(manualWeatherCondition)")
        
        // Remove existing weather effects
        clearWeatherEffects()
        
        // Early exit if weather is disabled
        if weatherOffMode {
            print("🌦️ Weather disabled by user")
            return
        }
        
        // Determine current weather condition
        let currentCondition: String
        if weatherAutoMode {
            // Auto mode - determine weather based on time or other factors
            currentCondition = "clear" // Default to clear weather
            print("☀️ Auto mode enabled - using clear weather")
        } else {
            currentCondition = manualWeatherCondition
            print("🌦️ Manual weather condition: \(currentCondition)")
        }
        
        // Apply appropriate weather effects
        switch currentCondition.lowercased() {
        case "rain":
            print("🌧️ Adding rain effects (placeholder)")
            addRainVortexEffects()
        case "storm":
            print("⛈️ Adding storm effects (placeholder)")
            addStormVortexEffects()
        default:
            print("☀️ Clear weather - no effects")
            break
        }
    }
    
    private func clearWeatherEffects() {
        // Remove all weather effects
        weatherLayer.removeAllChildren()
    }
    
    private func addRainVortexEffects() {
        // Implement rain vortex effects (placeholder for now)
        // This would create rain particle emitters similar to snow but with different properties
    }
    
    private func addStormVortexEffects() {
        // Implement storm vortex effects combining rain with lightning
        addRainVortexEffects()
        // Add lightning effects, etc.
    }
}
