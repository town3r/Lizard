import SwiftUI
import SpriteKit
import AVFoundation
import GameKit
import Combine
import UIKit // For app lifecycle notifications
import QuartzCore // For CACurrentMediaTime

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
    
    // Weather settings - observe changes to trigger weather effects
    @AppStorage("weatherOffMode") private var weatherOffMode: Bool = false
    @AppStorage("weatherAutoMode") private var weatherAutoMode: Bool = true
    @AppStorage("manualWeatherCondition") private var manualWeatherCondition: String = "clear"

    // Audio settings - observe changes to update sound behavior
    @AppStorage("soundEffectsEnabled") private var soundEffectsEnabled: Bool = true
    @AppStorage("lizardSoundEnabled") private var lizardSoundEnabled: Bool = true
    @AppStorage("thunderSoundEnabled") private var thunderSoundEnabled: Bool = true
    @AppStorage("soundVolume") private var soundVolume: Double = 1.0

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
    
    // Beta feedback integration
    @State private var showBetaFeedback = false
    
    // Button debouncing for performance
    @State private var lastButtonPressTime: CFTimeInterval = 0
    private let buttonDebounceInterval: CFTimeInterval = 0.05 // 50ms debounce

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
            // Weather settings observers - trigger weather effects when settings change
            .onChange(of: weatherOffMode) { _, _ in
                Task { @MainActor in
                    scene.refreshWeatherEffects()
                }
            }
            .onChange(of: weatherAutoMode) { _, _ in
                Task { @MainActor in
                    scene.refreshWeatherEffects()
                }
            }
            .onChange(of: manualWeatherCondition) { _, _ in
                Task { @MainActor in
                    scene.refreshWeatherEffects()
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
        VStack(alignment: .trailing, spacing: 9) {
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
            SettingsView()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
    
    // Center circle button for spawning a lizard with iOS 26 liquid glass effect
    func centerButton(size: CGSize) -> some View {
        Button {
            // Button debouncing for performance
            let currentTime = CACurrentMediaTime()
            guard currentTime - lastButtonPressTime >= buttonDebounceInterval else { return }
            lastButtonPressTime = currentTime
            
            // Immediate UI feedback - keep these on main thread for responsiveness
            mainButtonTaps += 1
            scene.setAgingPaused(false)
            
            // Move expensive operations to background to prevent UI blocking
            Task.detached(priority: .userInitiated) {
                // Check FPS before spawning to prevent performance degradation
                await MainActor.run {
                    if scene.currentFPS >= 30 { // Lower threshold than normal to be more permissive
                        scene.emitFromCircleCenterRandomAsync(sizeJitter: Config.sizeJitterSingle)
                    }
                }
                
                // Sound playback - needs to be on main actor
                await MainActor.run {
                    SoundPlayer.shared.play(name: "lizard", ext: "wav")
                }
            }
            
            // GameCenter reporting - can be async as it's not time-critical
            Task.detached(priority: .utility) {
                await MainActor.run {
                    self.reportScoresIfReady()
                }
            }
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
            showStopButton = isRaining
            showTrashButton = lizardCount > 0
        }
    }
    
    func scheduleButtonHide() {
        // Cancel any previously scheduled hide
        buttonHideWorkItem?.cancel()
        
        // Create a new work item
        let workItem = DispatchWorkItem {
            withAnimation(.easeInOut(duration: Config.buttonAnimationDuration)) {
                if !self.isRaining {
                    self.showStopButton = false
                }
                if self.lizardCount == 0 {
                    self.showTrashButton = false
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
                // Use async version for better performance during continuous spawning
                if scene.currentFPS >= 30 {
                    scene.emitFromCircleCenterRandomAsync(sizeJitter: Config.sizeJitterHold)
                }
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
    
    // MARK: - Deferred Initialization
    
    /// Performs heavy initialization tasks in the background to avoid blocking UI startup
    @MainActor
    private func performDeferredInitialization() {
        // Update scene configuration with user settings first (lightweight)
        updateSceneConfiguration()
        
        // Initialize weather effects based on current settings (lightweight)
        scene.refreshWeatherEffects()
        
        // Start tilt motion after UI is ready (lightweight)
        scene.startTilt()
        
        // Defer GameCenter authentication to lowest priority to avoid blocking
        Task.detached(priority: .background) {
            // Additional delay to ensure UI is fully responsive first
            try? await Task.sleep(nanoseconds: 500_000_000) // 500ms
            
            await MainActor.run {
                GameCenterManager.shared.authenticate(presentingViewController: { topViewController() })
                GameCenterManager.shared.configureAccessPoint(isActive: false, location: .topTrailing)
            }
        }
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
