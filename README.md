# 🦎 Lizard

A delightful physics simulation game where you spawn adorable lizard emojis that interact with realistic physics, gravity, and device motion.

Available for **iOS** and **Apple Watch** with platform-optimized experiences.

![Lizard App](Lizard/lizard.png)

## 📱 Platform Support

### iOS Version
Full-featured physics simulation with advanced graphics and controls.

### ⌚ Apple Watch Version  
Simplified companion app optimized for quick interactions and watch hardware.
See [watchOS documentation](docs/WATCHOS.md) for details.

## ✨ Features

### 🎮 Core Gameplay
- **Physics Simulation**: Realistic physics using SpriteKit with gravity and collision detection
- **Lizard Spawning**: Tap the main button to spawn individual lizards with random velocities
- **Rain Mode**: Hold the rain button to continuously spawn multiple lizards
- **Tilt Controls**: Use device motion to control gravity direction

### 🌅 Visual Experience  
- **Dynamic Weather Backgrounds**: Enhanced time-of-day reactive backgrounds with dynamic weather effects
  - Real-time weather conditions with animated sky transitions
  - Moving clouds with dynamic opacity and layering
  - Animated sun with rays and position tracking
  - Rain effects with realistic screen raindrops
  - Enhanced sunrise/sunset transitions
  - Stars and moon at night with weather interaction
- **Weather Control System**: Manual weather control with auto/manual mode toggle
- **Liquid Glass UI**: Modern, translucent button styling with depth effects
- **Smooth Animations**: 120 FPS performance optimization

### 🎵 Audio & Feedback
- **Sound Effects**: Audio feedback for lizard spawning
- **Silent Mode Support**: Audio works even when device is in silent mode
- **Haptic Feedback**: Responsive touch interactions

### 🏆 Game Center Integration
- **Leaderboards**: 
  - Total Lizards Spawned
  - Button Taps Counter
- **Achievements**:
  - First 100 lizards spawned
  - First 500 lizards spawned  
  - 100 button taps milestone
- **Access Point**: Floating Game Center trophy icon

### 🧪 Beta Features
- **Screenshot Feedback**: Take a screenshot during TestFlight to automatically open feedback composer
- **Performance Monitoring**: Automatic FPS tracking and optimization

## 🎯 How to Play

1. **Spawn Lizards**: Tap the large center button (🦎) to spawn a single lizard
2. **Rain Mode**: Hold the rain button (🌧️) to continuously spawn lizards
3. **Tilt Control**: Tilt your device to change gravity direction and watch lizards move
4. **Stop/Clear**: Use the stop button (🛑) to pause or trash button (🗑️) to clear all lizards
5. **Game Center**: Track your progress and compete on leaderboards

## 🔧 Controls

| Control | Action |
|---------|--------|
| Center Button Tap | Spawn single lizard |
| Center Button Hold | Continuous spawning |
| Rain Button Tap | Spawn burst of lizards |
| Rain Button Hold | Continuous rain mode |
| Stop Button | Pause physics aging |
| Clear Button | Remove all lizards |
| Device Tilt | Control gravity direction |

## 📱 Requirements

- iOS 18.0+
- Device with accelerometer/gyroscope for tilt controls
- Game Center account (optional, for leaderboards and achievements)

## 🏗️ Technical Details

- **Framework**: SwiftUI + SpriteKit
- **Physics**: Custom physics simulation with performance optimization
- **Audio**: AVFoundation with multi-voice sound pooling
- **Motion**: CoreMotion for device orientation and gravity
- **Persistence**: UserDefaults for score tracking
- **Performance**: Automatic lizard lifecycle management (10-second lifespan)

## 🎨 Architecture

- `LizardApp.swift` - Main app entry point and lifecycle management
- `ContentView.swift` - Primary game UI and controls
- `LizardScene.swift` - SpriteKit physics simulation scene
- `GameCenterManager.swift` - Game Center integration and leaderboards
- `DynamicBackgroundView.swift` - Time-based background rendering
- `SoundPlayer.swift` - Audio management and pooling
- `BetaFeedbackManager.swift` - TestFlight feedback system

## 🚀 Getting Started

### Quick Start for Users
1. **Download**: Get Lizard from the App Store (iPhone and Apple Watch)
2. **Launch**: Open the app and grant motion permissions for tilt controls
3. **Play**: Tap the center button to spawn lizards, tilt device to control gravity
4. **Explore**: Try rain mode, Game Center achievements, and weather effects

### For Developers
See our comprehensive [**Developer Guide**](DEVELOPER_GUIDE.md) for detailed setup instructions.

