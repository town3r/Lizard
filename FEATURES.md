# 🦎 Lizard Features Guide

A comprehensive guide to all the features and capabilities in the Lizard iOS physics simulation game.

## 🎮 Core Gameplay Features

### Physics Simulation Engine
- **Realistic Physics**: Built on SpriteKit's robust physics engine
- **Gravity System**: Customizable gravity direction and strength
- **Collision Detection**: Lizards interact with screen boundaries and each other
- **Performance Optimization**: Maximum 300 concurrent physics objects for smooth performance
- **Automatic Cleanup**: Lizards automatically disappear after 10 seconds to prevent memory issues

### Lizard Spawning System

#### Main Spawn Button (🦎)
- **Single Tap**: Spawns one lizard with random velocity at screen center
- **Hold to Spam**: Continuous spawning while button is held down
- **Visual Feedback**: Button scales and provides haptic feedback
- **Sound Effects**: Audio confirmation for each spawn
- **Randomization**: Each lizard has unique size (0.4x to 1.6x) and velocity

#### Rain Mode (🌧️)
- **Burst Spawning**: Single tap creates 16 lizards at once
- **Continuous Rain**: Hold button for sustained lizard rainfall
- **Top-of-Screen Origin**: Lizards spawn across the top edge
- **Downward Velocity**: Rain lizards fall naturally with gravity

### Motion Controls

#### Tilt Functionality
- **Device Orientation**: Uses CoreMotion to read device acceleration
- **Gravity Direction**: Tilt device to change gravity vector
- **Orientation Support**: Works in portrait and landscape orientations
- **Safety Limits**: Prevents lizards from falling "upward" in landscape mode
- **60 FPS Updates**: Smooth, responsive motion tracking

#### Gravity Transformation
- **Portrait**: Standard gravity mapping (tilt left = gravity left)
- **Landscape Left**: Rotated gravity with upward prevention
- **Landscape Right**: Rotated gravity with upward prevention  
- **Portrait Upside Down**: Inverted gravity mapping

## 🎨 Visual Features

### Dynamic Background System

#### Day/Night Cycle
- **Real-Time Based**: Changes according to actual time of day
- **Smooth Transitions**: Gradual color shifts throughout the day
- **Sky Gradients**: Multi-stop gradients for realistic sky appearance
- **Color Schemes**: Different palettes for light and dark mode

#### Starfield Animation
- **Nighttime Stars**: 140 stars with realistic positioning
- **Twinkling Effect**: Stars pulse with varying brightness
- **Seeded Random**: Consistent star positions across app launches
- **Performance Optimized**: Efficient rendering for battery life

### User Interface Design

#### Liquid Glass Styling
- **Translucent Effects**: Semi-transparent backgrounds with blur
- **Depth Perception**: Layered shadows and highlights
- **Modern Aesthetic**: iOS-native design language
- **Accessibility**: High contrast ratios for readability

#### Button System
- **Primary Buttons**: Main spawn and rain controls
- **Secondary Buttons**: Stop and clear functionality
- **Icon Support**: System SF Symbols and emoji icons
- **Responsive Design**: Adapts to different screen sizes

### HUD Elements

#### Statistics Display
- **Lizard Counter**: Running total of spawned lizards (🦎 icon)
- **Button Taps**: Count of main button interactions (🔘 icon)
- **Monospace Font**: Consistent number alignment
- **Real-Time Updates**: Instant feedback on user actions

## 🎵 Audio System

### Sound Effects
- **Spawn Sounds**: Audio feedback for lizard creation
- **Multi-Voice Pooling**: Multiple audio instances prevent overlap issues
- **Rate Limiting**: Prevents audio spam and performance issues
- **Silent Mode Support**: Audio works even when device is silenced

### Audio Configuration
- **AVFoundation**: Professional-grade audio framework
- **Background Audio**: Continues playing during app switching
- **Memory Management**: Efficient audio resource cleanup
- **Format Support**: WAV files for high-quality, low-latency playback

## 🏆 Game Center Integration

### Leaderboards

#### Total Lizards Spawned
- **Identifier**: `com.town3r.lizard.totalspawned`
- **Metric**: Cumulative count across all play sessions
- **Global Rankings**: Compete with players worldwide
- **Automatic Reporting**: Scores updated in real-time

#### Button Taps Counter
- **Identifier**: `com.town3r.lizard.buttontaps`
- **Metric**: Total main button interactions
- **Persistent Storage**: Maintained across app launches
- **Game Center Sync**: Automatic cloud synchronization

### Achievement System

#### "First Century" Achievement
- **Unlock Condition**: Spawn 100 total lizards
- **Identifier**: `com.town3r.lizard.ach.first100`
- **Completion Banner**: Visual celebration on unlock
- **Persistent Progress**: Tracks across app sessions

#### "Lizard Master" Achievement  
- **Unlock Condition**: Spawn 500 total lizards
- **Identifier**: `com.town3r.lizard.ach.first500`
- **Milestone Reward**: Advanced player recognition
- **Cumulative Tracking**: Builds on previous progress

#### "Button Masher" Achievement
- **Unlock Condition**: Tap main button 100 times
- **Identifier**: `com.town3r.lizard.ach.tap100`
- **Interaction Focus**: Rewards active engagement
- **Tap Counting**: Separate from lizard spawning metric

### Game Center UI
- **Access Point**: Floating trophy icon for quick access
- **Dashboard Integration**: Native Game Center interface
- **Authentication**: Automatic login flow
- **Privacy Friendly**: Respects user Game Center preferences

## 🔧 Control Features

### Gameplay Controls
- **Stop Button** (🛑): Pauses physics aging without clearing lizards
- **Clear Button** (🗑️): Removes all active lizards from screen
- **Gesture Support**: Tap and hold gestures for enhanced interaction
- **Visual Feedback**: Button press animations and state changes

### App Lifecycle Management
- **Background Handling**: Pauses physics when app backgrounded
- **Resume Behavior**: Maintains state when returning to foreground
- **Memory Cleanup**: Automatic resource management
- **State Persistence**: User preferences and scores maintained

## 🧪 Beta & Testing Features

### Screenshot Feedback System
- **TestFlight Integration**: Available only during beta testing
- **Automatic Detection**: Monitors for screenshot events
- **Feedback Composer**: Opens mail interface for user reports
- **Privacy Safe**: No screenshot data is transmitted

### Performance Monitoring
- **FPS Tracking**: Real-time frame rate monitoring
- **Quality Adjustment**: Automatic performance optimization
- **Debug Information**: Development-time performance metrics
- **Memory Pressure**: Intelligent object lifecycle management

### Development Tools
- **Debug HUD**: Optional performance overlay
- **Physics Visualization**: Development-time collision boundaries
- **Audio Testing**: Voice pool validation and testing
- **Memory Profiling**: Object count and cleanup verification

---

## Feature Roadmap

### Planned Enhancements
- Additional physics objects and interactions
- More lizard varieties and animations  
- Enhanced particle effects
- Social sharing capabilities
- Custom gravity fields and obstacles

### User-Requested Features
- Color customization options
- Sound effect variations
- Additional achievements
- Replay system
- Photo mode

---

*Explore all these features and more in the Lizard app! 🦎✨*