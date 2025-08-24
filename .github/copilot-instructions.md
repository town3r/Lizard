# Lizard iOS Game App

Lizard is a physics-based iOS game built with SwiftUI and SpriteKit where lizards spawn and fall under device-controlled gravity. The app integrates with GameCenter for achievements/leaderboards and includes audio feedback and beta testing features.

**ALWAYS reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.**

## CRITICAL PLATFORM REQUIREMENT
**MANDATORY**: This project REQUIRES macOS with Xcode installed. Cannot be built on Linux or Windows environments. All build commands in these instructions can ONLY be validated and executed on macOS systems with Xcode properly installed.

## Working Effectively

### CRITICAL: macOS Development Environment Required
- **MANDATORY**: This project REQUIRES macOS with Xcode installed. Cannot be built on Linux or Windows.
- **Xcode Version**: Use Xcode 15.0+ supporting iOS 18.0+ development
- **Target Platform**: iOS 18.0+ (iPhone and iPad)
- **Prerequisites Setup**: Run `xcode-select --install` and `sudo xcodebuild -license accept`

### Environment Setup and Dependencies
```bash
# Install Xcode command line tools - REQUIRED
xcode-select --install

# Accept Xcode license - REQUIRED  
sudo xcodebuild -license accept

# Verify Xcode installation
xcode-select -p
```

### Bootstrap and Build Process
- **Clone and Open**: `git clone [repo-url] && cd Lizard && open Lizard.xcodeproj`
- **Build via Xcode**: `⌘+B` in Xcode 
- **Build via Command Line**: `xcodebuild -project Lizard.xcodeproj -scheme Lizard -configuration Debug`
- **Build Time**: Clean build takes 30-60 seconds. **NEVER CANCEL - set timeout to 300+ seconds (5+ minutes).**
- **Run in Simulator**: `⌘+R` in Xcode OR `xcodebuild -project Lizard.xcodeproj -scheme Lizard -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max,OS=26.0'`
- **Archive for Distribution**: `⌘+Shift+B` in Xcode for TestFlight/App Store builds - takes 2-3 minutes. **NEVER CANCEL - set timeout to 600+ seconds (10+ minutes).**

### Clean Build Process  
```bash
# Clean build folder - use when builds fail
xcodebuild clean -project Lizard.xcodeproj

# Clean and rebuild - NEVER CANCEL, takes 45-90 seconds
xcodebuild clean -project Lizard.xcodeproj && xcodebuild -project Lizard.xcodeproj -scheme Lizard -configuration Debug
```

### Testing
- **Run Unit Tests via Xcode**: `⌘+U` in Xcode
- **Run Unit Tests via Command Line**: `xcodebuild test -project Lizard.xcodeproj -scheme Lizard -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max,OS=26.0'`
- **Test Duration**: Unit tests run in 10-15 seconds. **NEVER CANCEL - set timeout to 120+ seconds (2+ minutes).**
- **Test Coverage**: Tests cover SoundPlayer, GameCenterManager, LizardScene, BetaFeedbackManager, and gravity transformations
- **Available Test Targets**: Lizard (main), LizardTests (unit tests)

### Project Structure Verification
```bash
# List all available targets and schemes - ALWAYS run this first
xcodebuild -project Lizard.xcodeproj -list

# Verify project health
xcodebuild -project Lizard.xcodeproj -scheme Lizard -configuration Debug -dry-run
```

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
- **Test Multiple Simulators**: iPhone SE (small screen), iPhone 16 (current), iPhone 16 Pro Max (large screen)

### Troubleshooting Build Issues
```bash
# If builds fail, try these steps in order:
# 1. Clean derived data
rm -rf ~/Library/Developer/Xcode/DerivedData

# 2. Clean and rebuild - NEVER CANCEL, can take 2+ minutes
xcodebuild clean -project Lizard.xcodeproj && xcodebuild -project Lizard.xcodeproj -scheme Lizard

# 3. Reset iOS Simulator if needed
xcrun simctl erase all
```

## Validation

### CRITICAL: Manual Testing Scenarios
**ALWAYS perform these validation steps after making changes - REQUIRED for complete validation:**

1. **Basic App Launch**:
   - Launch app in iOS Simulator (use iPhone 16 Pro Max simulator)
   - Verify splash screen loads within 3-5 seconds
   - Check that main UI appears with lizard button