#### Quick Build
```bash
# Clone and build
git clone https://github.com/town3r/Lizard.git
cd Lizard
open Lizard.xcodeproj

# Build all targets (⌘+B)
# Run tests (⌘+U)
# Run on simulator (⌘+R)
```

#### Requirements
- **macOS 14.0+** with **Xcode 15.0+**
- **iOS 18.0+ SDK** and **watchOS 9.0+ SDK**
- **Apple Developer Account** (for device testing)

## 📚 Documentation

### User Documentation
- **[User Guide](USER_GUIDE.md)** - Complete gameplay and features guide
- **[FAQ](FAQ.md)** - Frequently asked questions and quick answers
- **[Troubleshooting](TROUBLESHOOTING.md)** - Detailed problem-solving guide
- **[Controls Reference](CONTROLS.md)** - Complete control documentation

### Developer Documentation  
- **[Developer Guide](DEVELOPER_GUIDE.md)** - Architecture, setup, and best practices
- **[API Reference](API_REFERENCE.md)** - Complete code documentation
- **[Building Guide](BUILDING.md)** - Build instructions and requirements
- **[Technical Details](TECHNICAL.md)** - Implementation architecture
- **[Contributing Guide](CONTRIBUTING.md)** - How to contribute to the project

### Specialized Guides
- **[Game Center Setup](docs/GAME_CENTER.md)** - Achievements and leaderboards
- **[watchOS Guide](docs/WATCHOS.md)** - Apple Watch companion app
- **[Design System](docs/DESIGN_SYSTEM.md)** - UI components and styling
- **[Documentation Hub](docs/README.md)** - Complete documentation index and navigation

## 🛡️ Security & Privacy

We take your privacy seriously:
- **No Data Collection**: All game data stays on your device
- **Privacy by Design**: Only essential permissions requested
- **Open Source**: Code available for security review
- **Responsible Disclosure**: See our [Security Policy](SECURITY.md)

## 🔄 Release Notes

**Current Version**: 1.1.0 - "Weather & Watch"
- Complete Apple Watch companion app
- Dynamic weather system with real-time effects
- Enhanced performance and build system improvements

See [**CHANGELOG.md**](CHANGELOG.md) for complete release history.

## 🤝 Contributing

We welcome contributions from the community! Here's how to get involved:

### Quick Contribution Guide
1. **Read**: [Contributing Guidelines](CONTRIBUTING.md)
2. **Setup**: Follow [Developer Guide](DEVELOPER_GUIDE.md)  
3. **Find Issues**: Look for `good first issue` labels
4. **Submit**: Create pull request with tests and documentation

### Types of Contributions
- 🐛 **Bug Reports**: Help us identify and fix issues
- ✨ **Feature Requests**: Suggest new gameplay elements
- 📝 **Documentation**: Improve guides and examples
- 🔧 **Code**: Bug fixes and performance improvements
- 🧪 **Testing**: Device testing and quality assurance

### Community Guidelines
- Be respectful and constructive
- Follow our [Code of Conduct](CONTRIBUTING.md#code-of-conduct)
- Search existing issues before creating new ones
- Provide clear reproduction steps for bugs

## 📞 Support & Community

### Getting Help
- **[FAQ](FAQ.md)** - Quick answers to common questions
- **[Troubleshooting](TROUBLESHOOTING.md)** - Detailed problem solving
- **GitHub Issues** - Technical problems and bug reports
- **GitHub Discussions** - Questions and feature ideas

### Beta Testing
Join our TestFlight beta for early access to new features:
- **Screenshot Feedback**: Take screenshots to send feedback
- **Performance Testing**: Help us optimize across devices  
- **Feature Preview**: Try new features before public release

### Stay Updated
- **GitHub Releases** - New version announcements
- **CHANGELOG.md** - Detailed release notes
- **GitHub Watch** - Get notified of project updates

## 📄 License

This project is open source. License details coming soon.

## 🙏 Acknowledgments

### Special Thanks
- **Apple Developer Community** - For SwiftUI and watchOS guidance
- **TestFlight Beta Testers** - Essential feedback for improvements
- **SpriteKit Community** - Physics simulation techniques
- **Contributors** - Everyone who helps make Lizard better

### Built With
- **[SwiftUI](https://developer.apple.com/xcode/swiftui/)** - Modern UI framework
- **[SpriteKit](https://developer.apple.com/spritekit/)** - 2D game engine and physics
- **[Game Center](https://developer.apple.com/game-center/)** - Social gaming features
- **[Core Motion](https://developer.apple.com/documentation/coremotion)** - Device motion sensing

---

*Made with ❤️ for physics simulation enthusiasts*

**Ready to spawn some lizards?** Download Lizard today and experience delightful physics simulation on iOS and Apple Watch! 🦎✨