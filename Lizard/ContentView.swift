import SwiftUI
import SpriteKit
import AVFoundation
import GameKit
import Combine
import UIKit // For app lifecycle notifications
import Vortex

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.scenePhase) private var scenePhase // Track app lifecycle
    @State private var scene = LizardScene(size: .zero)
    @AppStorage("totalLizardsSpawned") private var totalSpawned = 0
    @AppStorage("mainButtonTaps")      private var mainButtonTaps = 0

    // User-configurable settings
    @AppStorage("maxLizards") private var maxLizards: Int = 300
    @AppStorage("lizardSize") private var lizardSize: Double = 80.0
    @AppStorage("rainIntensity") private var rainIntensity: Int = 15
    @AppStorage("randomSizeLizards") private var randomSizeLizards: Bool = false
    @AppStorage("backgroundType") private var backgroundType: String = "dynamic"

    @State private var isPressingMain = false
    @State private var spewTimer: Timer?
    @State private var rainTimer: Timer?
    
    // UI state tracking
    @State private var isRaining = false
    @State private var lizardCount = 0
    @State private var showStopButton = false
    @State private var showTrashButton = false
    @State private var buttonHideWorkItem: DispatchWorkItem?
    
    // MARK: - State Management
    
    @State private var showSettings = false
    @State private var totalLizardsSpawned = 0
    @State private var totalButtonTaps = 0
    @State private var gameScene = LizardScene()
    
    // Firework state variables
    @State private var showVortexFireworks = false
    @State private var vortexFireworksDismissTimer: Timer?
    
    // Dynamic Island vortex fireworks state
    @State private var dynamicIslandVortexSystem: VortexSystem?
    @State private var dynamicIslandFireworks = false
    
    // Beta feedback integration
    @State private var showBetaFeedback = false
    
    // Firework customization settings
    @AppStorage("fireworkDensity") private var fireworkDensity: Double = 0.5
    @AppStorage("fireworkDuration") private var fireworkDuration: Double = 5.0
    @AppStorage("fireworkShowLength") private var fireworkShowLength: Double = 5.0
    @AppStorage("fireworkColorScheme") private var fireworkColorScheme: String = "vibrant"
    @AppStorage("fireworkSoundEnabled") private var fireworkSoundEnabled: Bool = true
    
    // Add the missing comprehensive firework settings
    @AppStorage("fireworkEnabled") private var fireworkEnabled: Bool = true
    @AppStorage("fireworkIntensity") private var fireworkIntensity: Double = 0.5
    @AppStorage("fireworkParticleCount") private var fireworkParticleCount: Int = 100
    @AppStorage("fireworkExplosionPattern") private var fireworkExplosionPattern: String = "burst"
    @AppStorage("fireworkTrailEnabled") private var fireworkTrailEnabled: Bool = true
    @AppStorage("fireworkGlowEnabled") private var fireworkGlowEnabled: Bool = true
    @AppStorage("fireworkMultiColor") private var fireworkMultiColor: Bool = false
    @AppStorage("fireworkGravityAffected") private var fireworkGravityAffected: Bool = true
    @AppStorage("fireworkFadeSpeed") private var fireworkFadeSpeed: Double = 1.0
    @AppStorage("fireworkScale") private var fireworkScale: Double = 1.0

    // MARK: Configuration
    private struct Config {
        static let spewTimerInterval: TimeInterval = 0.07
        static let rainTimerInterval: TimeInterval = 0.08
        static let centerButtonSize: CGFloat = 240
        static let lizardImageSize: CGFloat = 180
        static let buttonCornerRadius: CGFloat = 20
        static let shadowRadius: CGFloat = 10
        static let sizeJitterHold: CGFloat = 0.6
        static let sizeJitterSingle: CGFloat = 0.2
        
        // iOS 26 liquid glass configurations
        static let liquidGlassCornerRadius: CGFloat = 28
        static let liquidGlassDepth: CGFloat = 12
        static let liquidGlassBlur: CGFloat = 20
        static let liquidGlassHighlight: CGFloat = 0.7
        static let liquidGlassShadow: CGFloat = 0.3
        static let liquidGlassReflection: CGFloat = 0.25
        
        // Animation configurations
        static let buttonHideDelay: TimeInterval = 2.0
        static let buttonAnimationDuration: TimeInterval = 0.4
        static let jitterIntensity: CGFloat = 2.0
        static let jitterSpeed: TimeInterval = 0.1
    }

    private let lbTotalLizards = "com.town3r.lizard.totalspawned"
    private let lbButtonTaps  = "com.town3r.lizard.buttontaps"

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack {
                // Background switching based on user preference
                backgroundView
                    .ignoresSafeArea()
                
                // Game content with TransparentSpriteView
                TransparentSpriteView(scene: scene, preferredFPS: 120)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)

                topLeftHUD
                topRightHUD
                bottomBar
                centerButton(size: size)
                
                // Vortex fireworks overlay with user customization
                if showVortexFireworks && fireworkEnabled {
                    CustomizableVortexFireworks(
                        intensity: fireworkIntensity,
                        particleCount: fireworkParticleCount,
                        scale: fireworkScale,
                        multiColor: fireworkMultiColor,
                        trailEnabled: fireworkTrailEnabled,
                        glowEnabled: fireworkGlowEnabled,
                        fadeSpeed: fireworkFadeSpeed,
                        gravityAffected: fireworkGravityAffected
                    )
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                    .onTapGesture {
                        // Allow tap to dismiss fireworks
                        withAnimation(.easeOut(duration: 1.0)) {
                            showVortexFireworks = false
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.3).combined(with: .opacity).animation(.easeOut(duration: 0.8)),
                        removal: .scale(scale: 1.5).combined(with: .opacity).animation(.easeIn(duration: 0.5))
                    ))
                }
            }
            .onAppear {
                // Essential scene setup first for immediate UI response
                scene.scaleMode = .resizeFill
                scene.size = size
                scene.backgroundColor = .clear
                
                // Set up scene callbacks immediately for UI responsiveness
                scene.onLizardCountChange = { count in
                    Task { @MainActor in
                        lizardCount = count
                        updateButtonVisibility()
                    }
                }
                
                // Defer heavy initialization to background to avoid blocking UI
                Task.detached(priority: .userInitiated) {
                    await MainActor.run {
                        performDeferredInitialization()
                    }
                }
            }
            .onChange(of: size) { _, newSize in
                Task { @MainActor in
                    scene.size = newSize
                }
            }
            .onChange(of: colorScheme) { _, _ in
                Task { @MainActor in
                    scene.backgroundColor = .clear
                }
            }
            .onDisappear {
                Task { @MainActor in
                    scene.stopTilt()
                    stopSpewHold()
                    stopRainHold()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .lizardSpawned)) { _ in
                Task { @MainActor in
                    totalSpawned += 1
                    reportScoresIfReady()
                }
            }
            .onChange(of: scenePhase) { _, newPhase in
                Task { @MainActor in
                    switch newPhase {
                    case .background:
                        scene.setAgingPaused(true)
                        stopSpewHold()
                        stopRainHold()
                    case .active:
                        break
                    case .inactive:
                        stopSpewHold()
                        stopRainHold()
                    @unknown default:
                        break
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch backgroundType {
        case "dynamic":
            DynamicBackgroundView()
        case "solid":
            SolidBackgroundView()
        case "gradient":
            GradientBackgroundView()
        default:
            DynamicBackgroundView()
        }
    }
}

private extension ContentView {
    // HUD counters at top left with iOS 26 liquid glass styling and single settings button
    var topLeftHUD: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Counter display
            VStack(alignment: .leading, spacing: 6) {
                Text("🦎 \(totalSpawned)")
                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
                    .foregroundStyle(.primary)
                Text("🔘 \(mainButtonTaps)")
                    .font(.system(size: 14, weight: .regular, design: .monospaced))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background {
                iOS26LiquidGlass(isPressed: false, size: .small)
            }
            .onTapGesture {
                // Open GameCenter on tap
                GameCenterManager.shared.presentLeaderboards()
            }
        }
        .padding(.top, 12)
        .padding(.leading, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    // HUD settings icon at top right, positioned below the FPS counter
    var topRightHUD: some View {
        VStack(alignment: .trailing, spacing: 8) {
            // Settings control button positioned below where FPS counter appears
            Button {
                showSettings.toggle()
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.primary)
                    .padding(10)
                    .background {
                        iOS26LiquidGlass(isPressed: false, size: .small)
                    }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Settings")
            .accessibilityHint("Tap to open settings")
        }
        .padding(.top, 14)
        .padding(.trailing, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .sheet(isPresented: $showSettings) {
            SettingsView(onFireworksTrigger: triggerVortexFireworks)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
    
    // Center circle button for spawning a lizard with iOS 26 liquid glass effect
    func centerButton(size: CGSize) -> some View {
        Button {
            mainButtonTaps += 1
            scene.setAgingPaused(false)
            scene.emitFromCircleCenterRandom(sizeJitter: Config.sizeJitterSingle)
            SoundPlayer.shared.play(name: "lizard", ext: "wav")
            reportScoresIfReady()
        } label: {
            ZStack {
                // Main iOS 26 liquid glass circle
                Circle()
                    .fill(.clear)
                    .background {
                        iOS26LiquidGlassCircle(isPressed: isPressingMain)
                    }
                
                // Lizard image with enhanced styling
                Image("lizard")
                    .resizable()
                    .scaledToFit()
                    .frame(width: Config.lizardImageSize, height: Config.lizardImageSize)
                    .clipShape(Circle())
                    .padding(20)
                    .scaleEffect(isPressingMain ? 0.95 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressingMain)
                
                // Vortex magic circle effect - positioned behind button, larger radius
                if isPressingMain {
                    VortexView(.magic.makeUniqueCopy()) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                            .blendMode(.plusLighter)
                            .tag("sparkle")
                    }
                    .frame(width: Config.centerButtonSize * 1.5, height: Config.centerButtonSize * 1.5)
                    .allowsHitTesting(false)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8).combined(with: .opacity).animation(.easeOut(duration: 0.3)),
                        removal: .scale(scale: 1.2).combined(with: .opacity).animation(.easeIn(duration: 0.2))
                    ))
                }
            }
        }
        .frame(width: Config.centerButtonSize, height: Config.centerButtonSize)
        .position(x: size.width * 0.5, y: size.height * 0.5)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    guard !isPressingMain else { return }
                    isPressingMain = true
                    startSpewHold()
                }
                .onEnded { _ in
                    isPressingMain = false
                    stopSpewHold()
                }
        )
    }

    // Bottom bar with iOS 26 liquid glass styling and dynamic layout
    var bottomBar: some View {
        VStack {
            HStack(spacing: 12) {
                // Make it Rain button with jitter effect
                iOS26LiquidGlassButton(
                    title: "🦎 Make it Rain 🦎",
                    font: .system(size: 20, weight: .bold),
                    style: .primary,
                    isJittering: isRaining
                ) {
                    scene.setAgingPaused(false)
                    scene.rainOnce()
                    reportScoresIfReady()
                }
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: .infinity)
                        .onChanged { _ in
                            scene.setAgingPaused(false)
                            startRainHold()
                        }
                        .onEnded { _ in
                            stopRainHold()
                        }
                )

                // Stop button (pause.circle.fill is perfect for this)
                if showStopButton {
                    iOS26LiquidGlassButton(
                        systemImage: "pause.circle.fill",
                        font: .system(size: 24),
                        style: .secondary,
                        width: 60
                    ) {
                        stopRainHold()
                        scene.setAgingPaused(true)
                        scheduleButtonHide()
                    }
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity).animation(.spring(response: Config.buttonAnimationDuration, dampingFraction: 0.8)),
                        removal: .scale.combined(with: .opacity).animation(.easeInOut(duration: Config.buttonAnimationDuration))
                    ))
                }

                // Clear button
                if showTrashButton {
                    iOS26LiquidGlassButton(
                        systemImage: "trash",
                        font: .system(size: 20, weight: .bold),
                        style: .secondary,
                        width: 60
                    ) {
                        stopRainHold()
                        scene.clearAll()
                        scheduleButtonHide()
                    }
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity).animation(.spring(response: Config.buttonAnimationDuration, dampingFraction: 0.8)),
                        removal: .scale.combined(with: .opacity).animation(.easeInOut(duration: Config.buttonAnimationDuration))
                    ))
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
    }

    // MARK: - Button Visibility Logic
    
    func updateButtonVisibility() {
        withAnimation(.spring(response: Config.buttonAnimationDuration, dampingFraction: 0.8)) {
            // Don't show buttons during firework shows for clean viewing
            if showVortexFireworks {
                showStopButton = false
                showTrashButton = false
            } else {
                showStopButton = isRaining
                showTrashButton = lizardCount > 0
            }
        }
    }
    
    func scheduleButtonHide() {
        // Cancel any previously scheduled hide
        buttonHideWorkItem?.cancel()
        
        // Create a new work item
        let workItem = DispatchWorkItem {
            withAnimation(.easeInOut(duration: Config.buttonAnimationDuration)) {
                // Don't hide buttons during firework shows - let firework logic control visibility
                if !self.showVortexFireworks {
                    if !self.isRaining {
                        self.showStopButton = false
                    }
                    if self.lizardCount == 0 {
                        self.showTrashButton = false
                    }
                }
            }
        }
        buttonHideWorkItem = workItem
        
        // Schedule the work item to run after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + Config.buttonHideDelay, execute: workItem)
    }

    // Hold logic
    func startSpewHold() {
        spewTimer?.invalidate()
        scene.setAgingPaused(false)
        spewTimer = Timer.scheduledTimer(withTimeInterval: Config.spewTimerInterval, repeats: true) { _ in
            Task { @MainActor in
                scene.emitFromCircleCenterRandom(sizeJitter: Config.sizeJitterHold)
                SoundPlayer.shared.play(name: "lizard", ext: "wav")
            }
        }
        if let spewTimer { RunLoop.main.add(spewTimer, forMode: .common) }
    }

    func stopSpewHold() {
        spewTimer?.invalidate()
        spewTimer = nil
    }

    func startRainHold() {
        isRaining = true
        updateButtonVisibility()

        rainTimer?.invalidate()
        rainTimer = Timer.scheduledTimer(withTimeInterval: Config.rainTimerInterval, repeats: true) { _ in
            Task { @MainActor in
                scene.rainStep()
            }
        }
        if let rainTimer { RunLoop.main.add(rainTimer, forMode: .common) }
    }

    func stopRainHold() {
        isRaining = false
        updateButtonVisibility()
        scheduleButtonHide()
        
        rainTimer?.invalidate()
        rainTimer = nil
    }

    // Game Center reporting - EXACT METHOD SIGNATURES FROM GAMECENTERMANAGER.SWIFT
    func reportScoresIfReady() {
        // EXACTLY from search results: report(scores: [(id: String, value: Int)], context: Int = 0)
        GameCenterManager.shared.report(
            scores: [
                (id: lbTotalLizards, value: totalSpawned),
                (id: lbButtonTaps,  value: mainButtonTaps)
            ],
            context: 0
        )
        
        // EXACTLY from search results: reportAchievements(totalSpawned: Int, buttonTaps: Int)
        GameCenterManager.shared.reportAchievements(
            totalSpawned: totalSpawned,
            buttonTaps: mainButtonTaps
        )
    }
    
    // Settings configuration update
    func updateSceneConfiguration() {
        scene.updateConfiguration(
            maxLizards: maxLizards,
            lizardSize: CGFloat(lizardSize),
            rainIntensity: rainIntensity,
            randomSizeLizards: randomSizeLizards
        )
    }
    
    // Helper function to check if running in simulator
    private func isSimulator() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    // MARK: - Firework Show Logic
    
    // Trigger the Vortex fireworks show
    func triggerVortexFireworks() {
        // Cancel any existing dismiss timer
        vortexFireworksDismissTimer?.invalidate()
        vortexFireworksDismissTimer = nil
        
        // Hide buttons during firework show for clean viewing
        withAnimation(.easeOut(duration: 0.5)) {
            showStopButton = false
            showTrashButton = false
        }
        
        // Double haptic feedback when show is about to start
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
        
        // Second haptic feedback after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            impactFeedback.impactOccurred()
        }
        
        // Play audio feedback only if sound effects are enabled
        if fireworkSoundEnabled {
            SoundPlayer.shared.play(name: "lizard", ext: "wav")
        }
        
        // Show fireworks with dramatic animation
        withAnimation(.easeOut(duration: 0.8)) {
            showVortexFireworks = true
        }
        
        // Auto-dismiss fireworks after user-configured duration
        let dismissDelay = fireworkShowLength
        vortexFireworksDismissTimer = Timer.scheduledTimer(withTimeInterval: dismissDelay, repeats: false) { _ in
            Task { @MainActor in
                withAnimation(.easeIn(duration: 1.0)) {
                    showVortexFireworks = false
                }
                vortexFireworksDismissTimer = nil
                
                // Restore button visibility after firework show ends
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    updateButtonVisibility()
                }
            }
        }
        
        if let timer = vortexFireworksDismissTimer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    // MARK: - Deferred Initialization
    
    /// Performs heavy initialization tasks in the background to avoid blocking UI startup
    @MainActor
    private func performDeferredInitialization() {
        // Start tilt motion after UI is ready
        scene.startTilt()
        
        // Update scene configuration with user settings
        updateSceneConfiguration()
        
        // Initialize GameCenter authentication (heavy operation)
        GameCenterManager.shared.authenticate(presentingViewController: { topViewController() })
        GameCenterManager.shared.configureAccessPoint(isActive: false, location: .topTrailing)
    }
}

