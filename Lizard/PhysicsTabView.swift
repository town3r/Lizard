//
//  PhysicsTabView.swift
//  Lizard
//
//  Physics simulation tab with iOS 26 liquid glass styling
//

import SwiftUI
import SpriteKit
import AVFoundation
import GameKit
import Combine
import UIKit
import QuartzCore

/// Physics tab containing the main lizard simulation functionality
struct PhysicsTabView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.scenePhase) private var scenePhase
    @State private var scene = LizardScene(size: .zero)
    @AppStorage("totalLizardsSpawned") private var totalSpawned = 0
    @AppStorage("mainButtonTaps") private var mainButtonTaps = 0

    // User-configurable settings
    @AppStorage("maxLizards") private var maxLizards: Int = 300
    @AppStorage("lizardSize") private var lizardSize: Double = 80.0
    @AppStorage("rainIntensity") private var rainIntensity: Int = 15
    @AppStorage("randomSizeLizards") private var randomSizeLizards: Bool = false
    @AppStorage("backgroundType") private var backgroundType: String = "dynamic"
    
    // Weather settings
    @AppStorage("weatherOffMode") private var weatherOffMode: Bool = false
    @AppStorage("weatherAutoMode") private var weatherAutoMode: Bool = true
    @AppStorage("manualWeatherCondition") private var manualWeatherCondition: String = "clear"

    // Audio settings
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
    
    @State private var totalLizardsSpawned = 0
    @State private var totalButtonTaps = 0
    @State private var gameScene = LizardScene()
    
    // Configuration constants
    private struct Config {
        static let centerButtonSize: CGFloat = 240
        static let lizardImageSize: CGFloat = 120
        static let buttonAnimationDuration: Double = 0.3
        static let buttonHideDelay: TimeInterval = 3.0
        static let spewTimerInterval: TimeInterval = 0.07
        static let rainTimerInterval: TimeInterval = 0.05
        static let scoreBatchThreshold = 10
    }
    
    var body: some View {
        NavigationView {
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
                    bottomBar
                    centerButton(size: size)
                }
                .onAppear {
                    setupScene(size: size)
                }
                .onChange(of: scenePhase) { _, newPhase in
                    handleScenePhaseChange(newPhase)
                }
                .onChange(of: colorScheme) { _, _ in
                    scene.updateColorScheme()
                }
                // Weather settings observers
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
            .navigationTitle("Physics")
            .navigationBarTitleDisplayMode(.large)
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
    
    // HUD counters at top left with iOS 26 liquid glass styling
    var topLeftHUD: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Counter display
            VStack(alignment: .leading, spacing: 4) {
                Text("🦎 \(lizardCount)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Text("Total: \(totalSpawned)")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
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
    
    // Center circle button for spawning a lizard with iOS 26 liquid glass effect
    func centerButton(size: CGSize) -> some View {
        Button {
            // Button debouncing for performance
            let currentTime = CACurrentMediaTime()
            guard currentTime - scene.lastButtonTapTime > 0.05 else { return }
            scene.lastButtonTapTime = currentTime
            
            // Increment counters
            mainButtonTaps += 1
            totalButtonTaps += 1
            
            // Sound effect
            if soundEffectsEnabled && lizardSoundEnabled {
                SoundPlayer.shared.playLizardSound(volume: Float(soundVolume))
            }
            
            // Spawn lizard
            scene.spawnLizard()
            totalSpawned += 1
            totalLizardsSpawned += 1
            updateButtonVisibility()
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

                // Stop button
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
}

// MARK: - Private Methods
private extension PhysicsTabView {
    func setupScene(size: CGSize) {
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
    
    func performDeferredInitialization() {
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
    
    func updateSceneConfiguration() {
        scene.updateConfiguration(
            maxLizards: maxLizards,
            lizardSize: Float(lizardSize),
            rainIntensity: rainIntensity,
            randomSizeLizards: randomSizeLizards
        )
    }
    
    func handleScenePhaseChange(_ newPhase: ScenePhase) {
        switch newPhase {
        case .active:
            scene.resumePhysics()
        case .inactive, .background:
            scene.pausePhysics()
        @unknown default:
            break
        }
    }
    
    func startSpewHold() {
        guard spewTimer == nil else { return }
        isRaining = true
        
        spewTimer = Timer.scheduledTimer(withTimeInterval: Config.spewTimerInterval, repeats: true) { _ in
            // Sound effect for spew
            if soundEffectsEnabled && lizardSoundEnabled {
                SoundPlayer.shared.playLizardSound(volume: Float(soundVolume))
            }
            
            scene.spawnLizard()
            totalSpawned += 1
            totalLizardsSpawned += 1
            updateButtonVisibility()
        }
        
        updateButtonVisibility()
    }
    
    func stopSpewHold() {
        spewTimer?.invalidate()
        spewTimer = nil
        isRaining = false
        scheduleButtonHide()
        reportScoresIfReady()
    }
    
    func startRainHold() {
        guard rainTimer == nil else { return }
        isRaining = true
        
        rainTimer = Timer.scheduledTimer(withTimeInterval: Config.rainTimerInterval, repeats: true) { _ in
            scene.rainOnce()
        }
        
        updateButtonVisibility()
    }
    
    func stopRainHold() {
        rainTimer?.invalidate()
        rainTimer = nil
        isRaining = false
        scheduleButtonHide()
        reportScoresIfReady()
    }
    
    func updateButtonVisibility() {
        let hasLizards = lizardCount > 0
        let shouldShowButtons = hasLizards || isRaining
        
        withAnimation(.spring(response: Config.buttonAnimationDuration, dampingFraction: 0.8)) {
            showStopButton = shouldShowButtons
            showTrashButton = hasLizards
        }
        
        if shouldShowButtons {
            buttonHideWorkItem?.cancel()
        }
    }
    
    func scheduleButtonHide() {
        buttonHideWorkItem?.cancel()
        
        let workItem = DispatchWorkItem {
            withAnimation(.easeInOut(duration: Config.buttonAnimationDuration)) {
                showStopButton = false
                showTrashButton = false
            }
        }
        
        buttonHideWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + Config.buttonHideDelay, execute: workItem)
    }
    
    func reportScoresIfReady() {
        guard totalSpawned % Config.scoreBatchThreshold == 0 else { return }
        
        Task.detached(priority: .background) {
            await MainActor.run {
                let scores = [
                    (id: "total_lizards_spawned", value: totalSpawned),
                    (id: "total_button_taps", value: mainButtonTaps)
                ]
                GameCenterManager.shared.report(scores: scores)
                GameCenterManager.shared.reportAchievements(totalSpawned: totalSpawned, buttonTaps: mainButtonTaps)
            }
        }
    }
    
    func topViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return nil }
        
        var topController = window.rootViewController
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        return topController
    }
}

#Preview {
    PhysicsTabView()
}