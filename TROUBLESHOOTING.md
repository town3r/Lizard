# 🔧 Troubleshooting Guide

## Quick Fixes

Before diving into specific issues, try these common solutions:

1. **Force close and reopen** the app
2. **Restart your device** (iPhone/iPad/Apple Watch)
3. **Check available storage** - ensure at least 100MB free space
4. **Update to latest iOS/watchOS** version
5. **Check internet connection** for Game Center features

---

## Performance Issues

### Low Frame Rate / Choppy Animation

#### Symptoms
- Lizards move jerkily or lag behind touch input
- FPS counter shows red/yellow warnings
- App feels unresponsive

#### Solutions
1. **Reduce concurrent lizards**:
   - Stop spawning and wait for existing lizards to disappear (10-second auto-cleanup)
   - Use the clear button (🗑️) to remove all lizards immediately

2. **Close background apps**:
   - Double-tap home button (older devices) or swipe up (newer devices)
   - Swipe up on apps to close them
   - Keep only essential apps running

3. **Disable weather effects** (if available):
   - Look for weather toggle in the interface
   - Switch to simplified background mode

4. **Device-specific optimizations**:
   - **iPhone 12 and newer**: Should handle 300 lizards smoothly
   - **iPhone X-11**: Optimal with 200-250 lizards
   - **iPhone 8 and older**: Best with 100-150 lizards
   - **Apple Watch**: Automatically limited to 20 lizards

5. **Storage cleanup**:
   - Delete unused apps and photos
   - Clear browser cache and downloads
   - Aim for at least 1GB free space for optimal performance

### App Crashes or Freezes

#### Symptoms
- App suddenly closes to home screen
- Screen becomes unresponsive
- "Lizard not responding" system dialog

#### Solutions
1. **Immediate steps**:
   - Force close the app completely
   - Wait 10 seconds before reopening
   - If frozen, force restart device (hold power + volume down)

2. **Memory management**:
   - Close all other apps before playing
   - Restart device to clear memory
   - Check for iOS/watchOS updates

3. **Persistent crashes**:
   - Delete and reinstall the app (saves progress with Game Center)
   - Check device storage (need 100MB+ free)
   - Report crash logs if still occurring

---

## Motion & Tilt Control Issues

### Gravity Not Responding to Device Tilt

#### Symptoms
- Lizards always fall downward regardless of device orientation
- No response when tilting device left/right/up

#### Solutions
1. **Check motion permissions**:
   - Go to Settings > Privacy & Security > Motion & Fitness
   - Ensure "Lizard" is enabled
   - If not listed, the app may need reinstallation

2. **Calibrate motion sensors**:
   - Hold device flat and level
   - Restart the app to reset sensor baseline
   - Try gentle tilting motions to test responsiveness

3. **Physical obstructions**:
   - Remove phone case if very thick or contains metal
   - Clean around home button and device edges
   - Avoid magnetic mounts or metal surfaces

4. **Device-specific issues**:
   - **iPad**: Works best in portrait orientation initially
   - **iPhone 14 Pro**: May need slight delay for sensor activation
   - **Older devices**: Motion sensitivity may be reduced

### Erratic or Overly Sensitive Motion

#### Symptoms
- Gravity changes too rapidly or unpredictably
- Lizards seem to "bounce" between different gravity directions

#### Solutions
1. **Hold device steadily**:
   - Use both hands for control
   - Make smooth, deliberate tilting motions
   - Avoid sudden jerky movements

2. **Reset motion calibration**:
   - Close and reopen the app
   - Hold device level for 5 seconds before tilting
   - Try restarting device if issue persists

---

## Audio Problems

### No Sound Effects

#### Symptoms
- Visual feedback works but no audio
- Other apps have sound but Lizard is silent

#### Solutions
1. **Check device audio settings**:
   - Verify device volume is up (use volume buttons)
   - Try toggling silent/ring switch
   - Test with other audio apps

2. **App-specific audio**:
   - Force close and reopen Lizard
   - Check if device has "Do Not Disturb" enabled
   - Ensure "Allow Audio" in Control Center

3. **iOS-specific solutions**:
   - Go to Settings > Sounds & Haptics
   - Ensure "Change with Buttons" is enabled
   - Try connecting/disconnecting headphones

### Audio Delay or Stuttering

#### Symptoms
- Sound effects play but delayed from visual action
- Audio cuts in and out intermittently

#### Solutions
1. **Reduce audio load**:
   - Slow down lizard spawning to reduce concurrent audio
   - Close music/video apps that might conflict
   - Disable other audio alerts temporarily

2. **Device optimization**:
   - Restart device to clear audio cache
   - Close background apps using audio
   - Check for iOS updates

---

## Game Center Issues

### Cannot Sign In to Game Center

#### Symptoms
- "Game Center unavailable" message
- Achievements/leaderboards not loading
- Sign-in dialog appears repeatedly

#### Solutions
1. **Check Game Center settings**:
   - Go to Settings > Game Center
   - Ensure you're signed in with Apple ID
   - Toggle Game Center off and on if needed

2. **Network connectivity**:
   - Ensure stable internet connection
   - Try both Wi-Fi and cellular data
   - Check if other online apps work

3. **Account issues**:
   - Sign out and back in to Game Center
   - Restart device after sign-in changes
   - Contact Apple Support for persistent account issues

### Achievements Not Unlocking

#### Symptoms
- Reached achievement requirements but no unlock notification
- Progress not showing in Game Center app

#### Solutions
1. **Force sync**:
   - Open Game Center app separately
   - Return to Lizard and trigger achievement again
   - Check internet connection during achievement moments