// MARK: - iOS 26 Liquid Glass Components

struct iOS26LiquidGlassButton: View {
    let title: String?
    let systemImage: String?
    let font: Font
    let style: ButtonStyle
    let width: CGFloat?
    let isJittering: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var jitterOffset: CGSize = .zero
    @State private var jitterTimer: Timer?
    
    enum ButtonStyle {
        case primary, secondary
    }
    
    init(title: String, font: Font, style: ButtonStyle, width: CGFloat? = nil, isJittering: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = nil
        self.font = font
        self.style = style
        self.width = width
        self.isJittering = isJittering
        self.action = action
    }
    
    init(systemImage: String, font: Font, style: ButtonStyle, width: CGFloat? = nil, isJittering: Bool = false, action: @escaping () -> Void) {
        self.title = nil
        self.systemImage = systemImage
        self.font = font
        self.style = style
        self.width = width
        self.isJittering = isJittering
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Group {
                if let title = title {
                    Text(title)
                        .font(font)
                } else if let systemImage = systemImage {
                    Image(systemName: systemImage)
                        .font(font)
                }
            }
            .foregroundStyle(style == .primary ? .primary : .secondary)
            .padding(.vertical, 16)
            .frame(maxWidth: width == nil ? .infinity : width)
        }
        .buttonStyle(.plain)
        .background {
            iOS26LiquidGlass(isPressed: isPressed, size: .medium)
        }
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .offset(jitterOffset)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .onAppear {
            if isJittering {
                startJittering()
            }
        }
        .onChange(of: isJittering) { _, newValue in
            if newValue {
                startJittering()
            } else {
                stopJittering()
            }
        }
        .onDisappear {
            stopJittering()
        }
    }
    
    private func startJittering() {
        jitterTimer?.invalidate()

        jitterTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            Task { @MainActor in
                guard isJittering else { return }

                withAnimation(.easeInOut(duration: 0.1)) {
                    jitterOffset = CGSize(
                        width: Double.random(in: -2.0...2.0),
                        height: Double.random(in: -2.0...2.0)
                    )
                }
            }
        }
    }
    
    private func stopJittering() {
        jitterTimer?.invalidate()
        jitterTimer = nil
        
        withAnimation(.easeOut(duration: 0.2)) {
            jitterOffset = .zero
        }
    }
}

