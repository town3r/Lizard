# 🔨 Building and Development Guide

Complete guide for setting up, building, and developing the Lizard iOS physics simulation app.

## 🛠️ Development Environment Setup

### Prerequisites

#### Required Software
- **Xcode 15.0+**: Latest stable version recommended
- **iOS 18.0+ SDK**: For deployment target compatibility
- **macOS**: Xcode only runs on macOS for iOS development
- **Apple Developer Account**: Required for device testing and App Store distribution

#### Hardware Requirements
- **Mac**: Intel or Apple Silicon Mac capable of running Xcode
- **iOS Device**: iPhone or iPad for testing motion controls (Simulator lacks accelerometer)
- **Storage**: ~50GB free space for Xcode, SDKs, and project files

### Xcode Installation
1. Download Xcode from the Mac App Store or Apple Developer portal
2. Install Command Line Tools: `xcode-select --install`
3. Verify installation: `xcode-select -p`
4. Accept license: `sudo xcodebuild -license accept`

## 📁 Project Structure

### Repository Layout
```
Lizard/
├── README.md                    # Project overview
├── CHANGELOG.md                 # Release notes  
├── FEATURES.md                  # Feature documentation
├── CONTROLS.md                  # User controls guide
├── TECHNICAL.md                 # Architecture details
├── BUILDING.md                  # This file
├── Lizard.xcodeproj/           # Xcode project
├── Lizard/                     # Main iOS app source
│   ├── LizardApp.swift         # App entry point
│   ├── ContentView.swift       # Primary UI
│   ├── LizardScene.swift       # Physics engine
│   ├── GameCenterManager.swift # Game Center integration
│   ├── SoundPlayer.swift       # Audio system
│   ├── DynamicBackgroundView.swift # Time-based background
│   ├── BetaFeedbackManager.swift # TestFlight feedback
│   ├── Assets.xcassets/        # Images and icons
│   ├── Info.plist             # App configuration
│   └── Lizard.entitlements    # Capabilities
├── LizardTests/               # iOS unit tests
│   └── LizardTests.swift
├── LizardWatch WatchKit App/  # watchOS app source
│   ├── LizardWatchApp.swift   # watchOS app entry point
│   ├── ContentView.swift      # Simplified watchOS UI
│   ├── WatchGameCenterManager.swift # watchOS GameCenter
│   ├── WatchSoundPlayer.swift # watchOS audio + haptics
│   ├── Assets.xcassets/       # watchOS icons
│   ├── Info.plist            # watchOS configuration
│   ├── LizardWatch.entitlements # watchOS capabilities
│   └── lizard.wav            # Audio file
├── LizardWatchTests/         # watchOS unit tests
│   └── LizardWatchTests.swift
├── docs/                     # Documentation
│   ├── WATCHOS.md           # watchOS version details
│   ├── WATCHOS_INTEGRATION.md # Integration guide
│   └── ...
└── scripts/                  # Helper scripts
    └── watchos-integration-helper.sh
```

### Key Files Explained

#### Core Application
- **LizardApp.swift**: SwiftUI app entry point and lifecycle management
- **ContentView.swift**: Main UI layer with controls and state management
- **LizardScene.swift**: SpriteKit physics simulation engine

#### Support Systems
- **GameCenterManager.swift**: Leaderboards and achievements
- **SoundPlayer.swift**: Multi-voice audio system with pooling
- **DynamicBackgroundView.swift**: Real-time day/night background rendering
- **BetaFeedbackManager.swift**: TestFlight screenshot-to-feedback system

#### Configuration
- **Info.plist**: App metadata, permissions, and capabilities
- **Lizard.entitlements**: Game Center and motion access permissions
- **Assets.xcassets**: App icons, launch screen, and image assets

#### watchOS Components
- **LizardWatchApp.swift**: watchOS app entry point with SwiftUI
- **WatchGameCenterManager.swift**: Simplified GameCenter for watchOS
- **WatchSoundPlayer.swift**: Audio system with haptic feedback for watchOS
- **AnimatedLizard struct**: SwiftUI-based lizard animations for watch

#### Integration Resources
- **docs/WATCHOS_INTEGRATION.md**: Complete step-by-step integration guide
- **scripts/watchos-integration-helper.sh**: Pre-integration verification script

## 🚀 Building the Project

### Opening the Project
1. Clone the repository: `git clone [repository-url]`
2. Navigate to project directory: `cd Lizard`
3. Open in Xcode: `open Lizard.xcodeproj`
4. Wait for Xcode to index and prepare the project

### Build Configurations

#### Debug Build (Development)
```bash
# Command line build
xcodebuild -project Lizard.xcodeproj -scheme Lizard -configuration Debug
```

**Debug Features**:
- Debug symbols included
- Assertions enabled
- Performance monitoring active
- Console logging enabled
- Beta feedback system active

#### Release Build (Distribution)
```bash
# Command line build
xcodebuild -project Lizard.xcodeproj -scheme Lizard -configuration Release
```

