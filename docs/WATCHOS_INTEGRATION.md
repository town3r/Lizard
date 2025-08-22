# 🔗 watchOS Integration Guide

This guide walks through adding Apple Watch support to the Lizard iOS app. Follow these steps to create a complete watchOS companion app.

## 📋 Prerequisites

### Development Environment
- **Xcode 15.0+**: Required for watchOS app development
- **iOS Project**: Existing Lizard iOS app project
- **Apple Developer Account**: Required for watch app capabilities
- **Apple Watch**: Physical device recommended for testing

### Project Requirements
- **iOS Deployment Target**: iOS 18.0+
- **watchOS Deployment Target**: watchOS 9.0+
- **Swift Version**: Swift 5.9+

## 🚀 Quick Integration

The Lizard project includes a helper script to verify readiness for watchOS integration:

```bash
./scripts/watchos-integration-helper.sh
```

This script validates that all required watchOS source files are present and creates a backup of your project.

## 🛠️ Step-by-Step Integration

### Step 1: Project Backup
Always create a backup before making major changes:

```bash
cp -r Lizard.xcodeproj Lizard.xcodeproj.backup
```

### Step 2: Add watchOS Target

1. **Open Xcode Project**
   ```bash
   open Lizard.xcodeproj
   ```

2. **Add New Target**
   - Select project root in navigator
   - Click "+" to add new target
   - Choose "watchOS" → "App"
   - Name: `LizardWatch`
   - Bundle ID: `com.town3r.lizard.watchapp`
   - Deployment Target: watchOS 9.0

### Step 3: Configure watchOS Target

#### Build Settings
```
PRODUCT_NAME = LizardWatch
BUNDLE_IDENTIFIER = com.town3r.lizard.watchapp
WATCHOS_DEPLOYMENT_TARGET = 9.0
SWIFT_VERSION = 5.9
```

#### Capabilities
- Game Center (for achievements and leaderboards)
- App Groups (for shared data with iOS app)

### Step 4: Add watchOS Source Files

Create the following files in your `LizardWatch` target:

#### Core App Files
- `LizardWatchApp.swift` - App entry point
- `ContentView.swift` - Main watch interface
- `WatchGameCenterManager.swift` - GameCenter integration
- `WatchSoundPlayer.swift` - Audio system
- `Info.plist` - Watch app configuration

#### Shared Configuration
- Link `AppConfiguration.swift` to both iOS and watchOS targets
- Ensure `AppConfiguration.WatchOS` settings are accessible

### Step 5: Test Target Configuration

Add a test target for watchOS:

1. **Add watchOS Test Target**
   - Target type: "watchOS Unit Testing Bundle"
   - Name: `LizardWatchTests`
   - Link to `LizardWatch` target

2. **Create Test Files**
   - `LizardWatchTests.swift` - Basic functionality tests

### Step 6: Configure Schemes

1. **Create watchOS Scheme**
   - Product → Scheme → New Scheme
   - Name: `LizardWatch`
   - Target: `LizardWatch`

2. **Set up Build Order**
   - iOS app builds first
   - watchOS app builds second
   - Tests run after successful builds

## 🔧 Source File Structure

After integration, your project should have this structure:

```
Lizard.xcodeproj/
├── Lizard/                      # iOS app source
│   ├── LizardApp.swift
│   ├── ContentView.swift
│   ├── AppConfiguration.swift   # Shared config
│   └── ...
├── LizardWatch/                 # watchOS app source  
│   ├── LizardWatchApp.swift
│   ├── ContentView.swift
│   ├── WatchGameCenterManager.swift
│   ├── WatchSoundPlayer.swift
│   └── Info.plist
├── LizardTests/                 # iOS tests
│   └── LizardTests.swift
└── LizardWatchTests/           # watchOS tests
    └── LizardWatchTests.swift
```

## ⚙️ Configuration Details

### AppConfiguration Integration

The watchOS app uses shared configuration from `AppConfiguration.swift`:

```swift
// Shared between iOS and watchOS
enum AppConfiguration {
    enum Physics { ... }
    enum Performance { ... }
    
    // watchOS-specific settings
    enum WatchOS {
        static let maxLizards = 20
        static let lizardSize: CGFloat = 30
        static let animationDuration: TimeInterval = 2.0
        static let spawnButtonSize: CGFloat = 80
    }
}
```

### Build Configuration

#### iOS Target Settings
```
PRODUCT_NAME = Lizard
BUNDLE_IDENTIFIER = com.town3r.lizard
IPHONEOS_DEPLOYMENT_TARGET = 18.0
```

#### watchOS Target Settings
```
PRODUCT_NAME = LizardWatch  
BUNDLE_IDENTIFIER = com.town3r.lizard.watchapp
WATCHOS_DEPLOYMENT_TARGET = 9.0
```

## 🧪 Testing Integration

### Build Verification
```bash
# Build iOS target
xcodebuild -project Lizard.xcodeproj -scheme Lizard -destination 'platform=iOS Simulator,name=iPhone 15'

# Build watchOS target  
xcodebuild -project Lizard.xcodeproj -scheme LizardWatch -destination 'platform=watchOS Simulator,name=Apple Watch Series 9 (45mm)'
```

### Test Execution
```bash
# Run iOS tests
xcodebuild test -project Lizard.xcodeproj -scheme Lizard

# Run watchOS tests
xcodebuild test -project Lizard.xcodeproj -scheme LizardWatch
```

## 🚨 Common Integration Issues

### Issue: Missing Source Files
**Problem**: Build fails due to missing watchOS source files
**Solution**: Verify all files listed in `watchos-integration-helper.sh` exist

### Issue: Duplicate Symbols
**Problem**: Link errors from shared code between targets
**Solution**: Use target membership to control which files compile for each platform

### Issue: Deployment Target Conflicts
**Problem**: Build fails due to incompatible deployment targets
**Solution**: Ensure watchOS 9.0+ and iOS 18.0+ minimum targets

### Issue: GameCenter Configuration
**Problem**: GameCenter features don't work on watch
**Solution**: Configure separate App Store Connect entry for watchOS app

## 📱 Testing on Device

### iOS Device Testing
1. Connect iPhone with Xcode
2. Select iOS device as build destination
3. Build and run Lizard scheme

### Apple Watch Testing
1. Pair Apple Watch with development iPhone
2. Select Apple Watch as build destination
3. Build and run LizardWatch scheme
4. Watch app installs automatically

### Validation Checklist
- [ ] iOS app builds without errors
- [ ] watchOS app builds without errors  
- [ ] Both apps run on simulators
- [ ] Watch app installs on physical device
- [ ] GameCenter works on both platforms
- [ ] Data syncs between iOS and watchOS
- [ ] Audio and haptics work correctly

## 📖 Next Steps

After successful integration:

1. **Review Platform Differences**: See [iOS vs watchOS Guide](IOS_VS_WATCHOS.md)
2. **Test User Experience**: Follow [watchOS Guide](WATCHOS.md) for feature validation
3. **Submit to App Store**: Configure App Store Connect for watch app distribution

## 🔗 Related Documentation

- **[watchOS Guide](WATCHOS.md)** - Complete feature overview
- **[Platform Comparison](IOS_VS_WATCHOS.md)** - Technical differences
- **[Building Guide](../BUILDING.md)** - General build instructions
- **[Developer Guide](../DEVELOPER_GUIDE.md)** - Development best practices

---

*This integration guide ensures a smooth process for adding Apple Watch support to the Lizard physics simulation app while maintaining code quality and cross-platform compatibility.*