struct iOS26LiquidGlass: View {
    let isPressed: Bool
    let size: Size
    @Environment(\.colorScheme) private var colorScheme
    
    enum Size {
        case small, medium, large
        
        var cornerRadius: CGFloat {
            switch self {
            case .small: return 16
            case .medium: return 24
            case .large: return 32
            }
        }
        
        var depth: CGFloat {
            switch self {
            case .small: return 6
            case .medium: return 8
            case .large: return 12
            }
        }
        
        var strokeWidth: CGFloat {
            switch self {
            case .small: return 1.0
            case .medium: return 1.5
            case .large: return 2.0
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Base liquid glass material - perfectly balanced visibility
            RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                .fill(.regularMaterial.opacity(isPressed ? 0.4 : 0.3))
                .overlay {
                    RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial.opacity(isPressed ? 0.6 : 0.5))
                }
            
            // Prominent edge highlights like iOS 26
            RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            .white.opacity(isPressed ? 0.5 : 0.7),
                            .white.opacity(isPressed ? 0.3 : 0.4),
                            .white.opacity(isPressed ? 0.1 : 0.2),
                            .clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: size.strokeWidth
                )
            
            // Inner glass reflection with proper iOS 26 intensity
            RoundedRectangle(cornerRadius: size.cornerRadius - 2, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            .white.opacity(isPressed ? 0.2 : 0.3),
                            .white.opacity(isPressed ? 0.1 : 0.15),
                            .clear,
                            .clear,
                            .black.opacity(isPressed ? 0.08 : 0.12)
                        ],
                        startPoint: UnitPoint(x: 0.2, y: 0.2),
                        endPoint: UnitPoint(x: 0.8, y: 0.8)
                    )
                )
                .padding(2)
            
            // Ambient reflection layer for depth
            RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                .fill(
                    RadialGradient(
                        colors: [
                            .white.opacity(isPressed ? 0.15 : 0.25),
                            .clear
                        ],
                        center: UnitPoint(x: 0.3, y: 0.3),
                        startRadius: 8,
                        endRadius: size.cornerRadius * 2
                    )
                )
        }
        .compositingGroup()
        .shadow(
            color: .black.opacity(isPressed ? 0.2 : 0.3),
            radius: isPressed ? size.depth * 0.6 : size.depth,
            x: 0,
            y: isPressed ? size.depth * 0.3 : size.depth * 0.6
        )
        .shadow(
            color: .black.opacity(isPressed ? 0.08 : 0.12),
            radius: isPressed ? size.depth * 0.3 : size.depth * 0.5,
            x: 0,
            y: isPressed ? size.depth * 0.15 : size.depth * 0.25
        )
    }
}