**Release Optimizations**:
- Code optimization enabled
- Debug symbols stripped
- Assertions disabled
- Minimal logging
- Maximum performance

### Build Targets

#### Main App Target: "Lizard"
- **Product Name**: Lizard
- **Bundle Identifier**: `com.town3r.lizard`
- **Platform**: iOS 18.0+
- **Architecture**: Universal (ARM64)

#### Test Target: "LizardTests"
- **Purpose**: iOS unit testing
- **Coverage**: Core iOS functionality validation
- **Host Application**: Lizard app target

#### watchOS Integration Targets ✅
The project includes complete watchOS app implementation with integrated targets:

- **LizardWatch Target** ✅:
  - **Product Name**: LizardWatch
  - **Bundle Identifier**: `com.town3r.lizard.watchkitapp` 
  - **Platform**: watchOS 9.0+
  - **Purpose**: Standalone watchOS lizard simulation app
  - **Status**: Fully integrated and functional

- **LizardWatchTests Target** ✅:
  - **Purpose**: watchOS unit testing
  - **Host Application**: LizardWatch target
  - **Status**: Integrated with comprehensive test coverage

**🍎 watchOS Integration Complete**: All targets have been successfully integrated into the Xcode project. See `docs/WATCHOS_INTEGRATION_COMPLETE.md` for implementation details.

## 🧪 Testing

### Running Unit Tests

#### Via Xcode
1. Select the LizardTests scheme
2. Press `Cmd+U` to run all tests
3. View results in the Test Navigator

#### Via Command Line
```bash
# Run all tests
xcodebuild test -project Lizard.xcodeproj -scheme Lizard -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest'

# Run specific test class
xcodebuild test -project Lizard.xcodeproj -scheme Lizard -only-testing:LizardTests/LizardTests -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest'
```

### Test Coverage

#### Current Test Suite
- **SoundPlayer**: Audio system functionality and rate limiting
- **Notifications**: Custom notification system validation  
- **BetaFeedbackManager**: TestFlight feedback lifecycle
- **LizardScene**: Physics engine public API safety
- **Gravity System**: Motion control coordinate transformations

#### Adding New Tests
```swift
func testNewFeature() {
    // Arrange
    let testObject = ComponentToTest()
    
    // Act
    let result = testObject.performAction()
    
    // Assert
    XCTAssertEqual(result, expectedValue)
}
```

### Device Testing

#### Physical Device Setup
1. Connect iPhone/iPad via USB or WiFi
2. Trust computer on device when prompted
3. Select device in Xcode's device menu
4. Build and run (`Cmd+R`)

#### Motion Control Testing
**Important**: Accelerometer and gyroscope functionality requires physical device testing. iOS Simulator cannot simulate device motion accurately.

**Test Scenarios**:
- Portrait orientation tilt controls
- Landscape orientation gravity transformation
- Rapid orientation changes
- Extreme tilt angles
- Motion permission handling

## 🍎 watchOS Integration

The project includes complete source code for a watchOS version of Lizard that needs to be integrated into the main Xcode project.

### Quick Start Integration

1. **Run the integration helper**:
   ```bash
   ./scripts/watchos-integration-helper.sh
   ```

2. **Open Xcode and follow the integration guide**:
   ```bash
   open Lizard.xcodeproj
   # Then follow docs/WATCHOS_INTEGRATION.md
   ```

### Post-Integration Build Commands

After completing the integration in Xcode:

```bash
# Build all targets
xcodebuild -project Lizard.xcodeproj -scheme Lizard -configuration Debug
xcodebuild -project Lizard.xcodeproj -scheme LizardWatch -configuration Debug

# Test all targets
xcodebuild test -project Lizard.xcodeproj -scheme Lizard -destination 'platform=iOS Simulator,name=iPhone 15'
xcodebuild test -project Lizard.xcodeproj -scheme LizardWatch -destination 'platform=watchOS Simulator,name=Apple Watch Series 9 (45mm)'
```

### watchOS Features Included

- **Simplified Physics**: SwiftUI animations instead of SpriteKit
- **Touch Interaction**: Tap-to-spawn lizards optimized for watch screens
- **Haptic Feedback**: WKInterfaceDevice integration for tactile responses
- **GameCenter**: Scaled-down achievements and leaderboards
- **Performance Optimized**: Limited concurrent animations for watch hardware

📖 **Complete guide**: `docs/WATCHOS_INTEGRATION.md`

## 🔧 Development Workflow

### Code Organization

#### SwiftUI Best Practices
- State management with `@State`, `@AppStorage`, `@Environment`
- Reactive UI updates with data binding
- Modular view composition
- Accessibility support built-in

#### SpriteKit Integration
- Clean separation between UI and physics layers
- Efficient resource management
- Performance monitoring and optimization
- Memory-conscious object lifecycle

### Performance Development

