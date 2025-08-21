# 🎮 Lizard Controls Guide

Master the controls and get the most out of your Lizard physics simulation experience!

## 🕹️ Basic Controls

### Main Spawn Button (🦎)
The large center button is your primary lizard creation tool.

#### Single Tap
- **Action**: Spawns one lizard at screen center
- **Physics**: Random velocity between -90 to +90 horizontal, 120-220 upward
- **Size**: Random scale from 40% to 160% of base size
- **Sound**: Plays lizard spawn sound effect
- **Counter**: Increments both lizard count and button tap count

#### Hold & Drag
- **Action**: Continuous spawning while button is pressed
- **Timing**: New lizard every 0.07 seconds (about 14 per second)
- **Variation**: Each lizard has unique size and velocity
- **Performance**: Automatically throttles if too many lizards exist
- **Visual**: Button scales down while pressed for feedback

### Rain Controls (🌧️)

#### Rain Button Tap
- **Action**: Creates a burst of 16 lizards
- **Spawn Location**: Randomly distributed across top of screen
- **Physics**: Downward velocity with slight horizontal variation
- **Size**: Smaller lizards (45%-90% scale) for rain effect
- **No Sound**: Silent to avoid audio spam

#### Rain Button Hold
- **Action**: Continuous rain mode
- **Timing**: New rain burst every 0.08 seconds
- **Intensity**: Sustained lizard rainfall
- **Performance**: Smart throttling prevents lag
- **Gesture**: Long press gesture detection

### Utility Controls

#### Stop Button (🛑)
- **Primary Function**: Pauses lizard aging (prevents automatic cleanup)
- **Physics**: Lizards continue moving but don't disappear
- **Use Case**: Preserve interesting physics scenarios
- **Visual State**: Secondary button styling
- **Instant Effect**: Immediate pause activation

#### Clear Button (🗑️)
- **Primary Function**: Removes all lizards from screen
- **Animation**: Immediate clearing with no transition
- **Reset**: Clears physics simulation
- **Memory**: Frees up device memory
- **Fresh Start**: Returns to clean slate

## 📱 Motion Controls

### Tilt to Control Gravity
Transform your device into a gravity controller!

#### How It Works
1. **Enable**: Tilt controls activate automatically when app launches
2. **Sensitivity**: Responds to device acceleration in real-time
3. **Gravity Vector**: Device tilt directly maps to gravity direction
4. **Update Rate**: 60 FPS for smooth, responsive control

#### Orientation Behavior

##### Portrait Mode (Normal)
- **Tilt Left**: Gravity pulls lizards left
- **Tilt Right**: Gravity pulls lizards right
- **Tilt Forward**: Gravity pulls lizards toward bottom
- **Tilt Backward**: Gravity pulls lizards toward top

##### Landscape Left
- **Device Rotation**: 90° counter-clockwise
- **Gravity Mapping**: Adjusted for new orientation
- **Safety Feature**: Prevents upward gravity (lizards won't fall to top)
- **Natural Feel**: Intuitive gravity direction

##### Landscape Right  
- **Device Rotation**: 90° clockwise
- **Gravity Mapping**: Properly transformed
- **Safety Feature**: Upward gravity prevention active
- **Consistent**: Predictable gravity behavior

##### Portrait Upside Down
- **Device Rotation**: 180° flip
- **Gravity Mapping**: Inverted gravity vector
- **Full Support**: Complete orientation compatibility
- **Edge Case**: Rarely used but fully functional

#### Tips for Tilt Control
- **Gentle Movements**: Small tilts create subtle effects
- **Dramatic Tilts**: Large movements for fun physics chaos
- **Circular Motion**: Rotate device for orbital gravity effects
- **Quick Flips**: Rapid orientation changes for dynamic gameplay

## 🎯 Advanced Techniques

### Combo Moves

#### Rain + Tilt Combination
1. Start rain mode (hold rain button)
2. Simultaneously tilt device in circles
3. Creates swirling lizard vortex effect
4. Combine with stop button to freeze the pattern

#### Spam + Clear Technique
1. Hold main button for maximum spawning
2. Wait until screen fills with lizards
3. Tap clear for satisfying mass disappearance
4. Repeat for stress relief gaming

#### Precision Spawning
1. Single tap main button
2. Immediately tilt device to guide lizard
3. Use stop button to preserve interesting positions
4. Build complex lizard sculptures

### Performance Optimization
The app includes smart controls to maintain smooth performance:

#### Automatic Throttling
- **Lizard Limit**: Maximum 300 physics objects
- **FPS Monitoring**: Reduces spawning if frame rate drops below 45 FPS
- **Memory Management**: Automatic cleanup prevents crashes
- **Quality Scaling**: Dynamic performance adjustment

#### User Control Tips
- **Moderation**: Avoid continuous rain + spam for extended periods
- **Clearing**: Regular use of clear button maintains performance
- **Observation**: Watch FPS in debug mode to understand limits
- **Patience**: Let physics settle between major spawning sessions

## 🔧 Accessibility Features

### Visual Accessibility
- **High Contrast**: Liquid glass buttons maintain readability
- **Clear Icons**: Recognizable emoji and SF Symbols
- **Size Scaling**: Buttons designed for easy targeting
- **Visual Feedback**: Clear pressed states and animations

### Motor Accessibility
- **Large Targets**: Generous button hit areas
- **Gesture Tolerance**: Forgiving tap and hold detection
- **No Precise Timing**: No requirement for exact timing
- **Optional Tilt**: Motion controls are enhancement, not requirement

### Cognitive Accessibility
- **Simple Controls**: Intuitive button purposes
- **Immediate Feedback**: Visual and audio confirmation
- **No Complex Combos**: All features accessible with single actions
- **Forgiving**: No penalty for "wrong" inputs

## 🎮 Control Troubleshooting

### Common Issues

#### Tilt Not Working
- **Check**: Device motion permissions granted
- **Verify**: Accelerometer/gyroscope functionality
- **Restart**: Close and reopen app
- **Hardware**: Some older devices may have limited motion capability

#### Buttons Not Responding
- **Touch**: Ensure direct contact with button areas
- **Performance**: Check if device is under memory pressure
- **Clean**: Wipe screen to remove interference
- **Background**: Ensure app is in foreground

#### Audio Not Playing
- **Silent Mode**: Check device silent switch position
- **Volume**: Verify system volume level
- **Background**: Audio may pause during calls or other interruptions
- **Permissions**: Ensure audio permissions granted

#### Poor Performance
- **Clear**: Use clear button to reduce lizard count
- **Background**: Close other apps to free memory
- **Restart**: Restart app if performance degraded
- **Device**: Older devices may have natural limitations

### Best Practices
- **Regular Clearing**: Clear lizards periodically for optimal performance
- **Gentle Tilting**: Avoid extreme device movements
- **Battery**: Tilt controls consume more battery than static gameplay
- **Breaks**: Take occasional breaks from motion controls

---

## Control Summary Card

| Input | Action | Effect |
|-------|--------|--------|
| 🦎 Tap | Single Spawn | One lizard + sound |
| 🦎 Hold | Spam Spawn | Continuous lizards |
| 🌧️ Tap | Rain Burst | 16 lizards from top |
| 🌧️ Hold | Rain Mode | Continuous rain |
| 🛑 Tap | Stop Aging | Pause lizard cleanup |
| 🗑️ Tap | Clear All | Remove all lizards |
| 📱 Tilt | Gravity | Control physics direction |

---

*Master these controls and become a lizard physics wizard! 🦎🧙‍♂️*