struct iOS26LiquidGlassCircle: View {
    let isPressed: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Base liquid glass material with iOS 26 visibility
            Circle()
                .fill(.regularMaterial.opacity(isPressed ? 0.35 : 0.25))
                .overlay {
                    Circle()
                        .fill(.ultraThinMaterial.opacity(isPressed ? 0.6 : 0.5))
                }
            
            // Prominent edge highlight ring matching iOS 26
            Circle()
                .stroke(
                    AngularGradient(
                        colors: [
                            .white.opacity(isPressed ? 0.6 : 0.8),
                            .white.opacity(isPressed ? 0.4 : 0.6),
                            .white.opacity(isPressed ? 0.2 : 0.3),
                            .white.opacity(isPressed ? 0.4 : 0.6)
                        ],
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    lineWidth: 2
                )
                .blur(radius: 0.5)
            
            // Secondary highlight ring for definition
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            .white.opacity(isPressed ? 0.4 : 0.6),
                            .white.opacity(isPressed ? 0.1 : 0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
            
            // Complex glass reflection with iOS 26 intensity
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            .white.opacity(isPressed ? 0.2 : 0.35),
                            .white.opacity(isPressed ? 0.12 : 0.2),
                            .clear,
                            .clear,
                            .black.opacity(isPressed ? 0.05 : 0.08)
                        ],
                        center: UnitPoint(x: 0.25, y: 0.25),
                        startRadius: 20,
                        endRadius: 120
                    )
                )
            
            // Ambient light reflection
            Circle()
                .fill(
                    EllipticalGradient(
                        colors: [
                            .white.opacity(isPressed ? 0.15 : 0.25),
                            .clear
                        ],
                        center: UnitPoint(x: 0.7, y: 0.3),
                        startRadiusFraction: 0.1,
                        endRadiusFraction: 0.8
                    )
                )
            
            // Inner depth ring for enhanced 3D effect
            Circle()
                .stroke(
                    .black.opacity(isPressed ? 0.12 : 0.08),
                    lineWidth: 1
                )
                .padding(16)
        }
        .compositingGroup()
        .shadow(
            color: .black.opacity(isPressed ? 0.25 : 0.4),
            radius: isPressed ? 15 : 20,
            x: 0,
            y: isPressed ? 8 : 12
        )
        .shadow(
            color: .black.opacity(isPressed ? 0.12 : 0.18),
            radius: isPressed ? 8 : 12,
            x: 0,
            y: isPressed ? 4 : 6
        )
        .overlay {
            // Outer glow for premium iOS 26 feel
            Circle()
                .stroke(
                    RadialGradient(
                        colors: [
                            .white.opacity(isPressed ? 0.25 : 0.4),
                            .clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 15
                    ),
                    lineWidth: 1.5
                )
                .blur(radius: 1.5)
                .padding(-2)
        }
    }
}

