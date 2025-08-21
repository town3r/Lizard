# watchOS Interface Mockup

Since we can't actually run the watchOS simulator in this environment, here's a text representation of what the interface looks like:

```
┌─────────────────────────┐
│  Apple Watch Screen     │
│                         │
│     ┌─────────────┐     │
│     │ 🦎 42       │     │  <- Stats display
│     │ 👆 28       │     │     (spawned/taps)
│     └─────────────┘     │
│                         │
│        🦎 🦎 🦎        │  <- Animated lizards
│     🦎          🦎     │     moving around
│                         │
│                         │
│      ┌───────────┐      │
│      │     🦎    │      │  <- Main spawn button
│      │           │      │     (80pt diameter)
│      └───────────┘      │
│                         │
│                         │
└─────────────────────────┘
```

## Interface Elements

1. **Top Stats Panel**
   - Shows lizard count (🦎 42) and tap count (👆 28)
   - Translucent background with rounded corners
   - Monospace font for clean number display

2. **Animated Lizards**
   - 🦎 emoji scattered around screen
   - Animate from center to random positions
   - Fade out automatically after 2 seconds
   - Maximum 20 visible at once

3. **Central Spawn Button**
   - Large circular button with lizard emoji
   - Haptic feedback on tap
   - Slight scale animation when pressed
   - Primary interaction element

## Animations

- **Spawn Animation**: Lizards start at center, move to random position over 2 seconds
- **Button Press**: Slight scale down (0.95x) with haptic click
- **Fade Out**: Lizards fade and scale down in final 0.3 seconds
- **Counter Update**: Numbers update immediately with spawn

## Colors & Materials

- **Background**: Subtle blue-to-purple gradient
- **Stats Panel**: `.thinMaterial` with slight transparency
- **Button**: `.regularMaterial` for glass-like appearance
- **Text**: System colors optimized for watch readability

This creates a clean, simple interface optimized for the Apple Watch's small screen and quick interactions.