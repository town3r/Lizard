# 🍎 watchOS Integration Guide

This guide provides step-by-step instructions for integrating the existing watchOS app code into the main Lizard Xcode project.

## Overview

The repository contains a complete watchOS implementation that needs to be properly integrated as watchOS targets in the main Xcode project.

### Current Structure
```
Lizard/
├── Lizard/                     # Main iOS app (✅ integrated)
├── LizardTests/               # iOS tests (❌ needs target)
├── LizardWatch WatchKit App/  # watchOS app code (❌ needs target)  
└── LizardWatchTests/         # watchOS tests (❌ needs target)
```

### Target Structure (After Integration)
```
Lizard.xcodeproj targets:
├── Lizard (iOS App)           # ✅ Already exists
├── LizardTests (iOS Tests)    # ⚠️ Needs to be added
├── LizardWatch (watchOS App)  # ⚠️ Needs to be added
└── LizardWatchTests (watchOS Tests) # ⚠️ Needs to be added
```

## Prerequisites

- **macOS with Xcode 15.0+** (watchOS integration requires Xcode)
- **Apple Developer Account** (for watchOS development)
- **watchOS 9.0+ SDK** (included with Xcode)

## Step-by-Step Integration

### Step 1: Add iOS Test Target

1. Open `Lizard.xcodeproj` in Xcode
2. Select the project in the navigator
3. Click the **"+"** button at the bottom of the targets list
4. Choose **iOS** → **Unit Testing Bundle**
5. Configure the target:
   - **Product Name**: `LizardTests`
   - **Bundle Identifier**: `com.town3r.lizard.tests`
   - **Target to be Tested**: `Lizard`
   - **Language**: Swift
6. Delete the auto-generated test file
7. **Add Existing Files**:
   - Right-click on `LizardTests` target
   - Add → Existing Files
   - Select `LizardTests/LizardTests.swift`
   - Ensure it's added to the `LizardTests` target

### Step 2: Add watchOS App Target

1. In the same Xcode project, click **"+"** to add another target
2. Choose **watchOS** → **App**
3. Configure the watchOS app target:
   - **Product Name**: `LizardWatch`
   - **Bundle Identifier**: `com.town3r.lizard.watchkitapp`
   - **Language**: Swift
   - **Interface**: SwiftUI
   - **Include Notification Scene**: No
4. Xcode will create default watchOS files - **delete them all**
5. **Add Existing watchOS Files**:
   - Right-click on `LizardWatch` target folder
   - Add → Existing Files
   - Select all files from `LizardWatch WatchKit App/`:
     - `LizardWatchApp.swift`
     - `ContentView.swift`
     - `WatchGameCenterManager.swift`
     - `WatchSoundPlayer.swift`
     - `Assets.xcassets`
     - `Info.plist`
     - `LizardWatch.entitlements`
     - `lizard.wav`
   - Ensure all files are added to the `LizardWatch` target only

### Step 3: Add watchOS Test Target

1. Click **"+"** to add another target
2. Choose **watchOS** → **Unit Testing Bundle**
3. Configure the test target:
   - **Product Name**: `LizardWatchTests`
   - **Bundle Identifier**: `com.town3r.lizard.watchkitapp.tests`
   - **Target to be Tested**: `LizardWatch`
4. Delete the auto-generated test file
5. **Add Existing Test Files**:
   - Add `LizardWatchTests/LizardWatchTests.swift` to this target

### Step 4: Configure Bundle Identifiers

Update the bundle identifiers for proper App Store compliance:

1. **Main iOS App** (`Lizard` target):
   - Bundle Identifier: `com.town3r.lizard`
   
2. **iOS Tests** (`LizardTests` target):
   - Bundle Identifier: `com.town3r.lizard.tests`
   
3. **watchOS App** (`LizardWatch` target):
   - Bundle Identifier: `com.town3r.lizard.watchkitapp`
   