// MARK: - Vortex Magic Circle Component

private struct VortexMagicCircle: View {
    @State private var rotation: Double = 0
    @State private var particleRotations: [Double] = []
    
    // Vortex configuration constants
    private let vortexCircleCount: Int = 3
    private let vortexBaseRadius: CGFloat = 160
    private let vortexRadiusSpacing: CGFloat = 30
    private let vortexRotationSpeed: TimeInterval = 2.0
    private let vortexParticleCount: Int = 12
    
    var body: some View {
        ZStack {
            // Multiple concentric magic circles
            ForEach(0..<vortexCircleCount, id: \.self) { index in
                let radius = vortexBaseRadius + CGFloat(index) * vortexRadiusSpacing
                let reverseRotation = index % 2 == 0
                
                MagicCircleRing(
                    radius: radius,
                    rotation: reverseRotation ? -rotation : rotation,
                    opacity: 1.0 - (Double(index) * 0.2)
                )
            }
            
            // Floating magical particles around the circles
            ForEach(0..<vortexParticleCount, id: \.self) { index in
                MagicalParticle(
                    index: index,
                    totalParticles: vortexParticleCount,
                    baseRadius: vortexBaseRadius * 1.2,
                    rotation: particleRotations.indices.contains(index) ? particleRotations[index] : 0
                )
            }
        }
        .onAppear {
            setupParticleRotations()
            startRotationAnimation()
        }
    }
    