#### Profiling Tools
- **Instruments**: Use Time Profiler and Allocations instruments
- **Xcode Debug Navigator**: Monitor memory, CPU, and FPS in real-time
- **Console Logging**: Performance metrics logged during development

#### Performance Targets
- **Frame Rate**: Sustained 60+ FPS, 120 FPS on capable devices
- **Memory**: < 100MB typical usage
- **Launch Time**: < 2 seconds cold start
- **Battery**: Minimal background impact

### Debugging

#### Common Debug Scenarios

##### Physics Issues
```swift
// Add to LizardScene for debug visualization
override func didMove(to view: SKView) {
    super.didMove(to: view)
    #if DEBUG
    view.showsPhysics = true  // Show collision boundaries
    view.showsFPS = true      // Display frame rate
    #endif
}
```

##### Audio Problems
```swift
// Add to SoundPlayer for audio debugging
func play(name: String, ext: String) {
    #if DEBUG
    print("Playing sound: \(name).\(ext)")
    #endif
    // ... existing implementation
}
```

##### Motion Control Issues
```swift
// Add to motion update handler for gravity debugging
private func handleMotionUpdate(_ motion: CMDeviceMotion) {
    #if DEBUG
    print("Device gravity: x=\(motion.gravity.x), y=\(motion.gravity.y)")
    #endif
    // ... existing implementation
}
```

## 📱 Deployment

### TestFlight Beta Distribution

#### Preparing Beta Build
1. Archive build in Xcode (`Product > Archive`)
2. Select "Distribute App" from Organizer
3. Choose "App Store Connect" for TestFlight
4. Upload and wait for processing

#### Beta Tester Features
- Screenshot-to-feedback automatically enabled
- Performance monitoring active
- Debug logging available
- Crash reporting enhanced

### App Store Release

#### Pre-Release Checklist
- [ ] All unit tests passing
- [ ] Device testing on multiple iOS versions
- [ ] Performance profiling completed
- [ ] Game Center configuration verified
- [ ] App Store screenshots and metadata prepared
- [ ] Privacy policy updated if needed

#### Release Build Process
1. Update version numbers in project settings
2. Create release archive with optimizations
3. Submit for App Store review
4. Monitor review status in App Store Connect

## 🔄 Continuous Integration

### GitHub Actions (Example)
```yaml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: macos-latest
    steps:
    - uses: actions/checkout@v2
    - name: Build and Test
      run: |
        xcodebuild test -project Lizard.xcodeproj -scheme Lizard -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest'
```

### Automated Checks
- Build verification on multiple iOS versions
- Unit test execution
- Static analysis for code quality
- Performance regression detection

## 🛠️ Development Tools

### Recommended Xcode Extensions
- **SwiftLint**: Code style and quality enforcement
- **SourceKit-LSP**: Enhanced code completion and analysis
- **Git integration**: Built-in version control

### External Tools
- **SF Symbols**: For system icon browsing
- **Simulator**: iOS device simulation (limited motion support)
- **Console.app**: System logging and crash analysis

## 🐛 Troubleshooting

### Common Build Issues

#### Code Signing Problems
- Verify Apple Developer account status
- Check certificate expiration dates
- Ensure bundle identifier matches provisioning profile
- Clear derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`

#### Simulator Issues
- Reset iOS Simulator content and settings
- Restart Xcode and Simulator
- Verify iOS version compatibility
- Check available disk space

#### Device Connection Problems
- Trust computer on device
- Restart Xcode and device
- Check USB cable connection
- Verify device is unlocked

### Performance Issues

#### Memory Leaks
- Use Instruments Allocations tool
- Check for retain cycles in closures
- Verify proper observer cleanup
- Monitor physics object lifecycle

#### Frame Rate Drops
- Profile with Time Profiler instrument
- Check physics object count limits
- Verify audio system efficiency
- Monitor background app refresh

## 📚 Additional Resources

### Apple Documentation
- [SwiftUI Framework](https://developer.apple.com/documentation/swiftui)
- [SpriteKit Framework](https://developer.apple.com/documentation/spritekit)
- [Game Center Programming Guide](https://developer.apple.com/documentation/gamekit)
- [Core Motion Framework](https://developer.apple.com/documentation/coremotion)

### Learning Resources
- [Swift Programming Language Guide](https://docs.swift.org/swift-book/)
- [iOS Development Tutorials](https://developer.apple.com/tutorials/)
- [SpriteKit Best Practices](https://developer.apple.com/videos/play/wwdc2014/608/)

---

## 🚀 Getting Started Quick Reference

```bash
# 1. Clone repository
git clone [repository-url]
cd Lizard

# 2. Open in Xcode
open Lizard.xcodeproj

# 3. Build and run
# Press Cmd+R in Xcode or:
xcodebuild -project Lizard.xcodeproj -scheme Lizard

# 4. Run tests
# Press Cmd+U in Xcode or:
xcodebuild test -project Lizard.xcodeproj -scheme Lizard -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest'
```

---

*Happy coding! Build amazing lizard physics simulations! 🦎🔨*