# 👨‍💻 Developer Guide

Welcome to Lizard development! This guide will help you understand the codebase, set up your development environment, and contribute effectively to the project.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Development Environment](#development-environment)
3. [Project Architecture](#project-architecture)
4. [Core Components](#core-components)
5. [Development Workflow](#development-workflow)
6. [Testing Strategy](#testing-strategy)
7. [Performance Guidelines](#performance-guidelines)
8. [Platform Considerations](#platform-considerations)
9. [Contributing Guidelines](#contributing-guidelines)
10. [Debugging & Profiling](#debugging--profiling)

---

## Getting Started

### Prerequisites

#### Required Tools
- **macOS 14.0+** (required for iOS development)
- **Xcode 15.0+** (latest stable recommended)
- **iOS 18.0+ SDK** (included with Xcode)
- **Apple Developer Account** (for device testing and distribution)

#### Recommended Tools
- **SF Symbols App** - For system icon browsing
- **Console.app** - For system logging and crash analysis
- **Instruments** - For performance profiling
- **Git** - Version control (included with Xcode Command Line Tools)

### Quick Setup

#### 1. Clone and Build
```bash
# Clone the repository
git clone https://github.com/town3r/Lizard.git
cd Lizard

# Open in Xcode
open Lizard.xcodeproj

# Build all targets (⌘+B)
# Run tests (⌘+U)
# Run on simulator (⌘+R)
```

#### 2. Project Structure Orientation
```
Lizard/
├── Lizard/                     # iOS App Source
│   ├── LizardApp.swift         # App entry point
│   ├── ContentView.swift       # Main UI
│   ├── LizardScene.swift       # Physics engine
│   ├── GameCenterManager.swift # Social features
│   ├── SoundPlayer.swift       # Audio system
│   └── ...                     # Support files
├── LizardTests/                # iOS Unit Tests
├── docs/                       # Documentation
└── Lizard.xcodeproj           # Xcode Project
```

#### 3. Verify Setup
- Build succeeds without errors
- Unit tests pass (should take ~30 seconds)
- iOS Simulator launches app successfully

---

## Development Environment

### Xcode Configuration

#### Project Settings
- **Deployment Target**: iOS 18.0+
- **Swift Version**: Latest stable (5.9+)
- **Bundle Identifier**: `com.town3r.lizard`
- **Code Signing**: Automatic (development), Manual (distribution)

#### Build Targets
- **Lizard** (iOS): Main application
- **LizardTests** (iOS): Unit test bundle

#### Schemes
- **Lizard**: Builds and runs iOS app
- **All Tests**: Runs iOS tests

### Development Workflow Setup

#### Git Configuration
```bash
# Configure git for the project
git config --local user.name "Your Name"
git config --local user.email "your.email@example.com"

# Set up useful aliases
git config --local alias.st status
git config --local alias.co checkout
git config --local alias.br branch
```

#### Xcode Preferences
1. **Accounts**: Add your Apple Developer account
2. **Behaviors**: Configure build success/failure actions
3. **Source Control**: Enable Git integration
4. **Components**: Install additional simulators as needed

---

## Project Architecture

### Overall Design Pattern

Lizard uses a **hybrid SwiftUI + SpriteKit architecture** that combines the best of both frameworks:

- **SwiftUI**: UI layout, navigation, and controls
- **SpriteKit**: Physics simulation, particle effects, and high-performance rendering
- **Singleton Managers**: Shared services for audio, Game Center, and feedback

### Architecture Diagram

```
┌─────────────────┐
│   ContentView   │
│   (SwiftUI)     │
└─────────┬───────┘
          │
          ▼
┌─────────────────┐    ┌─────────────────┐
│  LizardScene    │    │ GameCenterMgr   │
│  (SpriteKit)    │◄──►│  (Singleton)    │
└─────────┬───────┘    └─────────────────┘
          │
          ▼
┌─────────────────┐    ┌─────────────────┐
│  Physics Nodes  │    │  SoundPlayer    │
│  (SKNode)       │    │  (Singleton)    │
└─────────────────┘    └─────────────────┘
```

### Key Architectural Decisions

#### SwiftUI + SpriteKit Integration
- **SpriteView**: Embeds SpriteKit scene in SwiftUI
- **Notification Communication**: Scene notifies UI of events
- **State Management**: SwiftUI handles app state, SpriteKit handles physics state

#### Code Organization
- **Shared Managers**: Game Center, configuration, and utilities
- **Modular Design**: Clear separation of concerns between components

#### Performance-First Design
- **Object Pooling**: Reuse physics nodes instead of creating new ones
- **Automatic Cleanup**: Time-based removal prevents memory accumulation
- **FPS Monitoring**: Real-time performance tracking with automatic adjustment

---

## Core Components

### LizardApp.swift
**Purpose**: App entry point and lifecycle management

```swift
@main
struct LizardApp: App {
    init() {
        // Configure audio session for game-style audio
        SoundPlayer.shared.configureAudioSession()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

**Key Responsibilities**:
- Audio session configuration
- App-wide initialization
- Scene management

### ContentView.swift
**Purpose**: Main UI and user interaction handling

**Key Features**:
- SwiftUI-based layout with embedded SpriteKit view
- Button controls for spawning and clearing
- Statistics display and Game Center integration
- Dynamic background rendering

**Architecture Pattern**:
```swift
struct ContentView: View {
    @StateObject private var scene = LizardScene()
    @State private var totalLizards = 0
    
    var body: some View {
        ZStack {
            DynamicBackgroundView()           // Time-based background
            SpriteView(scene: scene)          // Physics simulation
            VStack {
                HUDView(stats: stats)         // UI overlay
                Spacer()
                ControlsView(actions: ...)    // User controls
            }
        }
    }
}
```

### LizardScene.swift
**Purpose**: Physics simulation and rendering engine

**Core Responsibilities**:
- SpriteKit scene management
- Physics world configuration
- Lizard spawning and lifecycle
- Device motion integration
- Performance monitoring

**Key Classes**:
```swift
class LizardScene: SKScene, ObservableObject {
    private struct Config {
        static let maxPhysicsLizards = 300
        static let lizardLifetime: TimeInterval = 10
        static let lowFPSThreshold: Double = 45
    }
    
    func spawnLizard(at position: CGPoint) { ... }
    func updateGravity(from motion: CMAccelerometerData) { ... }
    func monitorPerformance() { ... }
}
```

### GameCenterManager.swift
**Purpose**: Social gaming features and leaderboards

**Singleton Pattern**:
```swift
class GameCenterManager: ObservableObject {
    static let shared = GameCenterManager()
    
    private init() { }  // Prevent external instantiation
    
    func authenticate() { ... }
    func reportAchievement(_ identifier: String) { ... }
    func submitScore(_ score: Int64, category: String) { ... }
}
```

**Achievement System**:
- First Century: 100 lizards spawned
- Lizard Master: 500 lizards spawned
- Button Masher: 100 button taps

### SoundPlayer.swift
**Purpose**: Audio management and playback

**Features**:
- Multi-voice audio pool for concurrent sounds
- Rate limiting to prevent audio spam
- Silent mode compatibility
- Resource management and cleanup

**Implementation Pattern**:
```swift
class SoundPlayer: ObservableObject {
    static let shared = SoundPlayer()
    
    private var audioPlayers: [AVAudioPlayer] = []
    private var lastPlayTime: TimeInterval = 0
    private let rateLimit: TimeInterval = 0.03 // 30ms
    
    func playSpawnSound() {
        guard canPlay() else { return }
        // Play using available audio player from pool
    }
}
```

---

## Development Workflow

### Feature Development Process

#### 1. Planning Phase
```bash
# Create feature branch
git checkout -b feature/new-feature-name

# Plan implementation
# - Identify affected components
# - Design API changes
# - Consider performance impact
# - Plan testing strategy
```

#### 2. Implementation Phase
```swift
// Follow established patterns
// Use existing configuration systems
// Maintain performance standards
// Add appropriate logging/debugging
```

#### 3. Testing Phase
```bash
# Run unit tests frequently
xcodebuild test -project Lizard.xcodeproj -scheme Lizard

# Test on multiple devices/simulators
# - iPhone (various sizes)
# - iPad (if supported)
# - Apple Watch (Series 7+)

# Performance testing
# - Instruments profiling
# - Extended gameplay sessions
# - Memory leak detection
```

#### 4. Integration Phase
```bash
# Clean build verification
xcodebuild clean
xcodebuild -project Lizard.xcodeproj -scheme Lizard

# Final testing
# - All unit tests pass
# - No build warnings
# - Performance meets standards
```

### Code Style Guidelines

#### Swift Style
```swift
// Use descriptive names
func spawnLizardWithRandomVelocity(at position: CGPoint) { ... }

// Prefer explicit types for configuration
private struct Config {
    static let maxLizards: Int = 300
    static let spawnDelay: TimeInterval = 0.1
}

// Use guards for early returns
guard isPerformanceAcceptable() else {
    return // Skip expensive operations
}

// Document complex physics calculations
/// Converts device tilt to gravity vector using trigonometry
private func gravityVector(from motion: CMAccelerometerData) -> CGVector {
    // Implementation with comments explaining math
}
```

#### SwiftUI Style
```swift
// Break complex views into smaller components
struct ControlsView: View {
    var body: some View {
        HStack {
            SpawnButton(action: spawnAction)
            Spacer()
            ClearButton(action: clearAction)
        }
    }
}

// Use @StateObject for owned objects, @ObservedObject for injected
struct ContentView: View {
    @StateObject private var scene = LizardScene()  // Owned
    @ObservedObject var gameCenter: GameCenterManager  // Injected
}
```

### Performance Guidelines

#### General Performance Rules
1. **60 FPS Target**: Maintain smooth animation on target devices
2. **Memory Efficiency**: Clean up objects promptly, avoid memory leaks
3. **Battery Conscious**: Minimize CPU/GPU usage during idle periods
4. **Responsive UI**: Never block the main thread

#### Physics Performance
```swift
// Good: Efficient object pooling
private var lizardPool: [SKSpriteNode] = []

func spawnLizard() {
    let lizard = lizardPool.popLast() ?? createNewLizard()
    configureLizard(lizard)
    addChild(lizard)
}

// Bad: Creating new objects every time
func spawnLizard() {
    let lizard = SKSpriteNode(imageNamed: "lizard")  // Expensive!
    addChild(lizard)
}
```

#### Audio Performance
```swift
// Good: Rate limiting and pooling
func playSound() {
    guard canPlaySound() else { return }
    // Use pre-loaded audio player from pool
}

// Bad: No rate limiting, creates new players
func playSound() {
    let player = AVAudioPlayer(contentsOf: soundURL)  // Expensive!
    player.play()
}
```

---

## Testing Strategy

### Unit Test Coverage

#### Current Test Areas
- **SoundPlayer**: Audio system functionality and rate limiting
- **GameCenterManager**: Singleton pattern and achievement identifiers
- **LizardScene**: Public API safety and initialization
- **Notifications**: Custom notification system validation
- **Gravity**: Mathematical validation of coordinate transformations

#### Testing Philosophy
```swift
// Test public APIs, not implementation details
func testSpawnLizardCreatesPhysicsBody() {
    scene.spawnLizard(at: CGPoint(x: 100, y: 100))
    
    // Test observable behavior, not internal state
    XCTAssertTrue(scene.children.count > 0)
    XCTAssertNotNil(scene.children.first?.physicsBody)
}

// Use dependency injection for testability
class TestableGameCenterManager: GameCenterManager {
    var mockAuthenticated = false
    override var isAuthenticated: Bool { return mockAuthenticated }
}
```

#### Adding New Tests
```swift
// Follow existing test patterns
class NewFeatureTests: XCTestCase {
    var testSubject: FeatureToTest!
    
    override func setUp() {
        super.setUp()
        testSubject = FeatureToTest()
    }
    
    override func tearDown() {
        testSubject = nil
        super.tearDown()
    }
    
    func testExpectedBehavior() {
        // Arrange
        let input = createTestInput()
        
        // Act
        let result = testSubject.performAction(input)
        
        // Assert
        XCTAssertEqual(result, expectedOutput)
    }
}
```

### Performance Testing

#### Using Instruments
1. **Time Profiler**: Identify CPU bottlenecks
2. **Allocations**: Track memory usage and leaks
3. **Core Animation**: Monitor rendering performance
4. **System Trace**: Overall system impact

#### Manual Performance Testing
```swift
// Add performance monitoring to new features
func performExpensiveOperation() {
    let startTime = CACurrentMediaTime()
    
    // Actual operation
    doWork()
    
    let duration = CACurrentMediaTime() - startTime
    if duration > 0.016 { // More than one frame at 60 FPS
        print("Warning: Operation took \(duration)s")
    }
}
```

---

## Platform Considerations

### iOS-Specific Development

#### SpriteKit Integration
```swift
// iOS uses full SpriteKit physics simulation
class LizardScene: SKScene {
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
    }
}
```

#### Motion Integration
```swift
// iOS has full CoreMotion support
import CoreMotion

private let motionManager = CMMotionManager()

func startMotionUpdates() {
    guard motionManager.isAccelerometerAvailable else { return }
    
    motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
        guard let data = data else { return }
        self?.updateGravity(from: data)
    }
}
```

---

## Debugging & Profiling

### Debugging Techniques

#### Debug Builds
```swift
#if DEBUG
// Add debug overlays and logging
private var debugInfo: Bool = true

func drawDebugInfo() {
    if debugInfo {
        // Show FPS, lizard count, memory usage
    }
}
#endif
```

#### Console Logging
```swift
import os.log

private let logger = Logger(subsystem: "com.town3r.lizard", 
                           category: "Physics")

func spawnLizard() {
    logger.debug("Spawning lizard at \(position)")
    // Implementation
    logger.info("Lizard spawned, total count: \(lizardCount)")
}
```

#### Performance Monitoring
```swift
class PerformanceMonitor {
    private var frameCount = 0
    private var lastTime = CACurrentMediaTime()
    
    func recordFrame() {
        frameCount += 1
        let currentTime = CACurrentMediaTime()
        
        if currentTime - lastTime >= 1.0 {
            let fps = Double(frameCount) / (currentTime - lastTime)
            if fps < 45 {
                logger.warning("Low FPS: \(fps)")
            }
            
            frameCount = 0
            lastTime = currentTime
        }
    }
}
```

### Common Debugging Scenarios

#### Physics Issues
```swift
// Visualize physics bodies in debug builds
#if DEBUG
override func didMove(to view: SKView) {
    view.showsPhysics = true
    view.showsFPS = true
    view.showsNodeCount = true
}
#endif
```

#### Memory Issues
```swift
// Track object lifecycle
deinit {
    logger.debug("LizardScene deallocated")
}

// Monitor memory pressure
override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    cleanupExpiredLizards()
    logger.warning("Memory warning received, cleaned up objects")
}
```

#### Audio Issues
```swift
// Debug audio problems
func debugAudioState() {
    logger.debug("Audio session category: \(AVAudioSession.sharedInstance().category)")
    logger.debug("Audio players in pool: \(audioPlayers.count)")
    logger.debug("Last play time: \(lastPlayTime)")
}
```

---

## Contributing Guidelines

### Before You Start

1. **Read the Documentation**: Familiarize yourself with the codebase
2. **Set Up Environment**: Ensure all tools are installed and working
3. **Run Tests**: Verify everything works in your environment
4. **Check Issues**: Look for existing issues or feature requests

### Development Process

#### 1. Issue Selection
- Start with issues labeled "good first issue" for newcomers
- Check if issue is already assigned or being worked on
- Comment on issue to indicate you're working on it

#### 2. Branch Creation
```bash
# Use descriptive branch names
git checkout -b feature/add-new-physics-effect
git checkout -b bugfix/fix-audio-memory-leak
git checkout -b docs/update-installation-guide
```

#### 3. Implementation
- Follow existing code patterns and style
- Add tests for new functionality
- Update documentation if needed
- Ensure performance standards are met

#### 4. Testing
```bash
# Run full test suite
xcodebuild test -project Lizard.xcodeproj -scheme Lizard

# Test on multiple simulators
# - iPhone SE (small screen)
# - iPhone 15 Pro (latest)
# - Apple Watch Series 9
```

#### 5. Pull Request
- Provide clear description of changes
- Reference related issues
- Include testing instructions
- Add screenshots for UI changes

### Code Review Process

#### What Reviewers Look For
- **Correctness**: Does the code work as intended?
- **Performance**: Does it meet performance standards?
- **Style**: Does it follow project conventions?
- **Testing**: Are there adequate tests?
- **Documentation**: Is it properly documented?

#### Responding to Feedback
- Address all feedback promptly
- Ask questions if feedback is unclear
- Make requested changes in new commits
- Don't take feedback personally - it's about code quality

---

## Resources & References

### Apple Documentation
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [SpriteKit Documentation](https://developer.apple.com/documentation/spritekit)
- [Game Center Programming Guide](https://developer.apple.com/documentation/gamekit)
- [Core Motion Framework](https://developer.apple.com/documentation/coremotion)

### Project Documentation
- **[BUILDING.md](BUILDING.md)**: Detailed build instructions
- **[TECHNICAL.md](TECHNICAL.md)**: Architecture and implementation details
- **[API_REFERENCE.md](API_REFERENCE.md)**: Code documentation
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)**: Common issues and solutions

### External Resources
- [Swift Style Guide](https://swift.org/documentation/api-design-guidelines/)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [SpriteKit Best Practices](https://developer.apple.com/videos/play/wwdc2014/608/)
- [Performance Optimization](https://developer.apple.com/videos/play/wwdc2018/102/)

### Community
- **GitHub Discussions**: Technical questions and feature discussions
- **Issues**: Bug reports and feature requests
- **Pull Requests**: Code contributions and reviews
- **Releases**: Version history and update notes

---

*This developer guide is maintained alongside the codebase. When you add new features or change architecture, please update the relevant sections. Last updated: Version 1.1.0 🦎*