    private func setupParticleRotations() {
        particleRotations = (0..<vortexParticleCount).map { index in
            Double.random(in: 0...360) + Double(index) * (360.0 / Double(vortexParticleCount))
        }
    }
    
    private func startRotationAnimation() {
        withAnimation(.linear(duration: vortexRotationSpeed).repeatForever(autoreverses: false)) {
            rotation = 360
        }
        
        // Animate each particle with slight variation
        for index in 0..<vortexParticleCount {
            let delay = Double(index) * 0.1
            let speed = vortexRotationSpeed * Double.random(in: 0.8...1.2)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.linear(duration: speed).repeatForever(autoreverses: false)) {
                    if particleRotations.indices.contains(index) {
                        particleRotations[index] += 360
                    }
                }
            }
        }
    }
}

private struct MagicCircleRing: View {
    let radius: CGFloat
    let rotation: Double
    let opacity: Double
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Outer mystical glow ring
            Circle()
                .stroke(
                    AngularGradient(
                        colors: [
                            .purple.opacity(0.8),
                            .blue.opacity(0.6),
                            .cyan.opacity(0.8),
                            .purple.opacity(0.6),
                            .pink.opacity(0.8),
                            .purple.opacity(0.8)
                        ],
                        center: .center
                    ),
                    lineWidth: 3
                )
                .frame(width: radius * 2, height: radius * 2)
                .blur(radius: 2)
            
