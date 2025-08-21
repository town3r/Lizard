# Lizard watchOS Version

A simplified version of the Lizard physics simulation app designed specifically for Apple Watch.

## Features

### Core Functionality
- **Simple Lizard Spawning**: Tap the central lizard button to spawn animated lizards
- **Score Tracking**: Tracks total lizards spawned and button taps
- **Persistent Storage**: Scores saved using @AppStorage
- **GameCenter Integration**: Basic leaderboards and achievements
- **Haptic Feedback**: Uses WKInterfaceDevice for tactile feedback
- **Sound Effects**: Optional audio feedback (when available)

### Simplified for watchOS
- **No Complex Physics**: Uses SwiftUI animations instead of SpriteKit
- **Limited Lizards**: Maximum 20 simultaneous lizards for performance
- **Basic UI**: Clean, simple interface optimized for small screens
- **Reduced Features**: No rain mode, tilt controls, or complex UI effects
- **Optimized Performance**: Lighter weight implementation for watch hardware

## Technical Implementation

### Architecture
- **SwiftUI-based**: Native watchOS SwiftUI implementation
- **No SpriteKit**: Simple animation-based lizard movement
- **Minimal Dependencies**: Only uses essential watchOS frameworks
- **Efficient Memory Usage**: Automatic cleanup of old animations

### Key Differences from iOS Version
- Replaces SpriteKit physics with basic SwiftUI position animations
- Uses WKInterfaceDevice for haptic feedback instead of complex audio
- Simplified GameCenter integration with fewer achievements
- No liquid glass UI effects - uses standard watchOS materials
- No device motion/tilt controls
- No complex background effects

### Components
- `LizardWatchApp.swift` - Main app entry point
- `ContentView.swift` - Main interface with lizard spawning
- `WatchSoundPlayer.swift` - Simplified audio playback
- `WatchGameCenterManager.swift` - Basic GameCenter integration

### Configuration
- Maximum 20 simultaneous animated lizards
- 2-second animation duration per lizard
- 80pt spawn button size
- 30pt lizard emoji size
- 0.1-second rate limiting for interactions

## Usage

1. **Spawn Lizards**: Tap the central lizard emoji button
2. **View Stats**: See spawned count and tap count at the top
3. **GameCenter**: Automatic score reporting (when authenticated)
4. **Achievements**: Unlock achievements at 50 and 100 spawns/taps

## Performance

The watchOS version is optimized for the limited resources of Apple Watch:
- Automatic cleanup of old animations
- Limited concurrent lizards
- Efficient SwiftUI-based rendering
- Minimal memory footprint
- Rate-limited interactions to prevent performance issues

## Requirements

- watchOS 9.0+
- Apple Watch Series 3 or later recommended
- GameCenter account (optional, for social features)