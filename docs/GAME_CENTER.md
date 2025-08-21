# 🏆 Game Center Setup Guide

Complete guide for configuring and managing Game Center features in the Lizard app.

## 📋 Overview

Lizard integrates with Apple's Game Center to provide social gaming features including leaderboards, achievements, and player authentication. This guide covers both player setup and developer configuration.

## 👤 Player Setup

### Enabling Game Center
1. **iOS Settings**: Open Settings app on your device
2. **Game Center**: Find and tap "Game Center" in settings
3. **Sign In**: Use your Apple ID to sign in to Game Center
4. **Profile**: Set up your Game Center nickname and profile
5. **Privacy**: Configure friend discovery and leaderboard privacy settings

### First Launch Experience
When you first open Lizard with Game Center enabled:

1. **Authentication Prompt**: App will request Game Center access
2. **Welcome Screen**: Game Center welcome banner may appear
3. **Automatic Setup**: Your scores and achievements sync automatically
4. **Access Point**: Floating trophy icon appears (top-right by default)

### Game Center Features in Lizard

#### Leaderboards
- **Total Lizards Spawned**: Your lifetime lizard creation count
- **Button Taps**: Total main button interactions
- **Global Rankings**: Compare with players worldwide
- **Friend Rankings**: See how you rank among Game Center friends

#### Achievements
- **First Century** 🥉: Spawn 100 total lizards
- **Lizard Master** 🥈: Spawn 500 total lizards
- **Button Masher** 🥇: Tap the main button 100 times

## 🎮 Using Game Center in Lizard

### Accessing Game Center
Multiple ways to view your Game Center progress:

#### Via Access Point
1. **Trophy Icon**: Tap the floating trophy in the top-right corner
2. **Dashboard**: Opens Game Center dashboard
3. **Navigation**: Browse leaderboards and achievements
4. **Social**: View friend activities and challenges

#### Via Settings
1. **iOS Settings**: Go to Settings > Game Center
2. **View Profile**: See your overall Game Center statistics
3. **Friend Management**: Add or remove Game Center friends
4. **Privacy Controls**: Manage what information is shared

### Score Tracking

#### Automatic Updates
- **Real-Time**: Scores update immediately as you play
- **Background Sync**: Syncs when app returns from background
- **Offline Support**: Scores are cached and synced when online
- **Error Handling**: Failed uploads are retried automatically

#### Manual Refresh
If scores seem out of sync:
1. **Force Close**: Swipe up from bottom and close Lizard app
2. **Reopen**: Launch Lizard again
3. **Check Connection**: Ensure internet connectivity
4. **Game Center**: Visit Game Center dashboard to trigger sync

### Achievement Progress

#### Viewing Progress
- **In-App**: Progress tracked automatically during gameplay
- **Game Center**: View detailed progress in Game Center dashboard
- **Notifications**: Achievement unlocks show completion banners
- **History**: Review all earned achievements in Game Center

#### Achievement Tips
- **First Century**: Play regularly, spawning lizards adds up quickly
- **Lizard Master**: Use rain mode for faster lizard spawning
- **Button Masher**: Single taps count, hold actions count continuously

## 🔧 Troubleshooting

### Common Issues

#### Game Center Not Working
**Check Authentication**:
1. Settings > Game Center > confirm signed in
2. Try signing out and back in
3. Restart the Lizard app
4. Check internet connection

**Reset Game Center**:
1. Settings > Game Center > Sign Out
2. Restart device
3. Sign back in to Game Center
4. Reopen Lizard app

#### Scores Not Updating
**Verify Connection**:
- Check WiFi/cellular data connection
- Try accessing other Game Center games
- Wait a few minutes for sync delays
- Force close and reopen Lizard

**Manual Sync**:
- Open Game Center dashboard
- Navigate to Lizard leaderboards
- Pull down to refresh
- Return to Lizard app

#### Achievements Not Unlocking
**Progress Check**:
- Verify you've met the requirements
- Check achievement progress in Game Center
- Ensure Game Center is properly authenticated
- Try triggering the achievement action again

**Cache Clear**:
- Force close Lizard app
- Restart device
- Reopen app and check achievements

### Privacy Concerns

#### Data Sharing
Game Center only shares:
- Your chosen Game Center nickname
- Scores for games you've played
- Achievement status
- Friend connections (if enabled)

**Lizard Never Shares**:
- Personal information
- Device details
- Location data
- Usage analytics

#### Privacy Controls
1. **Settings > Game Center > Privacy**
2. **Friend Discovery**: Control who can find you
3. **Leaderboards**: Choose public vs friends-only
4. **Profile Visibility**: Manage what others see