2. **Core Gameplay**:
   - Tap the central lizard button - lizards should spawn and fall downward
   - Hold the rain button - multiple lizards should spawn continuously  
   - Verify physics behavior - lizards should bounce and interact realistically

3. **Device Motion Testing** (requires physical device):
   - Rotate device - lizards should fall in gravity direction
   - Test all orientations: Portrait, Landscape Left/Right, Portrait Upside Down
   - Verify motion permission dialog appears on first launch

4. **Audio Testing**:
   - Ensure system volume is up and test audio feedback
   - Verify sound plays when lizards spawn (check simulator audio output)
   - Test silent mode compatibility

5. **Performance Validation**:
   - Spawn many lizards rapidly (tap button repeatedly)
   - Monitor FPS counter in debug builds - should remain above 45fps
   - Check for memory leaks during extended gameplay

6. **GameCenter Integration**:
   - Test GameCenter integration (may require Apple ID sign-in)
   - Verify achievement notifications appear
   - Check trophy icon appears in top-trailing position

7. **Beta Feedback Flow**:
   - Take screenshot in simulator (`⌘+S`) - should trigger beta feedback flow
   - Verify feedback manager doesn't crash on screenshot events

### Code Quality Checks
- **No built-in linting** - Swift compiler provides warnings/errors
- **ALWAYS address Xcode warnings** before committing - use `-DSQLITE_ENABLE_FTS5=1` flag if needed
- **Memory Testing**: Use Instruments in Xcode to check for leaks during physics simulation
- **Performance Testing**: Monitor FPS counter in debug builds during heavy lizard spawning
- **Build Warnings Check**: `xcodebuild -project Lizard.xcodeproj -scheme Lizard | grep warning`

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
├── AppConfiguration.swift   # Centralized app configuration constants
├── DynamicBackgroundView.swift # Time-based background system
├── WeatherControlView.swift  # Weather system controls
├── SettingsView.swift        # App settings and preferences
├── Assets.xcassets/          # App icons and lizard images
├── Info.plist               # App metadata and capabilities
└── Lizard.entitlements      # App capabilities configuration
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
  - `AppConfiguration.swift` - All app configuration constants
  - `DynamicBackgroundView.swift` - Background and weather systems

### Component Relationships
- `ContentView` integrates `LizardScene` via `SpriteView`
- `LizardScene` sends spawn notifications back to `ContentView` for score tracking
- `ContentView` calls `GameCenterManager` for achievements/leaderboards  
- `SoundPlayer` is used globally for audio feedback
- `BetaFeedbackManager` listens for screenshot notifications independently
- `MotionGravity` utilities used by `LizardScene` for device tilt physics
- `AppConfiguration` provides centralized constants used throughout the app

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

### Key Configuration Constants (AppConfiguration.swift)
- `Physics.maxPhysicsLizards = 300` - Hard limit on simultaneous lizards for performance
- `Physics.baseLizardSize: CGFloat = 80` - Default size for spawned lizards  
- `Physics.lizardLifetime: TimeInterval = 10` - How long lizards live before cleanup
- `Performance.lowFPSThreshold: Double = 45` - Performance monitoring threshold
- `Physics.motionUpdateInterval = 1.0 / 60.0` - Gravity sensor update frequency
- `Audio.rateLimitInterval: CFTimeInterval = 0.03` - 30ms audio rate limiting
- `UI.centerButtonSize: CGFloat = 240` - Main button size
- `Timing.spewTimerInterval: TimeInterval = 0.07` - Lizard spawn timing

### Achievement/Leaderboard IDs (GameCenterManager.swift)
- `"com.town3r.lizard.ach.first100"` - First 100 lizards spawned
- `"com.town3r.lizard.ach.first500"` - First 500 lizards spawned  
- `"com.town3r.lizard.ach.tap100"` - 100 button taps
- Leaderboard IDs defined in ContentView for total spawned and button taps

## Troubleshooting Common Issues

### Build Failures
- **Code signing issues**: Check Apple Developer account and certificates in Xcode > Preferences > Accounts
- **Missing provisioning profile**: Download from Apple Developer portal, ensure bundle ID matches
- **Simulator not found**: Install additional simulators in Xcode > Preferences > Components
- **Invalid deployment target**: Ensure iOS 18.0+ in project settings 
- **Clean derived data**: `rm -rf ~/Library/Developer/Xcode/DerivedData` then rebuild

