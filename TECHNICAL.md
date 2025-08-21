# 🏗️ Lizard Technical Architecture

Deep dive into the technical implementation, architecture, and engineering decisions behind the Lizard iOS physics simulation app.

## 📱 Platform & Requirements

### Target Platform
- **iOS Version**: 15.0+ minimum deployment target
- **Architecture**: Universal (ARM64, supports all modern iOS devices)
- **Orientation**: Portrait primary, landscape supported with adapted controls
- **Performance**: Optimized for 120 FPS on capable devices
- **Memory**: Efficient resource management for sustained gameplay

### Hardware Dependencies
- **Motion**: Accelerometer and gyroscope for tilt controls
- **Audio**: Speaker or headphones for sound effects
- **Display**: Supports all iOS screen sizes and resolutions
- **Processor**: Optimized for A-series chips, compatible with older hardware

## 🎯 Architecture Overview

### Hybrid SwiftUI + SpriteKit Design
The app uses a sophisticated hybrid architecture combining the best of both frameworks:

```
LizardApp (SwiftUI)
├── ContentView (SwiftUI UI Layer)
├── LizardScene (SpriteKit Physics)
├── GameCenterManager (Game Services)
├── SoundPlayer (Audio Engine)
├── BetaFeedbackManager (TestFlight)
└── DynamicBackgroundView (SwiftUI Graphics)
```

### Key Architectural Decisions

#### SwiftUI for UI Layer
- **Modern Declarative**: Reactive UI updates with state management
- **Platform Integration**: Native iOS controls and behaviors
- **Accessibility**: Built-in accessibility support
- **Performance**: Optimized rendering for UI elements

#### SpriteKit for Physics
- **Specialized**: Purpose-built for 2D physics simulation
- **Performance**: Hardware-accelerated graphics and physics
- **Mature**: Battle-tested framework with extensive capabilities
- **Integration**: Seamless embedding within SwiftUI via UIViewRepresentable

## 🎮 Core Components

### LizardApp.swift - Application Entry Point
```swift
@main
struct LizardApp: App {
    init() {
        AudioSession.configure()
        BetaFeedbackManager.shared.start()
    }
}
```

**Responsibilities**:
- App lifecycle management
- Audio session configuration
- Beta feedback system initialization
- Resource cleanup on termination

### ContentView.swift - Primary UI Controller
**State Management**:
- `@AppStorage` for persistent data (scores, taps)
- `@State` for UI state (button presses, timers)
- `@Environment` for system state (color scheme, scene phase)

**UI Components**:
- Liquid glass button system
- HUD overlays for statistics
- Gesture recognition for controls
- App lifecycle event handling

### LizardScene.swift - Physics Engine Core

#### Performance Optimizations
```swift
private struct Config {
    static let maxPhysicsLizards = 300
    static let lizardLifetime: TimeInterval = 10
    static let lowFPSThreshold: Double = 45
    static let fpsUpdateAlpha = 0.15
}
```

**Physics Configuration**:
- **Gravity**: Configurable gravity vector (-9.8 default downward)
- **Collision**: Screen boundary collision detection
- **Lifecycle**: Automatic 10-second lizard cleanup
- **Performance**: Dynamic quality scaling based on FPS

**Memory Management**:
- Automatic node cleanup after lifetime expiration
- Performance monitoring with consecutive low-FPS detection
- Dynamic spawning throttling under memory pressure
- Efficient texture sharing across lizard instances

## 🎨 Rendering Pipeline

### Dynamic Background System

#### Time-Based Rendering
```swift
private func progressOfDay(_ date: Date) -> Double {
    // Calculate 0...1 progress through 24-hour day
    let seconds = h * 3600 + m * 60 + s
    return seconds / 86400.0
}
```

**Background Layers**:
1. **Sky Gradient**: Multi-stop linear gradient based on time
2. **Star Field**: 140 procedurally positioned stars with twinkling
3. **Color Interpolation**: Smooth transitions between day/night palettes

#### Liquid Glass UI Effects
**Implementation**:
- Semi-transparent backgrounds with blur effects
- Layered shadow and highlight rendering
- Depth perception through visual hierarchy
- Responsive pressed states with scaling animations

### SpriteKit Integration
**TransparentSpriteView**: Custom UIViewRepresentable wrapper
- Transparent background for overlay rendering
- 120 FPS preferred performance target
- Hit testing disabled for underlying UI interaction
- Automatic scene sizing and scaling

## 🎵 Audio Architecture

### SoundPlayer.swift - Multi-Voice Audio System

#### Voice Pooling Implementation
```swift
private var soundPools: [String: [AVAudioPlayer]] = [:]
private var lastPlayTimes: [String: TimeInterval] = [:]
```

**Features**:
- **Pool Management**: Multiple AVAudioPlayer instances per sound
- **Rate Limiting**: Prevents audio spam with timing controls
- **Memory Efficiency**: Preloaded sounds for zero-latency playback
- **Background Support**: Audio continues during app switching

#### Audio Session Configuration
- **Silent Mode**: Continues playing even when device is silenced
- **Mixing**: Allows simultaneous playback with other apps
- **Interruption Handling**: Graceful handling of calls and alerts

## 🏆 Game Center Integration

### GameCenterManager.swift - Social Features

#### Modern iOS 18+ API Usage
```swift
func report(scores: [(id: String, value: Int)], context: Int = 0) {
    for s in scores {
        GKLeaderboard.submitScore(
            s.value,
            context: context,
            player: GKLocalPlayer.local,
            leaderboardIDs: [s.id]
        )
    }
}
```