            // Inner precise magic circle with runes
            Circle()
                .stroke(
                    AngularGradient(
                        colors: [
                            .white.opacity(0.9),
                            .cyan.opacity(0.7),
                            .purple.opacity(0.8),
                            .white.opacity(0.6),
                            .blue.opacity(0.9),
                            .white.opacity(0.9)
                        ],
                        center: .center
                    ),
                    lineWidth: 2
                )
                .frame(width: radius * 2, height: radius * 2)
            
            // Mystical energy dots around the circle
            ForEach(0..<8, id: \.self) { dotIndex in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                .white,
                                .cyan.opacity(0.8),
                                .clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 4
                        )
                    )
                    .frame(width: 6, height: 6)
                    .offset(y: -radius)
                    .rotationEffect(.degrees(Double(dotIndex) * 45))
            }
        }
        .rotationEffect(.degrees(rotation))
        .opacity(opacity)
        .shadow(color: .purple.opacity(0.5), radius: 8, x: 0, y: 0)
        .shadow(color: .cyan.opacity(0.3), radius: 12, x: 0, y: 0)
    }
}

private struct MagicalParticle: View {
    let index: Int
    let totalParticles: Int
    let baseRadius: CGFloat
    let rotation: Double
    
    private var angleOffset: Double {
        Double(index) * (360.0 / Double(totalParticles))
    }
    
