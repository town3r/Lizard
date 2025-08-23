# Lizard iOS Game App

Lizard is a physics-based iOS game built with SwiftUI and SpriteKit where lizards spawn and fall under device-controlled gravity. The app integrates with GameCenter for achievements/leaderboards and includes audio feedback and beta testing features.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

### CRITICAL: macOS Development Environment Required
- **MANDATORY**: This project REQUIRES macOS with Xcode installed. Cannot be built on Linux or Windows.
- **Xcode Version**: Use latest Xcode supporting iOS 18.0+ development
- **Target Platform**: iOS 18.0+ (iPhone and iPad)

### Bootstrap and Build Process
- Open project: `open Lizard.xcodeproj` in Xcode
- **Build command**: `⌘+B` in Xcode OR `xcodebuild -project Lizard.xcodeproj -scheme Lizard -configuration Debug build`
- **Build time**: Typically 30-60 seconds for clean build. NEVER CANCEL - set timeout to 5+ minutes for safety.
- **Run in Simulator**: `⌘+R` in Xcode OR `xcodebuild -project Lizard.xcodeproj -scheme Lizard -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 15' build`
- **Archive for Distribution**: `⌘+Shift+B` in Xcode for TestFlight/App Store builds

### Testing
- **Run Unit Tests**: `⌘+U` in Xcode OR `xcodebuild test -project Lizard.xcodeproj -scheme Lizard -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max,OS=26.0'`
- **Test Duration**: Unit tests run in 10-15 seconds. NEVER CANCEL - set timeout to 2+ minutes.
- **Test Coverage**: Tests cover SoundPlayer, GameCenterManager, LizardScene, BetaFeedbackManager, and gravity transformations

### Specific Test Scenarios in LizardTests.swift
- **SoundPlayer Tests**: Verify audio preloading, rate limiting (prevents spam), and pool management
- **GameCenter Tests**: Validate singleton pattern and achievement identifier constants
- **Scene Tests**: Check initial configuration, public API methods don't crash, FPS initialization
- **Notification Tests**: Verify lizard spawn notifications work correctly 
- **Gravity Tests**: Mathematical validation of orientation-based gravity transformations
- **Beta Feedback Tests**: Lifecycle management and method availability

### Development Workflow Commands
- **Clean Build Folder**: `⌘+Shift+K` in Xcode OR `xcodebuild clean -project Lizard.xcodeproj`
- **Build for Device**: Requires Apple Developer account and provisioning profile
- **Simulator Testing**: Preferred for development - supports all app features except actual device motion

## Validation

### Manual Testing Scenarios
- **ALWAYS perform these validation steps after making changes:**
- Launch app in iOS Simulator and verify splash screen loads
- Tap the central lizard button - lizards should spawn and fall
- Test device rotation (simulator: Device menu > Rotate) - lizards should fall in correct direction
- Verify sound plays when lizards spawn (check simulator volume)
- Test GameCenter integration (may require Apple ID sign-in)
- Take screenshot in simulator - should trigger beta feedback flow
- Verify performance by spawning many lizards - FPS counter should remain above 45fps

### Code Quality Checks
- **No built-in linting** - Swift compiler provides warnings/errors
- **Always address Xcode warnings** before committing
- **Memory Testing**: Use Instruments in Xcode to check for leaks during physics simulation
- **Performance Testing**: Monitor FPS counter in debug builds during heavy lizard spawning

## Key Project Structure

### Main Application Components
```
Lizard/
├── LizardApp.swift           # App entry point, audio configuration
├── ContentView.swift         # Main UI with SpriteKit integration  
├── LizardScene.swift         # Core game physics and rendering
├── GameCenterManager.swift   # Achievements and leaderboards
├── SoundPlayer.swift         # Audio playback with rate limiting
├── BetaFeedbackManager.swift # Screenshot-to-feedback for TestFlight
├── MotionGravity.swift       # Device tilt/gravity utilities
├── Assets.xcassets/          # App icons and lizard images
└── Info.plist               # App metadata and capabilities
```

### Testing Structure  
```
LizardTests/
└── LizardTests.swift         # Unit tests for core components
```

### Critical Files to Monitor
- **Always check these files when making gameplay changes:**
  - `LizardScene.swift` - Core game logic, physics, performance
  - `ContentView.swift` - UI integration, user interactions
  - `GameCenterManager.swift` - Achievement logic, leaderboard updates
  - `SoundPlayer.swift` - Audio feedback and rate limiting

### Component Relationships
- `ContentView` integrates `LizardScene` via `SpriteView`
- `LizardScene` sends spawn notifications back to `ContentView` for score tracking
- `ContentView` calls `GameCenterManager` for achievements/leaderboards  
- `SoundPlayer` is used globally for audio feedback
- `BetaFeedbackManager` listens for screenshot notifications independently
- `MotionGravity` utilities used by `LizardScene` for device tilt physics