2. **Achievement timing**:
   - Some achievements may take 24-48 hours to appear
   - Try spawning a few more lizards beyond the threshold
   - Restart app after reaching milestones

### Leaderboard Scores Not Updating

#### Symptoms
- Personal high scores not reflected on leaderboards
- Cannot see friends' scores

#### Solutions
1. **Manual refresh**:
   - Pull down on leaderboard to refresh
   - Close and reopen Game Center section
   - Verify internet connection

2. **Score verification**:
   - Continue playing to trigger new score submissions
   - Check if local scores match what should be submitted
   - Wait up to 24 hours for leaderboard updates

---

## Apple Watch Specific Issues

### Watch App Won't Install

#### Symptoms
- App appears on iPhone but not on watch
- "Installing" message persists indefinitely
- Watch app icon missing from app grid

#### Solutions
1. **Installation process**:
   - Open Apple Watch app on iPhone
   - Go to "Available Apps" section
   - Find Lizard and tap "Install"
   - Keep iPhone and watch close during installation

2. **Watch storage**:
   - Check watch storage in Settings > General > Usage
   - Delete unused watch apps to free space
   - Need at least 50MB free for installation

3. **Connectivity issues**:
   - Ensure watch is connected to iPhone
   - Check Bluetooth connection
   - Try restarting both devices

### Watch App Performance Issues

#### Symptoms
- Lizards move very slowly on watch
- Unresponsive to touch input
- App crashes frequently on watch

#### Solutions
1. **Memory management**:
   - Close other watch apps before playing
   - Restart Apple Watch periodically
   - Avoid playing while other intensive apps are running

2. **Optimization**:
   - The watch version is limited to 20 lizards for performance
   - Clear existing lizards before spawning new ones
   - Use gentle touches rather than aggressive tapping

### Watch/iPhone Sync Issues

#### Symptoms
- Scores don't match between devices
- Different achievement progress on each platform

#### Solutions
1. **Sync manually**:
   - Open Game Center on both devices
   - Wait for both to connect to internet
   - Trigger achievements on the device you prefer

2. **Account verification**:
   - Ensure both devices signed in to same Apple ID
   - Check Game Center settings on both devices
   - Sign out and back in if sync is broken

---

## Building & Development Issues

### Xcode Build Failures

#### Symptoms
- Compilation errors when building from source
- Missing dependencies or frameworks
- "Target not found" errors

#### Solutions
1. **Prerequisites check**:
   - Ensure Xcode 15.0+ is installed
   - Verify macOS version compatibility
   - Check Apple Developer account status

2. **Clean build**:
   - Product > Clean Build Folder in Xcode
   - Delete derived data folder
   - Restart Xcode and rebuild

3. **Target configuration**:
   - Verify all targets are properly configured
   - Check deployment target settings (iOS 18.0+, watchOS 9.0+)
   - See [BUILDING.md](BUILDING.md) for detailed instructions

### Test Failures

#### Symptoms
- Unit tests fail during build process
- Simulator issues during testing
- "Unable to run tests" errors

#### Solutions
1. **Simulator setup**:
   - Ensure iOS 18.0+ simulator is installed
   - Try different simulator devices
   - Reset simulator content and settings

2. **Test environment**:
   - Close other Xcode projects
   - Ensure adequate disk space for testing
   - Check [BUILDING.md](BUILDING.md) for test requirements

---

## Advanced Diagnostics

### Getting Debug Information

For persistent issues, gather this information:

1. **Device Information**:
   - Device model (iPhone 12, Apple Watch Series 7, etc.)
   - iOS/watchOS version
   - Available storage space
   - Other installed apps that might conflict

2. **App State**:
   - When the issue occurs (startup, gameplay, specific actions)
   - Recent changes (iOS updates, new apps installed)
   - Frequency (always, sometimes, rarely)

3. **Console Logs** (for developers):
   - Connect device to Mac
   - Open Console.app
   - Filter for "Lizard" messages
   - Capture logs during issue reproduction

### Performance Monitoring

Enable debug information:

1. **FPS Counter**: Visible in debug builds automatically
2. **Memory Usage**: Monitor in Xcode Instruments
3. **Physics Objects**: Count visible in debug mode
4. **Audio Pool**: Check sound effect management

---

## Reporting Issues

If issues persist after trying these solutions:

### For General Users
1. **TestFlight Users**: Take a screenshot to trigger feedback composer
2. **App Store Users**: Leave detailed review with device information
3. **GitHub**: Submit issue with reproduction steps and logs

### For Developers
1. **Include Environment**: Xcode version, macOS version, device specs
2. **Reproduction Steps**: Exact steps to reproduce the issue
3. **Logs**: Console output, crash reports, performance data
4. **Expected vs Actual**: What should happen vs what actually happens

### Information to Include
- Device model and OS version
- App version and build number
- Exact steps to reproduce the issue
- Screenshots or screen recordings
- Whether issue occurs on multiple devices
- Recent changes to device or app

---

## Emergency Contacts

### Critical Issues
- **App Store**: Report through App Store Connect if app is broken for all users
- **TestFlight**: Use screenshot feedback for beta-specific issues
- **Apple Developer**: Technical support for development issues

### Community Support
- **GitHub Issues**: For technical problems and feature requests
- **Game Center**: Connect with other players for gameplay tips
- **Documentation**: Check [FAQ.md](FAQ.md) and [USER_GUIDE.md](USER_GUIDE.md)

---

*This troubleshooting guide is regularly updated based on user feedback and known issues. Last updated: Version 1.1.0 🦎*