# 📋 Documentation Index

Welcome to the comprehensive documentation for the Lizard iOS physics simulation app! This index helps you find the information you need.

## 📖 Main Documentation

### Getting Started
- **[README.md](../README.md)** - Project overview, features, and quick start guide
- **[BUILDING.md](../BUILDING.md)** - Complete development setup and build instructions
- **[CONTROLS.md](../CONTROLS.md)** - User control guide and interaction reference

### Features & Functionality  
- **[FEATURES.md](../FEATURES.md)** - Detailed feature documentation and capabilities
- **[CHANGELOG.md](../CHANGELOG.md)** - Release notes and version history
- **[TECHNICAL.md](../TECHNICAL.md)** - Technical architecture and implementation details

## 🎯 Specialized Guides

### Integration & Setup
- **[Game Center Guide](GAME_CENTER.md)** - Complete Game Center setup and troubleshooting
- **[Design System](DESIGN_SYSTEM.md)** - Visual design, UI components, and style guide

### Development Resources
- **[API Reference](#api-reference)** - Code documentation and examples
- **[Testing Guide](#testing-guide)** - Unit testing and quality assurance
- **[Performance Guide](#performance-guide)** - Optimization tips and monitoring

## 🎮 User Documentation

### For Players

#### Getting Started
1. **[Installation](#installation)** - Download and setup
2. **[Controls Guide](../CONTROLS.md)** - Master the physics controls
3. **[Game Center Setup](GAME_CENTER.md)** - Enable leaderboards and achievements

#### Gameplay
- **[Basic Controls](../CONTROLS.md#basic-controls)** - Essential interactions
- **[Motion Controls](../CONTROLS.md#motion-controls)** - Tilt-to-control gravity
- **[Advanced Techniques](../CONTROLS.md#advanced-techniques)** - Expert gameplay tips

#### Features
- **[Physics Simulation](../FEATURES.md#physics-simulation-engine)** - Understanding the engine
- **[Visual Effects](../FEATURES.md#visual-features)** - Day/night cycle and backgrounds
- **[Audio System](../FEATURES.md#audio-system)** - Sound effects and feedback

### For Beta Testers

#### TestFlight Features
- **[Beta Feedback](../FEATURES.md#beta--testing-features)** - Screenshot-to-feedback system
- **[Performance Monitoring](../TECHNICAL.md#performance-engineering)** - FPS tracking and optimization
- **[Reporting Issues](#reporting-issues)** - How to submit feedback

## 👨‍💻 Developer Documentation

### Architecture & Design

#### Core Systems
- **[App Architecture](../TECHNICAL.md#architecture-overview)** - SwiftUI + SpriteKit hybrid design
- **[Physics Engine](../TECHNICAL.md#physics-engine-core)** - SpriteKit implementation details
- **[Audio System](../TECHNICAL.md#audio-architecture)** - Multi-voice sound pooling

#### Platform Integration
- **[Game Center](../TECHNICAL.md#game-center-integration)** - Leaderboards and achievements
- **[Motion Controls](../TECHNICAL.md#motion-control-system)** - CoreMotion integration
- **[Performance](../TECHNICAL.md#performance-engineering)** - Optimization strategies

### Development Workflow

#### Setup & Building
- **[Environment Setup](../BUILDING.md#development-environment-setup)** - Xcode and tools
- **[Project Structure](../BUILDING.md#project-structure)** - File organization
- **[Build Process](../BUILDING.md#building-the-project)** - Debug and release builds

#### Testing & Quality
- **[Unit Testing](../BUILDING.md#testing)** - Test suite and coverage
- **[Device Testing](../BUILDING.md#device-testing)** - Physical device requirements
- **[Performance Testing](../BUILDING.md#performance-development)** - Profiling and optimization

#### Deployment
- **[TestFlight](../BUILDING.md#testflight-beta-distribution)** - Beta distribution process
- **[App Store](../BUILDING.md#app-store-release)** - Release preparation and submission

### Code Documentation

#### Core Components
```swift
// Main application files
LizardApp.swift         // App entry point and lifecycle
ContentView.swift       // Primary UI and controls
LizardScene.swift       // Physics simulation engine

// Support systems
GameCenterManager.swift // Game Center integration
SoundPlayer.swift       // Audio management
DynamicBackgroundView.swift // Time-based backgrounds
BetaFeedbackManager.swift // TestFlight feedback
```

#### Key Classes
- **`LizardScene`** - SpriteKit physics simulation
- **`GameCenterManager`** - Social gaming features
- **`SoundPlayer`** - Multi-voice audio system
- **`BetaFeedbackManager`** - Screenshot feedback system

## 🎨 Design Resources

### Visual Design
- **[Design System](DESIGN_SYSTEM.md)** - Complete visual style guide
- **[Color Palette](DESIGN_SYSTEM.md#color-palette)** - Dynamic sky and UI colors
- **[Typography](DESIGN_SYSTEM.md#typography)** - Font usage and hierarchy
- **[Iconography](DESIGN_SYSTEM.md#iconography)** - Icon system and usage

### UI Components
- **[Liquid Glass Buttons](DESIGN_SYSTEM.md#liquid-glass-buttons)** - Primary UI components
- **[HUD Elements](DESIGN_SYSTEM.md#hud-components)** - Statistics and overlays
- **[Background System](DESIGN_SYSTEM.md#background-system)** - Dynamic time-based visuals

### Accessibility
- **[Visual Accessibility](DESIGN_SYSTEM.md#visual-accessibility)** - High contrast and color blindness
- **[Motor Accessibility](DESIGN_SYSTEM.md#motor-accessibility)** - Touch targets and gestures
- **[Cognitive Accessibility](DESIGN_SYSTEM.md#cognitive-accessibility)** - Clear affordances

## 🔧 Technical References

### API Documentation

#### Core Classes
```swift
class LizardScene: SKScene {
    func spawnLizard(at: CGPoint, impulse: CGVector, scale: CGFloat, playSound: Bool)
    func rainOnce()
    func clearAll()
    func setAgingPaused(Bool)
    func startTilt()
    func stopTilt()
}

class GameCenterManager {
    func authenticate(presentingViewController:)
    func report(scores: [(id: String, value: Int)], context: Int)
    func reportAchievements(totalSpawned: Int, buttonTaps: Int)
    func presentLeaderboards()
}

class SoundPlayer {
    func preload(name: String, ext: String, voices: Int)
    func play(name: String, ext: String)
    func cleanup()
}
```

#### Configuration Constants
```swift
// Physics tuning
static let maxPhysicsLizards = 300
static let lizardLifetime: TimeInterval = 10
static let gravityDown: CGFloat = -9.8

// Performance monitoring
static let lowFPSThreshold: Double = 45
static let maxConsecutiveLowFPS = 10

// UI timing
static let spewTimerInterval: TimeInterval = 0.07
static let rainTimerInterval: TimeInterval = 0.08
```

### Game Center Configuration

#### Identifiers
```
Leaderboards:
- com.town3r.lizard.totalspawned (Total Lizards Spawned)
- com.town3r.lizard.buttontaps (Button Taps)

Achievements:
- com.town3r.lizard.ach.first100 (First Century - 100 lizards)
- com.town3r.lizard.ach.first500 (Lizard Master - 500 lizards)
- com.town3r.lizard.ach.tap100 (Button Masher - 100 taps)
```

## 🐛 Troubleshooting

### Common Issues
- **[Build Issues](../BUILDING.md#troubleshooting)** - Code signing, Simulator problems
- **[Performance Issues](../BUILDING.md#performance-issues)** - Memory leaks, frame rate drops
- **[Game Center Issues](GAME_CENTER.md#troubleshooting)** - Authentication and sync problems

### Debug Resources
- **[Debugging Guide](../BUILDING.md#debugging)** - Common debug scenarios
- **[Performance Profiling](../TECHNICAL.md#performance-monitoring)** - Instruments and optimization
- **[Console Logging](../TECHNICAL.md#performance-engineering)** - Debug output and monitoring

## 📞 Support & Community

### Getting Help
- **GitHub Issues** - Bug reports and feature requests
- **TestFlight Feedback** - In-app screenshot feedback system
- **Developer Documentation** - Apple's official iOS guides

### Contributing
- **[Development Setup](../BUILDING.md)** - Get started with development
- **[Code Style](#code-style)** - Contribution guidelines
- **[Testing Requirements](../BUILDING.md#testing)** - Quality standards

## 📚 External Resources

### Apple Documentation
- [SwiftUI Framework](https://developer.apple.com/documentation/swiftui)
- [SpriteKit Framework](https://developer.apple.com/documentation/spritekit)
- [Game Center Programming Guide](https://developer.apple.com/documentation/gamekit)
- [Core Motion Framework](https://developer.apple.com/documentation/coremotion)

### Learning Resources
- [Swift Programming Language](https://docs.swift.org/swift-book/)
- [iOS App Development Tutorials](https://developer.apple.com/tutorials/)
- [SpriteKit Best Practices](https://developer.apple.com/videos/play/wwdc2014/608/)

---

## 🚀 Quick Navigation

| Topic | Documentation |
|-------|--------------|
| **Getting Started** | [README](../README.md) → [Building](../BUILDING.md) → [Controls](../CONTROLS.md) |
| **Features** | [Features Guide](../FEATURES.md) → [Technical Details](../TECHNICAL.md) |
| **Game Center** | [Game Center Guide](GAME_CENTER.md) |
| **Design** | [Design System](DESIGN_SYSTEM.md) |
| **Development** | [Building Guide](../BUILDING.md) → [Technical Architecture](../TECHNICAL.md) |
| **Release Notes** | [Changelog](../CHANGELOG.md) |

---

*Find what you're looking for? If not, check the [GitHub repository](https://github.com/town3r/Lizard) for additional resources! 🦎📚*