## 👨‍💻 Developer Configuration

### App Store Connect Setup

#### Game Center Configuration
1. **App Store Connect**: Log in to developer portal
2. **Apps Section**: Select Lizard app
3. **Features Tab**: Navigate to Game Center
4. **Enable Game Center**: Toggle on Game Center integration

#### Leaderboard Setup

##### Total Lizards Spawned
- **Leaderboard ID**: `com.town3r.lizard.totalspawned`
- **Name**: "Total Lizards Spawned"
- **Score Format**: Integer
- **Sort Order**: High to Low
- **Score Range**: 0 to 999,999,999

##### Button Taps
- **Leaderboard ID**: `com.town3r.lizard.buttontaps`
- **Name**: "Button Taps"
- **Score Format**: Integer
- **Sort Order**: High to Low
- **Score Range**: 0 to 999,999,999

#### Achievement Configuration

##### First Century
- **Achievement ID**: `com.town3r.lizard.ach.first100`
- **Name**: "First Century"
- **Description**: "Spawn 100 lizards"
- **Points**: 10 points
- **Hidden**: No

##### Lizard Master
- **Achievement ID**: `com.town3r.lizard.ach.first500`
- **Name**: "Lizard Master"
- **Description**: "Spawn 500 lizards"
- **Points**: 25 points
- **Hidden**: No

##### Button Masher
- **Achievement ID**: `com.town3r.lizard.ach.tap100`
- **Name**: "Button Masher"
- **Description**: "Tap the button 100 times"
- **Points**: 15 points
- **Hidden**: No

### Xcode Project Configuration

#### Entitlements
Ensure `Lizard.entitlements` includes:
```xml
<key>com.apple.developer.game-center</key>
<true/>
```

#### Info.plist
No special Game Center entries required in iOS 18+.

#### Capabilities
1. **Project Settings**: Select Lizard target
2. **Signing & Capabilities**: Add Game Center capability
3. **Provisioning**: Ensure provisioning profile includes Game Center

### Testing Game Center

#### Sandbox Environment
- **Development Builds**: Automatically use Game Center sandbox
- **TestFlight Builds**: Use Game Center sandbox
- **App Store Builds**: Use production Game Center

#### Sandbox Testing
1. **Test Accounts**: Create sandbox test accounts in App Store Connect
2. **Device Setup**: Sign in with test account on device
3. **Testing**: All Game Center features work in sandbox
4. **Data Isolation**: Sandbox data is separate from production

#### Production Testing
- **Release Builds**: Only App Store builds use production Game Center
- **Real Accounts**: Uses real Game Center accounts and data
- **Live Leaderboards**: Competes with real players globally

## 📊 Analytics and Monitoring

### Game Center Insights
App Store Connect provides analytics for:
- **Player Engagement**: How many players use Game Center
- **Achievement Completion**: Which achievements are most/least earned
- **Leaderboard Activity**: Score submission patterns
- **Retention**: How Game Center affects user retention

### Monitoring Best Practices
- **Regular Checks**: Monitor Game Center configuration monthly
- **User Feedback**: Listen for Game Center-related support requests
- **Performance**: Track Game Center API call success rates
- **Competition**: Monitor leaderboard activity and top players

## 🔮 Future Enhancements

### Planned Features
- **Friend Challenges**: Direct competition between Game Center friends
- **Seasonal Events**: Time-limited achievements and leaderboards
- **Social Sharing**: Share achievements and high scores
- **Rich Presence**: Show current activity to Game Center friends

### Advanced Integration
- **CloudKit**: Cross-device score synchronization
- **Group Activities**: Multiplayer physics sessions
- **Widgets**: Game Center progress in iOS widgets
- **Shortcuts**: Siri integration for quick game launches

---

## Quick Reference

### Game Center IDs
```
Leaderboards:
- com.town3r.lizard.totalspawned
- com.town3r.lizard.buttontaps

Achievements:
- com.town3r.lizard.ach.first100
- com.town3r.lizard.ach.first500
- com.town3r.lizard.ach.tap100
```

### Support Commands
```bash
# Check Game Center status in Xcode
po GKLocalPlayer.local.isAuthenticated

# Simulate achievement unlock (testing)
let achievement = GKAchievement(identifier: "com.town3r.lizard.ach.first100")
achievement.percentComplete = 100
achievement.showsCompletionBanner = true
GKAchievement.report([achievement])
```

---

*Compete with friends and climb the leaderboards! 🏆🦎*