### Runtime Issues  
- **Audio not playing**: Check AudioSession configuration in `SoundPlayer.swift`, verify simulator audio
- **GameCenter not working**: Verify signed in to Apple ID and Game Center enabled in Settings
- **Performance degradation**: Check lizard count and FPS monitoring, verify maxPhysicsLizards limit
- **Physics bugs**: Review gravity transformation logic in orientation changes
- **Background not updating**: Check weather system permissions and time-based logic

### Testing Issues
- **Unit tests failing**: Check that audio files (`lizard.wav`) and assets are available in bundle
- **Simulator crashes**: Try different simulator device types (iPhone 16, iPhone SE)
- **GameCenter tests failing**: Some features require device testing, simulator has limitations
- **Test timeout**: Increase timeout values, tests may take longer on slower machines

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

## EXACT COMMANDS FOR DEVELOPMENT WORKFLOW

### Initial Setup (Run Once)
```bash
# Clone repository
git clone https://github.com/town3r/Lizard.git
cd Lizard

# Verify Xcode installation (REQUIRED)
xcode-select -p
xcode-select --install  # If needed

# Accept Xcode license (REQUIRED)
sudo xcodebuild -license accept

# Open project
open Lizard.xcodeproj
```

### Standard Development Commands
```bash
# List targets and schemes (run this first to verify project)
xcodebuild -project Lizard.xcodeproj -list

# Clean build - NEVER CANCEL, takes 30-90 seconds, timeout 300+ seconds
xcodebuild clean -project Lizard.xcodeproj
xcodebuild -project Lizard.xcodeproj -scheme Lizard -configuration Debug

# Run tests - NEVER CANCEL, takes 10-15 seconds, timeout 120+ seconds  
xcodebuild test -project Lizard.xcodeproj -scheme Lizard -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max,OS=26.0'

# Build for simulator - NEVER CANCEL, takes 15-45 seconds
xcodebuild -project Lizard.xcodeproj -scheme Lizard -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max,OS=26.0'

# Check for build warnings
xcodebuild -project Lizard.xcodeproj -scheme Lizard -configuration Debug | grep warning
```

### After Making Code Changes - ALWAYS RUN THESE
```bash
# 1. Clean and build - NEVER CANCEL, timeout 300+ seconds
xcodebuild clean -project Lizard.xcodeproj && xcodebuild -project Lizard.xcodeproj -scheme Lizard -configuration Debug

# 2. Run tests - NEVER CANCEL, timeout 120+ seconds
xcodebuild test -project Lizard.xcodeproj -scheme Lizard -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max,OS=26.0'

# 3. Check for warnings
xcodebuild -project Lizard.xcodeproj -scheme Lizard | grep warning

# 4. MANDATORY: Run manual validation scenarios (see Validation section above)
```

### Build Time Expectations - NEVER CANCEL
- **Clean build**: 30-90 seconds (set timeout to 300+ seconds)
- **Incremental build**: 5-15 seconds (set timeout to 60+ seconds)
- **Test suite**: 10-15 seconds (set timeout to 120+ seconds)
- **Archive build**: 2-3 minutes (set timeout to 600+ seconds)

### Emergency Troubleshooting Commands
```bash
# If builds completely fail:
rm -rf ~/Library/Developer/Xcode/DerivedData
xcodebuild clean -project Lizard.xcodeproj
xcrun simctl erase all  # Reset simulators
open Lizard.xcodeproj   # Restart in Xcode
```

## IMPORTANT VALIDATION NOTE

**CRITICAL**: All xcodebuild commands in these instructions can ONLY be validated on macOS systems with Xcode installed. These commands will fail on Linux or Windows environments with "command not found" errors. 

If you encounter xcodebuild command failures, verify you are on macOS with:
```bash
uname -a  # Should show "Darwin" for macOS
which xcodebuild  # Should show path to xcodebuild
xcode-select -p   # Should show Xcode path
```

The commands in these instructions are based on the comprehensive repository documentation (BUILDING.md, CONTRIBUTING.md, BUILD_RESOLUTION_SUMMARY.md) and represent the validated workflow for macOS development environments.
