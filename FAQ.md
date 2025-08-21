# 🤔 Frequently Asked Questions (FAQ)

## General Questions

### What is Lizard?
Lizard is a delightful physics simulation game for iOS and Apple Watch where you spawn adorable lizard emojis that interact with realistic physics, gravity, and device motion. It's designed to be both relaxing and engaging, combining smooth animations with intuitive controls.

### What platforms does Lizard support?
- **iOS**: iPhone and iPad running iOS 18.0 or later
- **Apple Watch**: watchOS 9.0 or later (companion app)
- **Cross-Platform**: Progress syncs between devices via Game Center

### Is Lizard free to play?
Yes! Lizard is available as a free download with no in-app purchases. All features, including Game Center integration and the watchOS companion app, are included.

### Does Lizard require an internet connection?
No, Lizard works completely offline. However, an internet connection is needed for:
- Game Center leaderboards and achievements
- Initial Game Center setup
- TestFlight feedback submission (beta versions only)

## Gameplay Questions

### How do I spawn lizards?
- **Single Lizard**: Tap the center button (🦎) once
- **Multiple Lizards**: Hold the rain button (🌧️) or hold the center button
- **Continuous Rain**: Keep holding either button for continuous spawning

### How do I control gravity?
Tilt your device in any direction! The lizards will fall toward the direction you tilt. This uses your device's built-in accelerometer and gyroscope.

### Why do lizards disappear?
Lizards automatically disappear after 10 seconds to maintain smooth performance. This prevents the screen from becoming cluttered and ensures the app runs smoothly even after extended play.

### What's the maximum number of lizards I can have at once?
The app limits lizards to 300 concurrent objects for optimal performance. When you reach this limit, older lizards will be removed as new ones spawn.

### Can I change the weather effects?
Yes! Use the weather control toggle to switch between automatic (time-based) and manual weather modes. In manual mode, you can cycle through different weather conditions.

## Technical Questions

### Why does the app need motion permissions?
Motion permissions allow the app to detect device tilting for gravity control. This is completely optional - you can still play without tilt controls, but it's much more fun with them enabled!

### Does the app work in silent mode?
Yes! Lizard is configured to play audio even when your device is in silent mode, similar to games and media apps. You can still mute sounds completely using the device volume controls.

### Will Lizard drain my battery?
Lizard is optimized for battery efficiency with:
- Automatic performance scaling based on device capabilities
- Smart cleanup of game objects
- Efficient graphics rendering
- Power-conscious audio management

### Why does Game Center ask for permission?
Game Center integration provides:
- **Achievements**: Track your lizard spawning milestones
- **Leaderboards**: Compete with friends and global players
- **Cross-Device Sync**: Keep progress across iPhone and Apple Watch
You can decline Game Center and still enjoy the full game experience.

## Troubleshooting

### The app crashes when I spawn many lizards
This usually indicates a memory issue. Try:
1. Restart the app
2. Restart your device
3. Ensure you have at least 100MB of free storage
4. Close other running apps to free up memory

### Tilt controls aren't working
1. Make sure you granted motion permissions when first launching the app
2. Check Settings > Privacy & Security > Motion & Fitness > Lizard
3. Try restarting the app
4. Ensure your device isn't in a case that might interfere with sensors

### No sound effects
1. Check that your device volume is up
2. Try toggling silent mode off and on
3. Restart the app
4. Check if other apps have audio issues (might be a system issue)

### Game Center not working
1. Ensure you're signed in to Game Center in Settings
2. Check your internet connection
3. Try signing out and back in to Game Center
4. Restart the app

### Lizards appear in wrong location on Apple Watch
This is typically a display scaling issue. Try:
1. Restart the watch app
2. Check if the iPhone app is also running (shouldn't matter, but might help)
3. Restart your Apple Watch

## Apple Watch Specific

### Do I need my iPhone for the watch app?
No! The Apple Watch app is completely standalone and doesn't require your iPhone to be nearby or even turned on.

### Why are there fewer lizards on Apple Watch?
The watch version is optimized for Apple Watch hardware with a limit of 20 concurrent lizards instead of 300 on iPhone. This ensures smooth performance on the smaller, less powerful device.

### Can I use the Digital Crown?
Currently, the watch app uses touch controls only. Digital Crown support is planned for a future update.

### Does the watch app have achievements?
Yes! The watch app has its own set of Game Center achievements that are separate from but complement the iPhone achievements.

## Beta Testing (TestFlight Users)

### How do I provide feedback?
Take a screenshot while using the app! This automatically opens the feedback composer where you can describe issues or suggestions.

### What information should I include in feedback?
- What you were doing when the issue occurred
- Device model and iOS/watchOS version
- Whether the issue is reproducible
- Screenshots or screen recordings if possible

### Will my feedback be read?
Yes! All feedback is reviewed and helps improve the app for everyone. Many features in current releases came from beta tester suggestions.

## Performance & Optimization

### Why does the FPS counter show sometimes?
The FPS (frames per second) counter appears in debug builds to help monitor performance. It shows:
- **Green**: Good performance (45+ FPS)
- **Yellow**: Acceptable performance (30-45 FPS)  
- **Red**: Poor performance (below 30 FPS)

### How can I improve performance?
- Close other running apps
- Restart your device periodically
- Ensure adequate free storage space
- Use fewer concurrent lizards (they auto-clean after 10 seconds)
- Disable weather effects if experiencing performance issues

## Feature Requests & Suggestions

### How can I request new features?
- **TestFlight Users**: Use the screenshot feedback system
- **GitHub**: Submit issues on the project repository
- **App Store**: Leave reviews with suggestions
- **Game Center**: Connect with other players for community features

### Are more platforms planned?
Currently focused on iOS and watchOS. Other platforms may be considered based on user interest and technical feasibility.

### Will there be more lizard types?
Different colored lizards and species with unique physics properties are planned for future updates!

---

## Still Have Questions?

Can't find what you're looking for? Here are additional resources:

- **User Guide**: See [USER_GUIDE.md](USER_GUIDE.md) for comprehensive gameplay instructions
- **Technical Issues**: Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for detailed solutions
- **Developer Info**: See [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) for technical details
- **Controls Reference**: See [CONTROLS.md](CONTROLS.md) for complete control documentation

*Last updated: Version 1.1.0 🦎*