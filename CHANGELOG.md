# Changelog

All notable changes to the Lizard iOS app will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Additional weather effects and animations
- Enhanced watchOS complications support
- Advanced physics customization options

## [1.1.0] - 2025-08-19

### 🚀 Major Feature Update - "Weather & Watch"

This release introduces significant new features including a complete watchOS companion app, dynamic weather system, and major build system improvements.

### Added

#### 📱 watchOS Companion App
- **Complete Apple Watch App**: Fully functional companion app with native watchOS implementation
  - SwiftUI-based interface optimized for small screens
  - Simplified lizard spawning with smooth animations
  - Haptic feedback integration using WKInterfaceDevice
  - Audio feedback with optional sound effects
  - Performance optimized with 20 concurrent lizard limit
  - Rate limiting to prevent interaction spam
- **watchOS GameCenter Integration**: Platform-specific achievements and leaderboards
- **Cross-Platform Persistence**: Scores sync between iOS and watchOS using @AppStorage
- **Independent Architecture**: No SpriteKit dependency, pure SwiftUI animations

#### 🌤️ Dynamic Weather System
- **Real-time Weather Backgrounds**: Enhanced time-of-day reactive backgrounds with dynamic weather effects
  - Animated sky that shifts throughout the day with weather conditions
  - Moving clouds with dynamic opacity and layering
  - Animated sun with rays and position tracking
  - Rain effects with realistic screen raindrops
  - Enhanced sunrise/sunset transitions
  - Stars and moon at night with weather interaction
  - Layered grassy hills with weather shadows
- **Weather Control Interface**: Manual weather control system with auto/manual mode toggle
- **Weather Persistence**: Weather condition storage using custom property wrapper
- **Performance Optimized**: Efficient rendering with minimal impact on gameplay FPS

#### 🏗️ Architecture Enhancements
- **Centralized Configuration**: New `AppConfiguration.swift` system consolidating scattered configs
  - Physics constants (gravity, lizard limits, performance thresholds)
  - UI layout settings (button sizes, animation durations)
  - Performance monitoring configuration
  - Audio system settings
- **Enhanced UI Components**: New specialized UI helpers and transparent effects
- **Improved Component Organization**: Better separation of concerns and modularity
- **Beta Feedback Enhancements**: Improved screenshot-to-feedback system with mail composer integration

#### 📚 Comprehensive Documentation Suite
- **Technical Architecture Documentation**: Detailed technical guides and API documentation
- **Build & Development Guide**: Complete build instructions and development workflow
- **Platform Comparison Guide**: iOS vs watchOS feature comparison and implementation details
- **Design System Documentation**: UI components, styling guidelines, and design patterns
- **GameCenter Integration Guide**: Achievement setup and leaderboard configuration
- **watchOS Integration Guide**: Step-by-step watchOS setup and configuration

### Fixed

#### 🔧 Major Build System Fixes
- **Invalid Deployment Target**: Fixed `IPHONEOS_DEPLOYMENT_TARGET` from invalid `26.0` to `18.0`
- **Missing Xcode Targets**: Added 3 missing targets that were causing 68+ build errors
  - `LizardTests` target for iOS unit testing bundle
  - `LizardWatch` target for watchOS app (watchOS 9.0+)
  - `LizardWatchTests` target for watchOS unit testing bundle
- **Target Integration**: Properly integrated all source files into Xcode build system
- **Cross-Platform Dependencies**: Resolved compilation errors between iOS and watchOS code
- **Duplicate Code Cleanup**: Removed conflicting watchOS template directories

#### 🐛 Code Quality Improvements
- **Compilation Errors**: Fixed watchOS references to iOS-only components
- **Build Configuration**: Proper bundle IDs and deployment targets for all platforms
- **Project Structure**: Cleaned up project organization and file references

### Changed

#### 📱 Platform Requirements Update
- **iOS**: Updated to require iOS 18.0+ (was iOS 15.0+)
- **watchOS**: New platform support with watchOS 9.0+ requirement
- **Enhanced Device Support**: Better support for modern iPhone and Apple Watch devices