**Architecture Benefits**:
- **Batch Reporting**: Efficient multi-score submission
- **Error Handling**: Graceful failure with console logging
- **Authentication**: Automatic login flow management
- **Access Point**: Floating UI for quick Game Center access

### Achievement System
**Identifiers**:
- `com.town3r.lizard.ach.first100` - First Century
- `com.town3r.lizard.ach.first500` - Lizard Master  
- `com.town3r.lizard.ach.tap100` - Button Masher

**Progress Tracking**:
- Real-time achievement evaluation
- Batch reporting for performance
- Completion banners for user feedback

## 🧭 Motion Control System

### CoreMotion Integration

#### Device Motion Processing
```swift
motionMgr.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: .main) { 
    [weak self] motion, _ in
    guard let self, self.tiltEnabled, let m = motion else { return }
    // Transform device gravity to screen coordinates
}
```

**Coordinate Transformation**:
- **Reference Frame**: xArbitraryZVertical for consistent orientation
- **Gravity Mapping**: Device acceleration to screen gravity vector
- **Orientation Handling**: Automatic rotation compensation
- **Safety Limits**: Prevents unnatural upward gravity in landscape

#### Performance Considerations
- **Update Rate**: 60 FPS motion updates
- **Memory**: Efficient motion manager lifecycle
- **Battery**: Optimized for minimal power consumption
- **Accuracy**: Hardware-calibrated sensor data

## 🔧 Performance Engineering

### Optimization Strategies

#### Physics Performance
- **Object Limiting**: Maximum 300 concurrent physics bodies
- **Lifecycle Management**: Automatic 10-second object cleanup
- **FPS Monitoring**: Real-time performance tracking
- **Dynamic Quality**: Automatic spawning reduction under load

#### Memory Management
```swift
deinit {
    stopTilt()
    // Ensure motion manager cleanup
}
```

**Resource Cleanup**:
- Automatic motion manager stoppage
- Timer invalidation on view disappearance
- Physics world cleanup on scene destruction
- Audio player pool management

#### Battery Optimization
- **Motion Controls**: Optional feature, can be disabled
- **Audio**: Efficient pooling reduces CPU overhead
- **Rendering**: Optimized SpriteKit rendering pipeline
- **Background**: Automatic pause during app backgrounding

### Performance Monitoring
**FPS Tracking**:
- Smoothed delta time calculation
- Consecutive low-FPS frame counting
- Automatic quality adjustment triggers
- Debug visualization (development builds)

## 🧪 Testing & Quality Assurance

### BetaFeedbackManager.swift - TestFlight Integration

#### Screenshot Detection
```swift
screenshotObserver = NotificationCenter.default.addObserver(
    forName: UIApplication.userDidTakeScreenshotNotification,
    object: nil,
    queue: .main
) { [weak self] _ in
    self?.showFeedbackSheet()
}
```

**Beta Features**:
- Automatic screenshot detection during TestFlight
- Mail composer integration for feedback collection
- Privacy-safe implementation (no screenshot data access)
- Lifecycle management with observer cleanup

### Unit Testing Architecture
**LizardTests.swift Coverage**:
- SoundPlayer functionality and rate limiting
- Notification system validation
- BetaFeedbackManager lifecycle testing
- Gravity transformation verification
- Public API safety testing

## 🔐 Security & Privacy

### Data Handling
- **Local Storage**: UserDefaults for non-sensitive preferences
- **No Analytics**: No third-party tracking or analytics
- **Game Center**: Apple's secure social gaming platform
- **Permissions**: Motion access only, no location or camera

### Privacy Features
- **Screenshot Safety**: Beta feedback doesn't access screenshot content
- **Offline Capable**: Core functionality works without internet
- **Game Center Optional**: Social features are completely optional
- **No Personal Data**: No collection of personal information

## 📊 Configuration & Tuning

### Adjustable Parameters
All major gameplay parameters are centralized in configuration structs:

```swift
private struct Config {
    static let gravityDown: CGFloat = -9.8
    static let maxPhysicsLizards = 300
    static let baseLizardSize: CGFloat = 80
    static let lizardLifetime: TimeInterval = 10
    static let rainDropsPerBurst = 16
    static let spewTimerInterval: TimeInterval = 0.07
    static let liquidGlassCornerRadius: CGFloat = 24
}
```

**Benefits**:
- Easy gameplay tuning without code searching
- Consistent values across components
- Simple A/B testing capability
- Clear documentation of game balance

## 🚀 Build & Deployment

### Project Structure
```
Lizard.xcodeproj
├── Lizard (Main Target)
├── LizardTests (Unit Tests)
├── Assets.xcassets (App Icons, Images)
├── Info.plist (App Configuration)
└── Lizard.entitlements (Game Center, Motion)
```

### Build Configuration
- **Swift Version**: Latest stable
- **Deployment Target**: iOS 18.0
- **Architecture**: Universal (ARM64)
- **Entitlements**: Game Center, HealthKit (motion)

### Performance Targets
- **Launch Time**: < 2 seconds cold start
- **Memory**: < 100MB typical usage
- **FPS**: 60+ FPS sustained, 120 FPS capable
- **Battery**: Minimal impact during normal usage

---

## 🔮 Future Technical Considerations

### Scalability Plans
- Metal rendering for advanced particle effects
- CloudKit for cross-device score synchronization
- ARKit integration for 3D lizard physics
- Machine learning for adaptive difficulty

### Platform Evolution
- SwiftUI Canvas for additional visual effects
- Async/await adoption for improved performance
- New Game Center features as they become available
- Accessibility enhancements for broader user base

---

*This technical foundation enables Lizard's delightful physics simulation while maintaining excellent performance and user experience! 🦎⚡*