    private var radiusVariation: CGFloat {
        baseRadius + CGFloat.random(in: -20...40)
    }
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        .white,
                        particleColor.opacity(0.8),
                        .clear
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 6
                )
            )
            .frame(width: particleSize, height: particleSize)
            .offset(y: -radiusVariation)
            .rotationEffect(.degrees(rotation + angleOffset))
            .opacity(particleOpacity)
            .shadow(color: particleColor.opacity(0.6), radius: 4, x: 0, y: 0)
    }
    
    private var particleColor: Color {
        let colors: [Color] = [.purple, .cyan, .blue, .pink, .white]
        return colors[index % colors.count]
    }
    
    private var particleSize: CGFloat {
        CGFloat.random(in: 4...8)
    }
    
    private var particleOpacity: Double {
        Double.random(in: 0.6...1.0)
    }
}

// MARK: - Customizable Vortex Fireworks Component

struct CustomizableVortexFireworks: View {
    let intensity: Double
    let particleCount: Int
    let scale: Double
    let multiColor: Bool
    let trailEnabled: Bool
    let glowEnabled: Bool
    let fadeSpeed: Double
    let gravityAffected: Bool
    
    var body: some View {
        VortexView(createCustomVortexSystem()) {
            // Let VortexView handle all particle rendering internally
            // Remove manual particle creation to avoid performance issues
        }
        .scaleEffect(scale)
    }
    
    private func createCustomVortexSystem() -> VortexSystem {
        // Create a new fireworks system and modify its properties
        var system = VortexSystem.fireworks.makeUniqueCopy()
        
        // Apply intensity scaling with reasonable limits
        let clampedIntensity = min(max(intensity, 0.1), 2.0) // Clamp between 0.1 and 2.0
        let clampedParticleCount = min(max(particleCount, 10), 150) // Clamp between 10 and 150
        
        // Configure birth rate based on particle count and intensity
        system.birthRate = Double(clampedParticleCount) * clampedIntensity * 0.5
        
        // Apply speed scaling
        system.speed = clampedIntensity * 150
        system.speedVariation = clampedIntensity * 75
        
        // Apply fade speed with reasonable bounds
        let clampedFadeSpeed = min(max(fadeSpeed, 0.2), 3.0)
        system.lifespan = TimeInterval(2.5 / clampedFadeSpeed)
        system.lifespanVariation = TimeInterval(1.0 / clampedFadeSpeed)
        
        // Apply scale with reasonable bounds
        let clampedScale = min(max(scale, 0.3), 2.0)
        system.size = clampedScale * 15
        system.sizeVariation = clampedScale * 8
        
        // Configure colors using the correct VortexSystem.Color format
        if multiColor {
            // Use a predefined array of VortexSystem.Color values for multi-color fireworks
            system.colors = .random([
                VortexSystem.Color(red: 1.0, green: 0.0, blue: 0.0),  // Red
                VortexSystem.Color(red: 0.0, green: 0.0, blue: 1.0),  // Blue
                VortexSystem.Color(red: 0.0, green: 1.0, blue: 0.0),  // Green
                VortexSystem.Color(red: 1.0, green: 1.0, blue: 0.0),  // Yellow
                VortexSystem.Color(red: 1.0, green: 0.0, blue: 1.0),  // Purple
                VortexSystem.Color(red: 1.0, green: 0.5, blue: 0.0),  // Orange
                VortexSystem.Color(red: 1.0, green: 0.7, blue: 0.8)   // Pink
            ])
        } else {
            // Use single white color for classic fireworks
            system.colors = .single(VortexSystem.Color(red: 1.0, green: 1.0, blue: 1.0))
        }
        
        return system
    }
}