4. **watchOS Tests** (`LizardWatchTests` target):
   - Bundle Identifier: `com.town3r.lizard.watchkitapp.tests`

### Step 5: Configure Deployment Targets

Set appropriate deployment targets:

1. **iOS targets**: iOS 18.0+ (already configured)
2. **watchOS targets**: watchOS 9.0+

For each watchOS target:
- Select target → Build Settings
- Set **watchOS Deployment Target** to `9.0`

### Step 6: Configure Dependencies

1. **iOS App → watchOS App dependency**:
   - Select `Lizard` (iOS) target
   - Build Phases → Dependencies
   - Add `LizardWatch` target

2. **Verify Schemes**:
   - Ensure each target has its own scheme
   - Test that all schemes build successfully

### Step 7: Configure Entitlements

1. **watchOS App Entitlements**:
   - Target Settings → Signing & Capabilities
   - Add **Game Center** capability
   - Verify `LizardWatch.entitlements` is properly linked

2. **iOS App Entitlements** (if needed):
   - Ensure iOS app has proper entitlements for watch communication

### Step 8: Update Info.plist Settings

**watchOS App Info.plist** should include:
```xml
<key>WKWatchOnly</key>
<true/>
<key>CFBundleDisplayName</key>
<string>Lizard</string>
```

### Step 9: Test Integration

1. **Build All Targets**:
   ```bash
   # Clean build
   xcodebuild clean -project Lizard.xcodeproj
   
   # Build iOS app
   xcodebuild -project Lizard.xcodeproj -scheme Lizard -configuration Debug
   
   # Build watchOS app  
   xcodebuild -project Lizard.xcodeproj -scheme LizardWatch -configuration Debug
   ```

2. **Run Tests**:
   ```bash
   # iOS tests
   xcodebuild test -project Lizard.xcodeproj -scheme Lizard -destination 'platform=iOS Simulator,name=iPhone 15'
   
   # watchOS tests
   xcodebuild test -project Lizard.xcodeproj -scheme LizardWatch -destination 'platform=watchOS Simulator,name=Apple Watch Series 9 (45mm)'
   ```

3. **Simulator Testing**:
   - Run iOS app in iPhone Simulator
   - Run watchOS app in Watch Simulator  
   - Verify both apps function independently

## Troubleshooting

### Common Issues

**"Target not found" errors**:
- Verify bundle identifiers are unique
- Check that watchOS deployment target is set correctly
- Ensure files are added to correct targets

**Build failures**:
- Clean derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`
- Verify all source files are in correct target membership
- Check for any missing frameworks in watchOS targets

**Signing issues**:
- Ensure Apple Developer account is configured
- Check that bundle identifiers match provisioning profiles
- Verify watchOS development certificates are installed

### Verification Steps

After integration, verify:
- [ ] All 4 targets build successfully
- [ ] iOS app runs in iPhone Simulator
- [ ] watchOS app runs in Watch Simulator
- [ ] All tests pass
- [ ] No duplicate files or target membership issues
- [ ] Proper bundle identifier hierarchy

## Expected Results

After successful integration:
- **Project Structure**: 4 distinct targets (iOS app, iOS tests, watchOS app, watchOS tests)
- **Independent Apps**: iOS and watchOS apps function as separate, standalone applications
- **GameCenter Integration**: Both apps have their own GameCenter configurations
- **Testing**: Comprehensive test coverage for both platforms
- **App Store Ready**: Proper bundle identifiers and configuration for distribution

## Post-Integration Tasks

1. **Update Documentation**:
   - Update `BUILDING.md` with watchOS build instructions
   - Update `README.md` to mention watchOS support

2. **CI/CD Updates** (if applicable):
   - Add watchOS build steps to automation
   - Include watchOS testing in CI pipeline

3. **Distribution Preparation**:
   - Configure App Store Connect for watchOS app
   - Set up proper App Store screenshots and metadata

---

*This integration creates a unified project with both iOS and watchOS support while maintaining the distinct characteristics of each platform! 🦎⌚*