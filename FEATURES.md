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

### 🔮 Upcoming Features (Version 1.2+)

#### Enhanced Physics & Gameplay
- **Advanced Physics Customization**
  - *Example*: Slider controls for gravity strength (0.5x to 2.0x Earth gravity)
  - *Use Case*: Create moon-like low gravity or Jupiter-like heavy gravity scenarios
  - *Implementation*: Real-time physics parameter adjustment

- **Multiple Lizard Species**
  - *Example*: Green lizards (standard), Blue lizards (bouncy), Red lizards (heavy)
  - *Behavior*: Each species has unique physics properties and animations
  - *Visual*: Distinct colors, sizes, and movement patterns

- **Interactive Obstacles**
  - *Example*: Draggable walls, ramps, and bounce pads
  - *Physics*: Objects affect lizard movement and create complex interactions
  - *Creativity*: Users can design custom physics environments

#### Visual & Audio Enhancements
- **Enhanced Particle Effects**
  - *Example*: Sparkle trails following lizards, impact effects on collisions
  - *Performance*: GPU-accelerated particles with automatic quality scaling
  - *Customization*: Toggle effects on/off for performance or preference

- **Seasonal Themes**
  - *Example*: Spring (flowers), Summer (bright), Fall (leaves), Winter (snow)
  - *Dynamic*: Automatically changes based on real-world date
  - *Override*: Manual selection for preferred atmosphere

- **Sound Variations**
  - *Example*: 5 different spawn sounds, 3 collision sounds, ambient nature sounds
  - *Randomization*: Prevents audio repetition during extended play
  - *Spatial Audio*: Sounds positioned based on lizard location

#### Social & Sharing Features
- **Social Sharing**
  - *Example*: Export 10-second physics videos, screenshot with stats overlay
  - *Platforms*: Share to Messages, Mail, Social Media
  - *Privacy*: Local export only, no cloud uploading

- **Community Challenges**
  - *Example*: "Spawn 50 lizards in under 30 seconds", "Create a lizard tower"
  - *Weekly*: New challenges every Monday with global leaderboards
  - *Rewards*: Special achievement badges for challenge completion

- **Replay System**
  - *Example*: Record last 60 seconds of gameplay, save favorite moments
  - *Playback*: Slow motion, rewind, frame-by-frame analysis
  - *Storage*: Local device storage, user-controlled deletion

#### Advanced Features
- **Photo Mode**
  - *Example*: Freeze physics, move camera, adjust lighting, apply filters
  - *Controls*: Gesture-based camera movement, tap-to-focus, exposure control
  - *Export*: High-resolution images suitable for wallpapers

- **Custom Gravity Fields**
  - *Example*: Circular gravity wells, anti-gravity zones, directional forces
  - *Interaction*: Draw gravity fields with finger, adjust strength with pinch
  - *Persistence*: Save and load custom gravity configurations

### 🎯 User-Requested Features

Based on community feedback and feature requests:

#### Customization Options
- **Visual Customization**
  - *Lizard Colors*: RGB color picker for lizard tinting
  - *Background Themes*: Space, underwater, forest, abstract
  - *UI Themes*: Light mode, dark mode, high contrast, colorblind-friendly

- **Gameplay Customization**
  - *Physics Presets*: Realistic, cartoon, zero-gravity, high-bounce
  - *Spawn Patterns*: Single, burst, spiral, rain, controlled
  - *Auto-Clear Settings*: Adjustable lizard lifetime (5s to 30s)

#### Accessibility Enhancements
- **Visual Accessibility**
  - *High Contrast Mode*: Enhanced visibility for low vision users
  - *Motion Reduction*: Simplified animations for motion sensitivity
  - *Font Scaling*: Support for extra large text sizes

- **Motor Accessibility**
  - *Button Customization*: Adjustable button sizes and positions
  - *Alternative Controls*: Tap-only mode without device tilting
  - *Voice Control*: Integration with iOS Voice Control features

#### Performance & Technical
- **Advanced Performance Options**
  - *Quality Presets*: Ultra (300 lizards), High (200), Medium (100), Low (50)
  - *Frame Rate Target*: 30 FPS, 60 FPS, 120 FPS (on supported devices)
  - *Battery Saver Mode*: Reduced effects and frame rate for longer play

- **Developer Tools**
  - *Debug Overlay*: FPS counter, memory usage, physics stats
  - *Performance Profiler*: Real-time performance metrics
  - *Export Logs*: Share performance data for optimization

### 📱 Platform-Specific Roadmap

#### iOS Enhancements
- **iPad Optimization**
  - *Split Screen*: Side-by-side physics simulations
  - *Apple Pencil*: Precise lizard spawning and obstacle drawing
  - *External Keyboard*: Keyboard shortcuts for power users

- **iPhone Pro Features**
  - *ProMotion*: 120 FPS physics simulation on supported devices
  - *LiDAR*: Room-scale physics mapping (experimental)
  - *Camera Integration*: AR lizards in real environment

### 🔬 Experimental Features

Features in research and development phase:

#### AI & Machine Learning
- **Intelligent Physics**
  - *Adaptive Difficulty*: AI adjusts complexity based on user skill
  - *Predictive Spawning*: ML suggests optimal spawn locations
  - *Behavior Learning*: Lizards learn from user interaction patterns

#### Advanced Graphics
- **Metal Performance Shaders**
  - *GPU Physics*: Ultra-high performance physics simulation
  - *Real-time Shadows*: Dynamic lighting and shadow effects
  - *Particle Systems*: Advanced GPU-accelerated visual effects

#### Cross-Platform Features
- **Universal Clipboard**
  - *Configuration Sync*: Settings synchronization via iCloud
  - *Cloud Save*: Progress and statistics saved to iCloud

### 📊 Feature Voting & Feedback

#### Community Input
- **Feature Voting**: Vote on upcoming features in GitHub Discussions
- **Beta Testing**: Early access to experimental features via TestFlight
- **Feedback Integration**: Screenshot feedback automatically categorizes suggestions

#### Development Transparency
- **Public Roadmap**: Real-time updates on feature development progress
- **Development Blogs**: Technical posts about implementation challenges
- **Community Calls**: Monthly virtual meetups with development team

---

## 🎮 Try These Features Today!

### Hidden Features
- **Double-tap center button**: Rapid-fire lizard spawning
- **Triple-tap rain button**: Mega-rain mode with enhanced effects
- **Hold stop + clear**: Easter egg physics mode
- **Shake device during tilt**: Earthquake gravity mode

### Pro Tips
- **Performance Mode**: Close other apps before spawning 200+ lizards
- **Battery Conservation**: Use stop button to pause aging for longer sessions
- **Achievement Hunting**: Hold rain button for fastest progress to 500 lizards
- **Creative Mode**: Use landscape orientation for wider physics playground

### Advanced Techniques
- **Gravity Surfing**: Gentle device tilts create flowing lizard movements
- **Corner Collection**: Use walls to gather lizards in screen corners
- **Physics Experiments**: Stop aging, spawn patterns, resume for interesting effects
- **Zen Mode**: Clear frequently for minimalist, meditative experience

---

*Explore all these features and more in the Lizard app! Share your favorite combinations and discoveries with the community. 🦎✨*

**Want to suggest a feature?** Check out our [Contributing Guide](CONTRIBUTING.md) to learn how to submit feature requests and join the development discussion!