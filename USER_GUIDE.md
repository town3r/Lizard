# 📖 Lizard User Guide

Welcome to Lizard - the delightful physics simulation game that brings adorable lizard emojis to life on your iPhone and Apple Watch!

## Table of Contents

1. [Getting Started](#getting-started)
2. [Basic Gameplay](#basic-gameplay)
3. [Advanced Features](#advanced-features)
4. [Game Center Integration](#game-center-integration)
5. [Apple Watch Experience](#apple-watch-experience)
6. [Weather System](#weather-system)
7. [Performance & Settings](#performance--settings)
8. [Tips & Tricks](#tips--tricks)
9. [Accessibility Features](#accessibility-features)

---

## Getting Started

### First Launch

When you first open Lizard, you'll be greeted with:

1. **Motion Permission Request**: Allow motion access for tilt controls (recommended)
2. **Game Center Sign-In**: Optional but recommended for achievements and leaderboards
3. **Audio Setup**: The app configures itself to play sounds even in silent mode

### Main Interface

The main screen features:
- **Central Spawn Button (🦎)**: Large button for spawning lizards
- **Rain Button (🌧️)**: Top-left for continuous spawning
- **Stop Button (🛑)**: Top-right to pause physics aging
- **Clear Button (🗑️)**: Bottom-right to remove all lizards
- **Statistics Display**: Shows lizard count and button tap count
- **Game Center Trophy**: Floating icon for achievements and leaderboards
- **Background**: Dynamic time-based scenery with weather effects

---

## Basic Gameplay

### Spawning Lizards

#### Single Lizard Spawn
- **Tap** the center button (🦎) once
- A lizard appears at the button location with random velocity
- Each tap counts toward your statistics and achievements

#### Multiple Lizard Spawn
- **Hold** the center button (🦎) for continuous spawning
- **Tap** the rain button (🌧️) for a burst of lizards
- **Hold** the rain button (🌧️) for continuous rain mode

#### Spawn Behavior
- Lizards appear with random colors and slight size variations
- Initial velocity is randomized for natural movement
- Each lizard has realistic physics properties (mass, bounce, friction)

### Controlling Gravity

#### Tilt Controls
- **Tilt your device** in any direction to change gravity
- Lizards fall toward the direction you tilt
- Smooth tilting creates natural physics flow
- Sharp tilts create dramatic direction changes

#### Gravity Mechanics
- Gravity strength is realistic (Earth-like acceleration)
- Works in all orientations (portrait, landscape, upside-down)
- Real-time response to device motion
- Supports both subtle and dramatic tilt angles

### Managing Lizards

#### Automatic Cleanup
- Lizards automatically disappear after **10 seconds**
- This prevents screen clutter and maintains performance
- No action required - cleanup is seamless

#### Manual Control
- **Stop Button (🛑)**: Pauses aging timer, lizards persist longer
- **Clear Button (🗑️)**: Instantly removes all lizards from screen
- **Performance Limiting**: Maximum 300 lizards on iOS

---

## Advanced Features

### Physics Simulation

#### Realistic Behavior
- **Gravity**: Earth-like acceleration with device tilt control
- **Collisions**: Lizards bounce off screen edges naturally
- **Friction**: Gradual speed reduction for realistic movement
- **Mass**: Slight variations give each lizard unique physics

#### Performance Optimization
- **Frame Rate Monitoring**: Automatic quality adjustment
- **Memory Management**: Smart cleanup prevents slowdown
- **Object Pooling**: Efficient lizard creation and destruction
- **Adaptive Quality**: Reduces effects under performance pressure

### Audio System

#### Sound Effects
- **Spawn Sounds**: Audio feedback for each lizard creation
- **Silent Mode Compatible**: Plays even when device is muted
- **Rate Limiting**: Prevents audio spam during rapid spawning
- **Multi-Voice Pool**: Multiple simultaneous sounds without conflicts

#### Audio Controls
- **Device Volume**: Standard volume buttons control audio level
- **Silent Mode**: Works like games/media (bypasses silent switch)
- **Background Apps**: Doesn't interfere with music or other audio

### Visual Effects

#### Dynamic Backgrounds
- **Time-Based**: Changes throughout the day automatically
- **Weather Integration**: Rain, clouds, sun, moon, and stars
- **Smooth Transitions**: Gradual changes between conditions
- **Performance Aware**: Adjusts detail based on device capability

#### UI Animations
- **Liquid Glass**: Modern translucent button styling
- **Smooth Scaling**: Responsive button press feedback
- **Fade Effects**: Elegant lizard appearance and disappearance
- **60+ FPS**: Optimized for high refresh rate displays

---

## Game Center Integration

### Getting Started

#### Sign In Process
1. Ensure you're signed in to Game Center in Settings
2. Launch Lizard - it will automatically connect
3. Grant permission when prompted
4. Look for the floating trophy icon

#### Privacy
- Only game statistics are shared (no personal data)
- You control what friends can see in Game Center settings
- Achievements are personal unless you choose to share

### Achievements

#### Available Achievements
1. **"First Century"** - Spawn 100 total lizards
2. **"Lizard Master"** - Spawn 500 total lizards
3. **"Button Masher"** - Tap the main button 100 times

#### Achievement Tips
- Progress tracks across all app sessions
- Both buttons (🦎 and 🌧️) count toward totals
- Achievements unlock with celebration animations
- View progress in the Game Center app

### Leaderboards

#### Available Leaderboards
1. **Total Lizards Spawned** - Lifetime lizard count across all sessions
2. **Button Taps** - Total main button interactions

#### Competing
- Scores update automatically during gameplay
- View rankings by tapping the Game Center trophy
- Compare with friends or global players
- Rankings reset periodically for fresh competition

### Social Features

#### Friend Integration
- See friends' progress on leaderboards
- Achievement celebrations are shareable
- Challenge friends to beat your scores
- Privacy controls available in Game Center settings

---

## Apple Watch Experience

### Installation

#### Getting the Watch App
1. Install Lizard on your iPhone first
2. Open the Apple Watch app on iPhone
3. Scroll to "Available Apps" section
4. Find Lizard and tap "Install"
5. Wait for installation to complete

### Watch Gameplay

#### Simplified Interface
- **Single Spawn Button**: Tap to create lizards
- **Automatic Cleanup**: Lizards disappear after shorter duration
- **Performance Optimized**: Limited to 20 concurrent lizards
- **Touch Responsive**: Optimized for small screen interactions

#### Watch-Specific Features
- **Haptic Feedback**: Rich tactile response for spawning
- **Standalone Operation**: No iPhone required during play
- **Quick Sessions**: Designed for brief, satisfying interactions
- **Battery Optimized**: Minimal power consumption

### Sync & Continuity

#### Cross-Device Progress
- Game Center achievements sync between devices
- Separate leaderboards for each platform
- Independent gameplay experiences
- Unified Apple ID progress tracking

---

## Weather System

### Automatic Weather

#### Time-Based Changes
- **Morning**: Sunrise effects with warm colors
- **Day**: Bright sky with moving clouds
- **Evening**: Sunset transitions with orange hues
- **Night**: Stars, moon, and darker atmosphere

#### Weather Conditions
- **Clear**: Bright sky with gentle cloud movement
- **Cloudy**: Overcast with dynamic cloud layers
- **Rainy**: Animated raindrops with darker atmosphere
- **Dynamic**: Real-time transitions between conditions

### Manual Weather Control

#### Weather Toggle (if available)
- Switch between automatic and manual modes
- Cycle through different weather conditions
- Instant weather changes for preferred atmosphere
- Saved preferences for future sessions

#### Performance Impact
- Weather effects automatically reduce on older devices
- Can be disabled entirely for maximum performance
- Intelligent scaling based on device capabilities
- No impact on core physics simulation

---

## Performance & Settings

### Optimization

#### Device-Specific Performance
- **iPhone 14+**: Full 300-lizard support with all effects
- **iPhone 12-13**: Full support with automatic quality scaling
- **iPhone X-11**: Optimized with reduced concurrent lizards
- **iPhone 8 and older**: Performance mode with simplified effects
- **Apple Watch**: Dedicated 20-lizard optimized experience

#### Automatic Adjustments
- **Frame Rate Monitoring**: Continuous performance tracking
- **Quality Scaling**: Automatic reduction of effects under load
- **Memory Management**: Smart cleanup before memory pressure
- **Thermal Management**: Reduced effects if device gets warm

### Manual Performance Control

#### When to Adjust
- Experiencing choppy movement or low frame rates
- Device getting warm during extended play
- Other apps need maximum device performance
- Preserving battery life during long sessions

#### Performance Tips
1. **Close background apps** before playing
2. **Use clear button** periodically to reset physics
3. **Avoid rapid spawning** on older devices
4. **Restart app** if performance degrades over time

---

## Tips & Tricks

### Gameplay Mastery

#### Advanced Techniques
- **Gentle Tilting**: Smooth device movement creates natural lizard flow
- **Timing Spawns**: Wait for gravity changes before spawning for dramatic effects
- **Corner Collection**: Tilt to collect lizards in screen corners
- **Physics Experiments**: Use stop button to observe frozen physics states

#### Achievement Strategies
- **Button Masher**: Use single taps rather than holds for faster progress
- **Lizard Master**: Hold rain button for rapid progress toward 500 lizards
- **Steady Progress**: Play regularly rather than marathon sessions

### Creative Play

#### Physics Experiments
- Try different tilt angles and observe lizard behavior
- Use stop button to pause and study physics interactions
- Experiment with spawn timing during gravity changes
- Create lizard "flows" by timing tilts with spawning

#### Visual Enjoyment
- **Golden Hour**: Play during real sunset for atmospheric background
- **Rain Mode**: Combine weather rain with lizard rain for immersion
- **Minimalist**: Use clear button frequently for clean, simple aesthetics
- **Chaos Mode**: Max out lizards for frenetic physics action

### Efficiency Tips

#### Performance Optimization
- **Regular Clearing**: Use trash button every few minutes
- **Background Apps**: Close unused apps before extended play
- **Storage Space**: Keep at least 100MB free for optimal performance
- **Device Restart**: Restart iPhone/iPad weekly for best performance

#### Battery Conservation
- **Shorter Sessions**: 5-10 minute sessions preserve battery
- **Lower Brightness**: Reduce screen brightness during play
- **Airplane Mode**: Play offline to save cellular radio power
- **Watch Usage**: Apple Watch app uses minimal battery

---

## Accessibility Features

### Visual Accessibility

#### Built-in Support
- **High Contrast**: Works with iOS high contrast settings
- **Large Text**: UI scales with iOS text size settings
- **Color Blind Support**: Doesn't rely on color for core gameplay
- **Motion Settings**: Respects iOS motion reduction preferences

### Motor Accessibility

#### Alternative Controls
- **No Fine Motor Skills Required**: Large buttons and simple taps
- **Tilt Alternatives**: Can play without device tilting
- **One-Handed Use**: All controls accessible with single hand
- **No Time Pressure**: No rushed interactions or timing requirements

### Cognitive Accessibility

#### Simple Interface
- **Clear Visual Hierarchy**: Important buttons are largest
- **Consistent Layout**: Controls always in same positions
- **No Complex Rules**: Straightforward cause-and-effect gameplay
- **No Failure States**: No way to "lose" or "fail" at the game

### Assistive Technology

#### VoiceOver Support
- **Button Labels**: All interactive elements properly labeled
- **Status Updates**: Important state changes announced
- **Navigation**: Logical tab order through interface
- **Action Descriptions**: Clear descriptions of button functions

---

## Getting More Help

### Resources
- **[FAQ.md](FAQ.md)**: Common questions and quick answers
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)**: Detailed problem-solving guide
- **[CONTROLS.md](CONTROLS.md)**: Complete control reference
- **[Game Center App](https://apps.apple.com/app/game-center/id1020906616)**: Official leaderboards and achievements

### Support Channels
- **TestFlight Feedback**: Screenshot during beta to send feedback
- **App Store Reviews**: Share experience and suggestions
- **GitHub Issues**: Technical problems and feature requests
- **Game Center**: Connect with other players

### Community
- **Share Screenshots**: Show off interesting physics moments
- **Achievement Celebrations**: Share milestone unlocks
- **Tips Exchange**: Share gameplay discoveries with others
- **Feature Requests**: Suggest improvements and new features

---

*This user guide covers Lizard version 1.1.0. For the latest updates and features, check the [CHANGELOG.md](CHANGELOG.md). Happy lizard spawning! 🦎✨*