#### 🎮 Enhanced Gameplay Experience
- **Improved Visual Effects**: More sophisticated background animations and weather integration
- **Better Performance Monitoring**: Enhanced FPS tracking with weather effects consideration
- **Refined UI Interactions**: Smoother button animations and feedback with liquid glass effects

### Technical Details

#### Build Targets
- **Lizard** (iOS): Main application targeting iOS 18.0+
- **LizardTests** (iOS): Unit tests with comprehensive coverage of core components  
- **LizardWatch** (watchOS): Companion app targeting watchOS 9.0+
- **LizardWatchTests** (watchOS): watchOS-specific unit tests

#### Performance Optimizations
- Weather system designed for minimal FPS impact
- watchOS app optimized for Apple Watch hardware constraints
- Enhanced memory management with automatic cleanup
- Improved physics simulation efficiency

#### Documentation Coverage
- Complete API documentation for all major components
- Platform-specific implementation guides
- Build and deployment instructions
- Troubleshooting and FAQ sections

## [1.0.0] - 2024-01-XX

### 🎉 Initial Release

The first public release of Lizard - a delightful iOS physics simulation game!

#### ✨ Core Features
- **Physics Simulation**: Realistic lizard emoji physics using SpriteKit
- **Interactive Spawning**: Tap or hold buttons to spawn lizards with random velocities
- **Tilt Controls**: Device motion controls gravity direction for immersive gameplay
- **Dynamic Backgrounds**: Beautiful day/night cycle that changes based on real-time
- **Audio Experience**: Sound effects with silent mode support

#### 🎮 Gameplay Elements
- Main spawn button with single tap and hold-to-spam modes
- Rain mode for burst spawning of multiple lizards
- Stop button to pause physics simulation
- Clear button to remove all active lizards
- Automatic lizard lifecycle management (10-second lifespan)

#### 🏆 Game Center Integration
- **Leaderboards**:
  - Total Lizards Spawned
  - Button Taps Counter
- **Achievements**:
  - "First Century" - Spawn 100 lizards
  - "Lizard Master" - Spawn 500 lizards  
  - "Button Masher" - Tap button 100 times
- Floating Game Center access point

#### 🎨 Visual Polish
- Liquid glass UI styling with modern translucent effects
- Starfield animation during nighttime hours
- 120 FPS performance optimization
- Smooth physics animations and particle effects

#### 🔧 Technical Features
- **Performance Monitoring**: Automatic FPS tracking and quality adjustment
- **Memory Management**: Intelligent cleanup of physics objects
- **Audio Pooling**: Multi-voice sound system for smooth audio
- **Beta Feedback**: Screenshot-to-feedback system for TestFlight users

#### 📱 Platform Support
- iOS 15.0+ compatibility
- Portrait orientation support 
- Optimized for iPhone devices
- Game Center account integration

#### 🏗️ Architecture Highlights
- SwiftUI + SpriteKit hybrid architecture
- CoreMotion integration for device orientation
- UserDefaults persistence for score tracking
- Modular component design for maintainability

### 🐛 Known Issues
- None reported in initial release

### 📋 Requirements
- iOS 15.0 or later
- Device with accelerometer/gyroscope for tilt functionality
- Game Center account (optional, for social features)

---

## Release Notes Template

For future releases, use this template:

## [X.X.X] - YYYY-MM-DD

### Added
- New features and capabilities

### Changed
- Changes to existing functionality

### Deprecated
- Features that will be removed in future versions

### Removed
- Features removed in this version

### Fixed
- Bug fixes and corrections

### Security
- Security-related changes

---

## Version History

| Version | Release Date | Key Features |
|---------|-------------|--------------|
| 1.1.0   | 2025-08-19  | watchOS companion app, dynamic weather system, build fixes |
| 1.0.0   | 2024-01-XX  | Initial release with core physics gameplay |

## Feedback

We love hearing from our users! 

- **TestFlight Users**: Take a screenshot to automatically open the feedback composer
- **App Store**: Leave a review to help other users discover Lizard
- **GitHub**: Open an issue for bug reports or feature requests

---

*Keep spawning those lizards! 🦎*