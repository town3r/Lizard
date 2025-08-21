# Lizard for Apple Watch 🦎⌚

A simplified companion version of the Lizard physics simulation app, designed specifically for Apple Watch.

## Quick Start

1. **Tap the Lizard**: Press the central lizard emoji to spawn animated lizards
2. **Watch Them Move**: Lizards animate from center to random positions
3. **Track Your Score**: View total spawned and button taps at the top
4. **Earn Achievements**: Unlock GameCenter achievements as you progress

## Features

### ✨ Core Gameplay
- **One-Tap Spawning**: Simple tap interaction optimized for Apple Watch
- **Smooth Animations**: SwiftUI-based lizard movement animations
- **Score Persistence**: Your progress is automatically saved
- **Haptic Feedback**: Satisfying tactile feedback with each tap

### 🏆 GameCenter Integration
- **Leaderboards**: Compete globally on total spawned and button taps
- **Achievements**: 
  - 🥉 First 50 lizards spawned
  - 🥈 First 100 lizards spawned  
  - 🥇 50 button taps milestone

### ⚡ Performance Optimized
- **Efficient Animations**: Automatic cleanup prevents memory issues
- **Limited Concurrent Lizards**: Maximum 20 for smooth performance
- **Battery Friendly**: Minimal resource usage

## Technical Specs

- **Minimum**: watchOS 9.0+
- **Recommended**: Apple Watch Series 3 or later
- **Storage**: < 5MB app size
- **Memory**: Optimized for watch constraints

## Simplified from iOS Version

This watchOS version focuses on the core fun of lizard spawning while removing complex features:

| Feature | iOS Version | watchOS Version |
|---------|-------------|-----------------|
| Physics Engine | SpriteKit complex physics | SwiftUI animations |
| UI Design | Liquid glass effects | Native watchOS materials |
| Controls | Multi-button, rain mode, tilt | Single tap button |
| Background | Dynamic day/night cycle | Simple gradient |
| Audio | Multi-voice sound system | Basic haptic + optional sound |
| Max Lizards | 300 simultaneous | 20 for performance |

## Privacy & Data

- **Local Storage Only**: Scores stored on device via @AppStorage
- **GameCenter Optional**: Social features require GameCenter sign-in
- **No Analytics**: No usage tracking or data collection
- **No Network**: Works completely offline (except GameCenter)