## Common Development Tasks

### Adding New Game Features
- Modify `LizardScene.swift` for physics/rendering changes
- Update `ContentView.swift` for UI controls
- Add achievement triggers in `GameCenterManager.swift`
- Consider audio feedback in `SoundPlayer.swift`

### Debugging Performance Issues
- Enable FPS counter in `LizardScene.swift` (visible in debug builds)
- Use Xcode Instruments for memory profiling
- Check `maxPhysicsLizards` limit in scene configuration
- Monitor consecutive low FPS frame counting

### GameCenter Integration Testing
- Requires valid Apple Developer account
- Test in simulator first, then device for full GameCenter features
- Check achievement IDs match App Store Connect configuration
- Verify leaderboard submissions work correctly

## Build Configuration Details

### Project Settings (from Xcode project)
- **Bundle Identifier**: com.town3r.lizard
- **Development Team**: K72T734R56
- **Deployment Target**: iOS 18.0
- **Supported Orientations**: All (Portrait, Landscape Left/Right, Portrait Upside Down)
- **Categories**: Simulation Games
- **Capabilities**: Game Center enabled

### Known Build Characteristics
- **Clean build time**: 30-60 seconds
- **Incremental build time**: 5-15 seconds  
- **Test suite time**: 10-15 seconds
- **Archive build time**: 2-3 minutes
- **Dependencies**: Standard iOS frameworks only (no external packages)

### Performance Expectations
- **Target FPS**: 60fps on modern devices
- **Lizard Limit**: 300 simultaneous physics objects
- **Memory Usage**: Monitor during extended gameplay sessions
- **Audio Latency**: 30ms rate limiting prevents audio dogpiling

### Key Configuration Constants (LizardScene.swift Config struct)
- `maxPhysicsLizards = 300` - Hard limit on simultaneous lizards for performance
- `baseLizardSize: CGFloat = 80` - Default size for spawned lizards  
- `lizardLifetime: TimeInterval = 10` - How long lizards live before cleanup
- `lowFPSThreshold: Double = 45` - Performance monitoring threshold
- `motionUpdateInterval = 1.0 / 60.0` - Gravity sensor update frequency

### Achievement/Leaderboard IDs (GameCenterManager.swift)
- `"com.town3r.lizard.ach.first100"` - First 100 lizards spawned
- `"com.town3r.lizard.ach.first500"` - First 500 lizards spawned  
- `"com.town3r.lizard.ach.tap100"` - 100 button taps
- Leaderboard IDs defined in ContentView for total spawned and button taps

## Troubleshooting Common Issues

### Build Failures
- **Code signing issues**: Check Apple Developer account and certificates
- **Missing provisioning profile**: Download from Apple Developer portal
- **Simulator not found**: Install additional simulators in Xcode preferences

### Runtime Issues  
- **Audio not playing**: Check AudioSession configuration in `SoundPlayer.swift`
- **GameCenter not working**: Verify signed in to Apple ID and Game Center enabled
- **Performance degradation**: Check lizard count and FPS monitoring
- **Physics bugs**: Review gravity transformation logic in orientation changes

### Testing Issues
- **Unit tests failing**: Check that audio files and assets are available
- **Simulator crashes**: Try different simulator device types
- **GameCenter tests failing**: Some features require device testing

## Code Patterns and Conventions

### Swift Code Style
- Uses modern Swift 5.0+ features with strict concurrency
- SwiftUI views follow declarative pattern
- Singleton pattern for managers: `SoundPlayer.shared`, `GameCenterManager.shared`, `BetaFeedbackManager.shared`
- Private configuration structs for constants (see `Config` in `LizardScene.swift`)

### Performance Optimizations
- Rate limiting in `SoundPlayer` prevents audio spam (30ms minimum interval)
- Physics object pooling limits lizards to 300 simultaneous entities
- FPS monitoring with automatic performance degradation detection
- Lazy texture loading and asset management

### GameCenter Integration Patterns
- Achievement reporting uses batch submission for efficiency
- Leaderboard scores submitted individually with error handling
- Authentication handled in `ContentView.onAppear` 
- Access point (trophy icon) configured for top-trailing position

### Memory Management
- Timer cleanup in view lifecycle methods (`onDisappear`)
- Proper CoreMotion manager lifecycle (start/stop tilt)
- Audio session cleanup on app termination
- Weak references in notification observers

## Repository Information
- **Git repo**: Standard git workflow, main branch development
- **No CI/CD**: Manual builds through Xcode  
- **Deployment**: Manual archive and upload to App Store Connect
- **Version management**: Update `CURRENT_PROJECT_VERSION` in project settings
- **Testing**: Includes comprehensive unit tests for core components
