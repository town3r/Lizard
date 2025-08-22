# ⌚ Lizard for Apple Watch

The Lizard Apple Watch companion app brings the delightful physics simulation to your wrist with a native watchOS experience optimized for quick interactions and Apple Watch hardware.

## 🎮 watchOS Features

### Core Gameplay
- **Simplified Lizard Spawning**: Tap the central button to spawn animated lizards
- **SwiftUI Animations**: Smooth, native lizard animations optimized for watchOS
- **Performance Optimized**: Limited to 20 concurrent lizards for optimal watch performance  
- **Haptic Feedback**: Rich tactile feedback using WKInterfaceDevice
- **Audio Support**: Optional sound effects that respect watch audio settings

### User Interface
- **Native watchOS Design**: SwiftUI-based interface designed specifically for small screens
- **Rate Limiting**: Built-in spam prevention for smooth interactions
- **Accessibility**: VoiceOver support and large touch targets

### Cross-Platform Features
- **Score Synchronization**: Achievements and scores sync with iOS app via @AppStorage
- **Independent Operation**: Works standalone without requiring iPhone app to be running
- **GameCenter Integration**: Platform-specific achievements and leaderboards

## 🏗️ Technical Architecture

### Performance Characteristics
- **Maximum Lizards**: 20 concurrent animated lizards (vs 300 on iOS)
- **Lizard Size**: 30pt (vs 80pt on iOS) 
- **Animation Duration**: 2.0 seconds per lizard lifecycle
- **Spawn Button**: 80pt touch target optimized for Apple Watch

### Framework Dependencies
- **SwiftUI**: Native UI framework (no SpriteKit dependency)
- **WatchKit**: For haptic feedback and device integration
- **GameKit**: For GameCenter features
- **AVFoundation**: For audio playback

### Code Architecture
- **Independent Codebase**: No shared physics engine with iOS version
- **Lightweight**: Minimal memory footprint and CPU usage
- **Battery Efficient**: Optimized animations and reduced background processing

## 🎯 Gameplay Experience

### Controls
- **Single Tap**: Spawn a lizard with random animation
- **Haptic Feedback**: Gentle tap feedback on successful spawn
- **Audio Feedback**: Optional sound effect (respects watch audio settings)

### Visual Design
- **Lizard Animations**: Smooth SwiftUI-based bouncing and scaling effects
- **Minimalist UI**: Clean, uncluttered interface optimized for watch screens
- **High Contrast**: Excellent visibility in various lighting conditions

### Performance Features
- **Automatic Cleanup**: Lizards automatically disappear to maintain performance
- **Rate Limiting**: Prevents interaction spam that could impact performance
- **Memory Management**: Efficient cleanup of animation objects

## 📱 Comparison with iOS Version

| Feature | iOS Version | watchOS Version |
|---------|-------------|-----------------|
| **Physics Engine** | SpriteKit with realistic physics | SwiftUI animations |
| **Max Lizards** | 300 simultaneous | 20 simultaneous |
| **Controls** | Tap, rain mode, device tilt | Single tap only |
| **Graphics** | Advanced particle effects | Smooth SwiftUI animations |
| **Audio** | Multiple sound effects | Single spawn sound |
| **Background** | Dynamic weather system | Solid color background |
| **Haptics** | Basic touch feedback | Rich watch haptics |

## 🔧 Development Notes

### Requirements
- **watchOS 9.0+**: Minimum supported version
- **Apple Watch Series 4+**: Recommended for optimal performance
- **Xcode 15.0+**: Required for building

### Configuration
- **AppConfiguration.WatchOS**: Centralized settings in `AppConfiguration.swift`
- **Bundle ID**: `com.town3r.lizard.watchapp`
- **GameCenter**: Separate watchOS leaderboards and achievements

### Testing
- **watchOS Simulator**: Primary testing environment
- **Device Testing**: Required for haptic feedback validation
- **Performance Testing**: Memory and battery usage monitoring

## 🚀 Getting Started

### For Users
1. Install the iOS Lizard app from the App Store
2. Open the Watch app on your iPhone
3. Find Lizard in the app list and install to your watch
4. Launch Lizard on your Apple Watch and start spawning lizards!

### For Developers
1. See [watchOS Integration Guide](WATCHOS_INTEGRATION.md) for adding watchOS support
2. Review [Platform Comparison](IOS_VS_WATCHOS.md) for technical differences
3. Check [Building Guide](../BUILDING.md) for build instructions

## 📖 Related Documentation

- **[watchOS Integration Guide](WATCHOS_INTEGRATION.md)** - Adding watchOS to existing projects
- **[Platform Comparison](IOS_VS_WATCHOS.md)** - Detailed iOS vs watchOS differences  
- **[Building Guide](../BUILDING.md)** - Build instructions for all platforms
- **[Technical Architecture](../TECHNICAL.md)** - Implementation details

---

*The watchOS version represents a thoughtful adaptation of the Lizard experience for Apple Watch, prioritizing performance, battery life, and the unique interaction patterns of wearable devices.*