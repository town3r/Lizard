# 📚 API Reference

This document provides comprehensive API documentation for the Lizard physics simulation app. All public interfaces, classes, and methods are documented with usage examples.

## Table of Contents

1. [Core Classes](#core-classes)
2. [Managers](#managers)
3. [Configuration](#configuration)
4. [Utilities](#utilities)
5. [Protocols & Delegates](#protocols--delegates)
6. [Enums & Constants](#enums--constants)
7. [Extensions](#extensions)
8. [Usage Examples](#usage-examples)

---

## Core Classes

### LizardScene

**Purpose**: Main SpriteKit physics simulation scene

```swift
final class LizardScene: SKScene {
    // Public callbacks
    var onSpawn: (() -> Void)?
    var onLizardCountChange: ((Int) -> Void)?
    
    // Public properties
    private(set) var currentFPS: Double
    
    // Public methods
    func spawnLizard(at position: CGPoint)
    func clearAllLizards()
    func pauseAging()
    func resumeAging()
    func toggleTilt(enabled: Bool)
}
```

#### Properties

##### `onSpawn: (() -> Void)?`
Callback executed when a lizard is spawned. Set by ContentView to update UI counters.

**Example**:
```swift
scene.onSpawn = {
    DispatchQueue.main.async {
        self.totalLizards += 1
    }
}
```

##### `onLizardCountChange: ((Int) -> Void)?`
Callback for real-time lizard count updates.

**Example**:
```swift
scene.onLizardCountChange = { count in
    print("Current lizards on screen: \(count)")
}
```

##### `currentFPS: Double` (read-only)
Current frame rate performance metric.

**Usage**:
```swift
let fps = scene.currentFPS
if fps < 45 {
    // Reduce quality settings
}
```

#### Methods

##### `spawnLizard(at position: CGPoint)`
Creates a new lizard sprite with physics at the specified position.

**Parameters**:
- `position`: Screen coordinates where lizard should appear

**Example**:
```swift
let centerPosition = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
scene.spawnLizard(at: centerPosition)
```

##### `clearAllLizards()`
Immediately removes all lizard sprites from the scene.

**Example**:
```swift
// Clear button action
Button("Clear") {
    scene.clearAllLizards()
}
```

##### `pauseAging()` / `resumeAging()`
Controls automatic lizard cleanup timer.

**Example**:
```swift
// Stop button - pause aging to keep lizards longer
scene.pauseAging()

// Resume normal cleanup
scene.resumeAging()
```

##### `toggleTilt(enabled: Bool)`
Enables or disables device tilt gravity control.

**Parameters**:
- `enabled`: Whether tilt controls should be active

**Example**:
```swift
// Enable tilt when motion permission granted
scene.toggleTilt(enabled: motionAuthorized)
```

### ContentView

**Purpose**: Main SwiftUI interface and user interaction handling

```swift
struct ContentView: View {
    @StateObject private var scene = LizardScene()
    @State private var totalLizards = 0
    @State private var buttonTaps = 0
    
    var body: some View {
        // SwiftUI layout with embedded SpriteKit
    }
}
```

#### Key Components

##### Scene Integration
```swift
// Embed SpriteKit scene in SwiftUI
SpriteView(scene: scene)
    .ignoresSafeArea()
    .onAppear {
        setupSceneCallbacks()
    }
```

##### Statistics Tracking
```swift
@State private var totalLizards = 0
@State private var buttonTaps = 0

private func setupSceneCallbacks() {
    scene.onSpawn = {
        DispatchQueue.main.async {
            totalLizards += 1
            // Report to Game Center
            GameCenterManager.shared.reportScore(
                Int64(totalLizards), 
                category: "total_lizards"
            )
        }
    }
}
```

---

## Managers

### GameCenterManager

**Purpose**: Game Center integration for achievements and leaderboards

```swift
final class GameCenterManager: NSObject {
    static let shared = GameCenterManager()
    
    // Authentication
    func authenticate(presentingViewController: @autoclosure @escaping () -> UIViewController?)
    
    // Access Point
    func configureAccessPoint(isActive: Bool, location: GKAccessPoint.Location)
    func presentLeaderboards()
    func presentLeaderboards(leaderboardID: String)
    
    // Achievements
    func reportAchievement(_ identifier: String, percentComplete: Double)
    func reportScore(_ score: Int64, category: String)
}
```

#### Authentication

##### `authenticate(presentingViewController:)`
Initiates Game Center authentication flow.

**Parameters**:
- `presentingViewController`: Auto-closure providing view controller for auth UI

**Example**:
```swift
// In ContentView.onAppear
GameCenterManager.shared.authenticate(
    presentingViewController: UIApplication.shared.windows.first?.rootViewController
)
```

#### Achievements

##### `reportAchievement(_:percentComplete:)`
Reports progress on a specific achievement.

**Parameters**:
- `identifier`: Achievement ID from App Store Connect
- `percentComplete`: Progress percentage (0.0 to 100.0)

**Example**:
```swift
// First 100 lizards achievement
if totalLizards >= 100 {
    GameCenterManager.shared.reportAchievement(
        "com.town3r.lizard.ach.first100", 
        percentComplete: 100.0
    )
}
```

#### Leaderboards

##### `reportScore(_:category:)`
Submits score to specified leaderboard.

**Parameters**:
- `score`: Integer score value
- `category`: Leaderboard identifier

**Example**:
```swift
GameCenterManager.shared.reportScore(
    Int64(totalLizards), 
    category: "total_lizards"
)
```

#### Achievement Identifiers

```swift
// Predefined achievement IDs
struct Achievements {
    static let first100 = "com.town3r.lizard.ach.first100"
    static let first500 = "com.town3r.lizard.ach.first500"
    static let buttonMasher = "com.town3r.lizard.ach.tap100"
}
```

### SoundPlayer

**Purpose**: Audio management with pooling and rate limiting

```swift
final class SoundPlayer: NSObject {
    static let shared = SoundPlayer()
    
    // Setup
    func preload(name: String, ext: String, voices: Int)
    
    // Playback
    func play()
    func canPlay() -> Bool
    
    // Lifecycle
    func cleanup()
}
```

#### Setup

##### `preload(name:ext:voices:)`
Preloads audio files into memory pool for efficient playback.

**Parameters**:
- `name`: Audio file name (without extension)
- `ext`: File extension (e.g., "wav", "mp3")
- `voices`: Number of concurrent audio players to create

**Example**:
```swift
// In app initialization
SoundPlayer.shared.preload(
    name: "lizard", 
    ext: "wav", 
    voices: 5
)
```

#### Playback

##### `play()`
Plays sound effect if rate limiting allows.

**Example**:
```swift
// In spawn action
SoundPlayer.shared.play()
```

##### `canPlay() -> Bool`
Checks if enough time has passed since last playback.

**Returns**: `true` if sound can be played, `false` if rate limited

**Example**:
```swift
if SoundPlayer.shared.canPlay() {
    // Proceed with audio feedback
    SoundPlayer.shared.play()
}
```

#### Rate Limiting

The SoundPlayer automatically rate limits to prevent audio spam:
- Minimum interval: 30ms between sounds
- Prevents performance issues during rapid spawning
- Uses internal timer to track last play time

### BetaFeedbackManager

**Purpose**: TestFlight screenshot feedback system

```swift
final class BetaFeedbackManager: NSObject {
    static let shared = BetaFeedbackManager()
    
    // Lifecycle
    func startListening()
    func stopListening()
    
    // State
    var isListening: Bool { get }
}
```

#### Usage

##### `startListening()`
Begins monitoring for screenshot events to trigger feedback composer.

**Example**:
```swift
// In ContentView.onAppear
#if DEBUG
BetaFeedbackManager.shared.startListening()
#endif
```

##### `stopListening()`
Stops screenshot monitoring.

**Example**:
```swift
// In ContentView.onDisappear
BetaFeedbackManager.shared.stopListening()
```

---

## Configuration

### AppConfiguration

**Purpose**: Centralized configuration constants

```swift
struct AppConfiguration {
    struct Physics {
        static let gravityDown: CGFloat = -500
        static let maxPhysicsLizards = 300
        static let baseLizardSize: CGFloat = 80
        static let lizardLifetime: TimeInterval = 10
    }
    
    struct Performance {
        static let lowFPSThreshold: Double = 45
        static let maxConsecutiveLowFPS = 10
    }
    
    struct Audio {
        static let rateLimitInterval: CFTimeInterval = 0.03
        static let defaultVoiceCount = 5
    }
    
    struct UI {
        static let buttonSize: CGFloat = 120
        static let animationDuration: TimeInterval = 0.3
    }
}
```

#### Physics Configuration

##### Core Physics Values
- `gravityDown`: Downward gravity acceleration (-500 points/s²)
- `maxPhysicsLizards`: Maximum concurrent lizards (300)
- `baseLizardSize`: Default lizard sprite size (80 points)
- `lizardLifetime`: Auto-cleanup timer (10 seconds)

**Example**:
```swift
// Using physics configuration
let gravity = CGVector(dx: 0, dy: AppConfiguration.Physics.gravityDown)
physicsWorld.gravity = gravity
```

#### Performance Configuration

##### FPS Monitoring
- `lowFPSThreshold`: Performance warning threshold (45 FPS)
- `maxConsecutiveLowFPS`: Consecutive low frames before action (10)

**Example**:
```swift
if currentFPS < AppConfiguration.Performance.lowFPSThreshold {
    consecutiveLowFPSFrames += 1
    if consecutiveLowFPSFrames >= AppConfiguration.Performance.maxConsecutiveLowFPS {
        // Reduce quality
    }
}
```

#### Audio Configuration

##### Rate Limiting
- `rateLimitInterval`: Minimum time between sounds (30ms)
- `defaultVoiceCount`: Default audio player pool size (5)

**Example**:
```swift
let timeSinceLastPlay = CACurrentMediaTime() - lastPlayTime
if timeSinceLastPlay >= AppConfiguration.Audio.rateLimitInterval {
    // Can play sound
}
```

---

## Utilities

### MotionGravity

**Purpose**: Device motion to gravity vector conversion

```swift
struct MotionGravity {
    static func gravityVector(from data: CMAccelerometerData) -> CGVector
    static func normalizeGravity(_ vector: CGVector) -> CGVector
}
```

#### Methods

##### `gravityVector(from:) -> CGVector`
Converts accelerometer data to SpriteKit gravity vector.

**Parameters**:
- `data`: Core Motion accelerometer data

**Returns**: Gravity vector for SpriteKit physics world

**Example**:
```swift
motionManager.startAccelerometerUpdates(to: .main) { data, error in
    guard let data = data else { return }
    let gravity = MotionGravity.gravityVector(from: data)
    physicsWorld.gravity = gravity
}
```

### Notifications

**Purpose**: Custom notification system for app events

```swift
extension Notification.Name {
    static let lizardSpawned = Notification.Name("lizardSpawned")
    static let performanceWarning = Notification.Name("performanceWarning")
    static let achievementUnlocked = Notification.Name("achievementUnlocked")
}
```

#### Usage

##### Posting Notifications
```swift
// Post lizard spawn event
NotificationCenter.default.post(
    name: .lizardSpawned,
    object: nil,
    userInfo: ["count": lizardCount]
)
```

##### Observing Notifications
```swift
NotificationCenter.default.addObserver(
    forName: .lizardSpawned,
    object: nil,
    queue: .main
) { notification in
    if let count = notification.userInfo?["count"] as? Int {
        updateUI(lizardCount: count)
    }
}
```

### UIHelpers

**Purpose**: SwiftUI UI utility functions

```swift
struct UIHelpers {
    static func liquidGlassEffect() -> some View
    static func buttonScale(pressed: Bool) -> CGFloat
    static func hapticFeedback()
}
```

#### Visual Effects

##### `liquidGlassEffect() -> some View`
Creates translucent liquid glass styling for buttons.

**Example**:
```swift
Button("Spawn") {
    // Action
}
.background(UIHelpers.liquidGlassEffect())
```

##### `buttonScale(pressed:) -> CGFloat`
Provides responsive button scaling for press states.

**Parameters**:
- `pressed`: Whether button is currently pressed

**Returns**: Scale factor for button animation

**Example**:
```swift
Button("Rain") {
    // Action
}
.scaleEffect(UIHelpers.buttonScale(pressed: isPressed))
```

##### `hapticFeedback()`
Triggers haptic feedback for user interactions.

**Example**:
```swift
Button("Clear") {
    UIHelpers.hapticFeedback()
    scene.clearAllLizards()
}
```

---

## Protocols & Delegates

### Physics Protocols

#### LizardPhysicsDelegate
```swift
protocol LizardPhysicsDelegate: AnyObject {
    func lizardDidSpawn(_ lizard: SKNode)
    func lizardDidExpire(_ lizard: SKNode)
    func physicsPerformanceWarning(fps: Double)
}
```

**Usage**:
```swift
class GameController: LizardPhysicsDelegate {
    func lizardDidSpawn(_ lizard: SKNode) {
        updateLizardCount()
    }
    
    func physicsPerformanceWarning(fps: Double) {
        reduceFX()
    }
}
```

### Audio Delegates

#### SoundPlayerDelegate
```swift
protocol SoundPlayerDelegate: AnyObject {
    func soundDidFinishPlaying()
    func soundEncounteredError(_ error: Error)
}
```

---

## Enums & Constants

### WeatherCondition

```swift
enum WeatherCondition: String, CaseIterable {
    case clear = "clear"
    case cloudy = "cloudy"
    case rainy = "rainy"
    case stormy = "stormy"
    
    var displayName: String {
        switch self {
        case .clear: return "Clear Sky"
        case .cloudy: return "Cloudy"
        case .rainy: return "Rainy"
        case .stormy: return "Stormy"
        }
    }
}
```

#### Usage
```swift
let currentWeather: WeatherCondition = .clear
DynamicBackgroundView(weather: currentWeather)
```

### GravityDirection

```swift
enum GravityDirection {
    case down, up, left, right
    case custom(CGVector)
    
    var vector: CGVector {
        switch self {
        case .down: return CGVector(dx: 0, dy: -500)
        case .up: return CGVector(dx: 0, dy: 500)
        case .left: return CGVector(dx: -500, dy: 0)
        case .right: return CGVector(dx: 500, dy: 0)
        case .custom(let vector): return vector
        }
    }
}
```

### Performance Constants

```swift
struct PerformanceConstants {
    static let targetFPS: Double = 60
    static let minimumFPS: Double = 30
    static let maxRenderTime: TimeInterval = 0.016 // ~60 FPS
    
    // Device-specific limits
    static let iPhone8MaxLizards = 150
    static let iPhone12MaxLizards = 250
    static let iPhone14MaxLizards = 300
}
```

---

## Extensions

### SKScene Extensions

```swift
extension SKScene {
    /// Safely remove all children of a specific type
    func removeAllChildren<T: SKNode>(ofType type: T.Type) {
        children.compactMap { $0 as? T }.forEach { $0.removeFromParent() }
    }
    
    /// Get current memory usage for debugging
    var memoryUsage: Int {
        return children.count + (physicsWorld.bodies.count * 2)
    }
}
```

### CGPoint Extensions

```swift
extension CGPoint {
    /// Distance between two points
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
    
    /// Random point within bounds
    static func random(in rect: CGRect) -> CGPoint {
        return CGPoint(
            x: CGFloat.random(in: rect.minX...rect.maxX),
            y: CGFloat.random(in: rect.minY...rect.maxY)
        )
    }
}
```

### View Extensions

```swift
extension View {
    /// Apply liquid glass effect to any view
    func liquidGlass() -> some View {
        self.background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(radius: 10)
        )
    }
    
    /// Conditional view modifier
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
```

---

## Usage Examples

### Complete Setup Example

```swift
// 1. Configure app in LizardApp.swift
@main
struct LizardApp: App {
    init() {
        // Configure audio for game-style playback
        AudioSession.configure()
        
        // Preload sounds
        SoundPlayer.shared.preload(name: "lizard", ext: "wav", voices: 5)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// 2. Set up main view in ContentView.swift
struct ContentView: View {
    @StateObject private var scene = LizardScene()
    @State private var totalLizards = 0
    @State private var buttonTaps = 0
    
    var body: some View {
        ZStack {
            // Background
            DynamicBackgroundView()
            
            // Physics simulation
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            // UI overlay
            VStack {
                HUDView(lizards: totalLizards, taps: buttonTaps)
                Spacer()
                ControlsView(
                    onSpawn: spawnLizard,
                    onClear: clearLizards
                )
            }
        }
        .onAppear(perform: setupApp)
    }
    
    private func setupApp() {
        // Game Center authentication
        GameCenterManager.shared.authenticate(
            presentingViewController: UIApplication.shared.windows.first?.rootViewController
        )
        
        // Configure Game Center access point
        GameCenterManager.shared.configureAccessPoint(
            isActive: true,
            location: .topTrailing
        )
        
        // Set up scene callbacks
        scene.onSpawn = {
            DispatchQueue.main.async {
                totalLizards += 1
                checkAchievements()
                submitScore()
            }
        }
        
        // Start beta feedback (debug builds only)
        #if DEBUG
        BetaFeedbackManager.shared.startListening()
        #endif
    }
    
    private func spawnLizard() {
        buttonTaps += 1
        scene.spawnLizard(at: CGPoint(x: view.bounds.midX, y: view.bounds.midY))
        SoundPlayer.shared.play()
        UIHelpers.hapticFeedback()
    }
    
    private func clearLizards() {
        scene.clearAllLizards()
        UIHelpers.hapticFeedback()
    }
    
    private func checkAchievements() {
        if totalLizards == 100 {
            GameCenterManager.shared.reportAchievement(
                "com.town3r.lizard.ach.first100",
                percentComplete: 100.0
            )
        }
    }
    
    private func submitScore() {
        GameCenterManager.shared.reportScore(
            Int64(totalLizards),
            category: "total_lizards"
        )
    }
}
```

### Physics Scene Setup

```swift
// Custom LizardScene implementation
class CustomLizardScene: LizardScene {
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Configure physics world
        physicsWorld.gravity = CGVector(dx: 0, dy: AppConfiguration.Physics.gravityDown)
        physicsWorld.contactDelegate = self
        
        // Set up motion updates
        toggleTilt(enabled: true)
        
        // Configure performance monitoring
        onLizardCountChange = { count in
            if count > AppConfiguration.Physics.maxPhysicsLizards {
                // Remove oldest lizards
                self.cleanupOldestLizards()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // Custom performance monitoring
        if currentFPS < AppConfiguration.Performance.lowFPSThreshold {
            // Reduce visual effects
            reduceQuality()
        }
    }
}
```

### Audio Integration

```swift
// Custom sound management
class GameAudioManager {
    private let soundPlayer = SoundPlayer.shared
    
    func setupAudio() {
        // Preload all game sounds
        soundPlayer.preload(name: "lizard", ext: "wav", voices: 5)
        soundPlayer.preload(name: "clear", ext: "wav", voices: 2)
        soundPlayer.preload(name: "achievement", ext: "wav", voices: 1)
    }
    
    func playSpawnSound() {
        soundPlayer.play()
    }
    
    func playAchievementSound() {
        // Switch to achievement sound temporarily
        soundPlayer.preload(name: "achievement", ext: "wav", voices: 1)
        soundPlayer.play()
        
        // Switch back to default sound
        soundPlayer.preload(name: "lizard", ext: "wav", voices: 5)
    }
}
```

---

## Error Handling

### Common Error Patterns

```swift
// Audio errors
do {
    let player = try AVAudioPlayer(contentsOf: soundURL)
    player.play()
} catch {
    print("⚠️ Audio error: \(error.localizedDescription)")
    // Fallback: continue without sound
}

// Game Center errors
GameCenterManager.shared.reportScore(score, category: category) { error in
    if let error = error {
        print("⚠️ Score submission failed: \(error.localizedDescription)")
        // Fallback: cache score for later retry
    }
}

// Physics errors
guard scene.children.count < AppConfiguration.Physics.maxPhysicsLizards else {
    print("⚠️ Maximum lizard count reached")
    return // Skip spawning
}
```

### Performance Error Handling

```swift
// FPS monitoring with graceful degradation
func handleLowPerformance() {
    // Reduce concurrent lizards
    let targetCount = AppConfiguration.Physics.maxPhysicsLizards / 2
    while scene.children.count > targetCount {
        scene.children.first?.removeFromParent()
    }
    
    // Disable expensive effects
    scene.physicsWorld.speed = 0.8 // Slow down physics
    
    // Notify user if needed
    NotificationCenter.default.post(name: .performanceWarning, object: nil)
}
```

---

*This API reference is automatically generated from source code documentation. For the most up-to-date information, refer to the source files directly. Last updated: Version 1.1.0 🦎*