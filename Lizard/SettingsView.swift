import SwiftUI

// MARK: - Main Settings View with Navigation

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    let onFireworksTrigger: () -> Void

    private struct Config {
        static let liquidGlassCornerRadius: CGFloat = 28
        static let liquidGlassBlur: CGFloat = 20
        static let sectionSpacing: CGFloat = 16  // Reduced from 24
        static let itemSpacing: CGFloat = 12     // Reduced from 16
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Config.sectionSpacing) {
                    // Header with lizard image
                    VStack(spacing: 6) {  // Reduced from 8
                        Image("lizard")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)  // Reduced from 60x60
                            .clipShape(Circle())
                        Text("Lizard Settings")
                            .font(.title2)  // Changed from .title
                            .fontWeight(.bold)
                    }
                    .padding(.top, 16)  // Reduced from 20

                    // Settings Categories
                    VStack(spacing: Config.itemSpacing) {
                        NavigationLink(destination: ScreenOrientationSettingsView()) {
                            SettingsCategoryRow(
                                title: "Screen Orientation",
                                subtitle: "Lock orientation for better physics",
                                systemImage: "rotate.3d",
                                color: .blue
                            )
                        }
                        
                        NavigationLink(destination: PhysicsSettingsView()) {
                            SettingsCategoryRow(
                                title: "Physics Settings",
                                subtitle: "Control lizard behavior and performance",
                                systemImage: "speedometer",
                                color: .green
                            )
                        }
                        
                        NavigationLink(destination: VisualSettingsView()) {
                            SettingsCategoryRow(
                                title: "Visual Settings",
                                subtitle: "Customize appearance",
                                systemImage: "paintbrush",
                                color: .purple
                            )
                        }
                        
                        NavigationLink(destination: FireworkSettingsView()) {
                            SettingsCategoryRow(
                                title: "Firework Settings",
                                subtitle: "Customize firework effects and behavior",
                                systemImage: "fireworks",
                                color: .pink
                            )
                        }
                        
                        NavigationLink(destination: WeatherSettingsView()) {
                            SettingsCategoryRow(
                                title: "Weather Settings",
                                subtitle: "Rain and environment",
                                systemImage: "cloud.rain",
                                color: .orange
                            )
                        }
                    }

                    Spacer(minLength: 16)  // Reduced from 20
                }
                .padding(.horizontal, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        onFireworksTrigger()
                        dismiss()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle()
                                        .stroke(.white.opacity(0.2), lineWidth: 1)
                                )
                            
                            Image(systemName: "fireworks")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.primary)
                        }
                    }
                    .accessibilityLabel("Trigger fireworks show")
                    .accessibilityHint("Tap to start a fireworks celebration")
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Settings Category Row

struct SettingsCategoryRow: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {  // Reduced from 16
            // Icon container
            ZStack {
                RoundedRectangle(cornerRadius: 10)  // Reduced from 12
                    .fill(color.gradient)
                    .frame(width: 36, height: 36)  // Reduced from 44x44
                
                Image(systemName: systemImage)
                    .font(.title3)  // Changed from .title2
                    .foregroundStyle(.white)
            }
            
            VStack(alignment: .leading, spacing: 1) {  // Reduced from 2
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(12)  // Reduced from 16
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))  // Reduced from 16
        .overlay(
            RoundedRectangle(cornerRadius: 14)  // Reduced from 16
                .stroke(.white.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Screen Orientation Settings

struct ScreenOrientationSettingsView: View {
    @AppStorage("orientationLock") private var orientationLock: String = "unlocked"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                LiquidGlassSection(title: "Screen Orientation", subtitle: "Lock orientation for better physics", systemImage: "rotate.3d") {
                    VStack(spacing: 16) {
                        OrientationButton(
                            title: "Unlocked",
                            subtitle: "Free rotation",
                            systemImage: "rotate.3d",
                            value: "unlocked",
                            currentValue: $orientationLock
                        )

                        OrientationButton(
                            title: "Portrait",
                            subtitle: "Vertical gravity",
                            systemImage: "iphone",
                            value: "portrait",
                            currentValue: $orientationLock
                        )

                        OrientationButton(
                            title: "Landscape Left",
                            subtitle: "Left-side gravity",
                            systemImage: "iphone.landscape",
                            value: "landscapeLeft",
                            currentValue: $orientationLock
                        )

                        OrientationButton(
                            title: "Landscape Right",
                            subtitle: "Right-side gravity",
                            systemImage: "iphone.landscape",
                            value: "landscapeRight",
                            currentValue: $orientationLock
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("Screen Orientation")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Physics Settings

struct PhysicsSettingsView: View {
    @AppStorage("maxLizards") private var maxLizards: Int = 300
    @AppStorage("lizardSize") private var lizardSize: Double = 80.0
    @AppStorage("randomSizeLizards") private var randomSizeLizards: Bool = false
    @AppStorage("showFPSCounter") private var showFPSCounter: Bool = false
    @AppStorage("rainIntensity") private var rainIntensity: Int = 15
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                LiquidGlassSection(title: "Physics Settings", subtitle: "Control lizard behavior and performance", systemImage: "speedometer") {
                    VStack(spacing: 16) {
                        SettingsSlider(
                            title: "Max Lizards",
                            subtitle: "Performance limit",
                            value: $maxLizards,
                            range: 50...500,
                            step: 25,
                            formatter: { "\(Int($0))" }
                        )

                        SettingsSlider(
                            title: "Lizard Size",
                            subtitle: "Base size in points",
                            value: $lizardSize,
                            range: 40...120,
                            step: 5,
                            formatter: { "\(Int($0))pt" }
                        )
                        
                        SettingsSlider(
                            title: "Rain Intensity",
                            subtitle: "Lizards per second when raining",
                            value: $rainIntensity,
                            range: 5...30,
                            step: 1,
                            formatter: { "\(Int($0))" }
                        )

                        SettingsToggle(
                            title: "Random Sizes",
                            subtitle: "Vary lizard sizes",
                            systemImage: "shuffle",
                            isOn: $randomSizeLizards
                        )
                    }
                }
                
                LiquidGlassSection(title: "Performance Info", subtitle: "Performance monitoring and configuration", systemImage: "chart.line.uptrend.xyaxis") {
                    VStack(spacing: 16) {
                        PerformanceInfoRow(
                            title: "Current Limit",
                            value: "\(maxLizards) lizards",
                            systemImage: "speedometer"
                        )

                        PerformanceInfoRow(
                            title: "Target FPS",
                            value: "60 fps",
                            systemImage: "timer"
                        )
                        
                        PerformanceInfoRow(
                            title: "Rain Rate",
                            value: "\(rainIntensity)/sec",
                            systemImage: "cloud.rain"
                        )

                        SettingsToggle(
                            title: "FPS Counter",
                            subtitle: "Show performance metrics",
                            systemImage: "gauge.with.dots.needle.67percent",
                            isOn: $showFPSCounter
                        )
                        .onChange(of: showFPSCounter) { _, newValue in
                            NotificationCenter.default.post(
                                name: .fpsCounterToggled,
                                object: nil,
                                userInfo: ["enabled": newValue]
                            )
                        }

                        Text("Lower max lizards if experiencing performance issues.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("Physics Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Visual Settings

struct VisualSettingsView: View {
    @AppStorage("backgroundType") private var backgroundType: String = "dynamic"
    @AppStorage("timeOfDayAutoMode") private var timeOfDayAutoMode: Bool = true
    @AppStorage("manualTimeOfDay") private var manualTimeOfDay: Double = 0.5 // 0.5 = noon
    
    // Gradient customization settings
    @AppStorage("gradientStyle") private var gradientStyle: String = "timeOfDay"
    @AppStorage("customGradientColor1") private var customGradientColor1Data: Data = try! JSONEncoder().encode(CodableColor(color: .blue))
    @AppStorage("customGradientColor2") private var customGradientColor2Data: Data = try! JSONEncoder().encode(CodableColor(color: .purple))
    @AppStorage("customGradientColor3") private var customGradientColor3Data: Data = try! JSONEncoder().encode(CodableColor(color: .pink))
    @AppStorage("gradientDirection") private var gradientDirection: String = "topToBottom"
    @AppStorage("gradientAnimationEnabled") private var gradientAnimationEnabled: Bool = true
    @AppStorage("gradientAnimationSpeed") private var gradientAnimationSpeed: Double = 1.0
    
    // Helper computed properties for gradient colors
    private var customGradientColor1: Color {
        get {
            (try? JSONDecoder().decode(CodableColor.self, from: customGradientColor1Data))?.color ?? .blue
        }
    }
    
    private var customGradientColor2: Color {
        get {
            (try? JSONDecoder().decode(CodableColor.self, from: customGradientColor2Data))?.color ?? .purple
        }
    }
    
    private var customGradientColor3: Color {
        get {
            (try? JSONDecoder().decode(CodableColor.self, from: customGradientColor3Data))?.color ?? .pink
        }
    }
    
    // Helper functions for setting custom colors
    private func setCustomGradientColor1(_ color: Color) {
        customGradientColor1Data = try! JSONEncoder().encode(CodableColor(color: color))
    }
    
    private func setCustomGradientColor2(_ color: Color) {
        customGradientColor2Data = try! JSONEncoder().encode(CodableColor(color: color))
    }
    
    private func setCustomGradientColor3(_ color: Color) {
        customGradientColor3Data = try! JSONEncoder().encode(CodableColor(color: color))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                LiquidGlassSection(title: "Visual Settings", subtitle: "Customize appearance and display", systemImage: "paintbrush") {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Background Style")
                                        .font(.body)
                                        .fontWeight(.medium)

                                    Text("Visual background effects")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Text(backgroundType.capitalized)
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.blue)
                            }

                            Picker("Background Style", selection: $backgroundType) {
                                Text("Dynamic").tag("dynamic")
                                Text("Solid").tag("solid")
                                Text("Gradient").tag("gradient")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            Text("Dynamic: Full animated sky with weather effects\nSolid: Simple color background\nGradient: Customizable gradient background")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.top, 4)
                        }
                    }
                }
                
                // Gradient Customization Section (only show when gradient is selected)
                if backgroundType == "gradient" {
                    LiquidGlassSection(title: "Gradient Settings", subtitle: "Customize gradient appearance", systemImage: "circle.fill.square.fill") {
                        VStack(spacing: 16) {
                            // Gradient Style Picker
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Gradient Style")
                                            .font(.body)
                                            .fontWeight(.medium)

                                        Text("How gradient colors are determined")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    Text(gradientStyleDisplayName)
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.blue)
                                }

                                Picker("Gradient Style", selection: $gradientStyle) {
                                    Text("Time of Day").tag("timeOfDay")
                                    Text("Custom Colors").tag("custom")
                                    Text("Dynamic Preset").tag("preset")
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            
                            // Custom Colors Section (only show for custom style)
                            if gradientStyle == "custom" {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Custom Colors")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    
                                    // Color Pickers
                                    VStack(spacing: 12) {
                                        ColorPickerRow(
                                            title: "Top Color",
                                            color: Binding(
                                                get: { customGradientColor1 },
                                                set: { setCustomGradientColor1($0) }
                                            )
                                        )
                                        
                                        ColorPickerRow(
                                            title: "Middle Color",
                                            color: Binding(
                                                get: { customGradientColor2 },
                                                set: { setCustomGradientColor2($0) }
                                            )
                                        )
                                        
                                        ColorPickerRow(
                                            title: "Bottom Color",
                                            color: Binding(
                                                get: { customGradientColor3 },
                                                set: { setCustomGradientColor3($0) }
                                            )
                                        )
                                    }
                                    
                                    // Quick Preset Buttons
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Quick Presets")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        
                                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                            GradientPresetButton(title: "Ocean", colors: [.blue, .cyan, .teal]) {
                                                applyGradientPreset(colors: [.blue, .cyan, .teal])
                                            }
                                            
                                            GradientPresetButton(title: "Sunset", colors: [.orange, .pink, .purple]) {
                                                applyGradientPreset(colors: [.orange, .pink, .purple])
                                            }
                                            
                                            GradientPresetButton(title: "Forest", colors: [.green, .mint, .yellow]) {
                                                applyGradientPreset(colors: [.green, .mint, .yellow])
                                            }
                                            
                                            GradientPresetButton(title: "Night", colors: [.purple, .indigo, .black]) {
                                                applyGradientPreset(colors: [.purple, .indigo, .black])
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // Gradient Direction
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Gradient Direction")
                                            .font(.body)
                                            .fontWeight(.medium)

                                        Text("Direction of gradient flow")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    Text(gradientDirectionDisplayName)
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.blue)
                                }

                                Picker("Gradient Direction", selection: $gradientDirection) {
                                    Text("Top to Bottom").tag("topToBottom")
                                    Text("Left to Right").tag("leftToRight")
                                    Text("Diagonal ↘").tag("topLeadingToBottomTrailing")
                                    Text("Diagonal ↙").tag("topTrailingToBottomLeading")
                                    Text("Radial").tag("radial")
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(height: 120)
                            }
                            
                            // Animation Settings
                            VStack(alignment: .leading, spacing: 12) {
                                SettingsToggle(
                                    title: "Animated Gradient",
                                    subtitle: "Smooth color transitions",
                                    systemImage: "waveform.path",
                                    isOn: $gradientAnimationEnabled
                                )
                                
                                if gradientAnimationEnabled {
                                    SettingsSlider(
                                        title: "Animation Speed",
                                        subtitle: "How fast colors change",
                                        value: $gradientAnimationSpeed,
                                        range: 0.1...3.0,
                                        step: 0.1,
                                        formatter: { String(format: "%.1fx", $0) }
                                    )
                                }
                            }
                        }
                    }
                }
                
                // Time of Day Section
                LiquidGlassSection(title: "Time of Day", subtitle: "Control lighting and sky appearance", systemImage: "sun.max") {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Time Control")
                                        .font(.body)
                                        .fontWeight(.medium)

                                    Text("How time of day is determined")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Text(timeOfDayAutoMode ? "Auto" : "Manual")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.blue)
                            }

                            SettingsToggle(
                                title: "Auto Time",
                                subtitle: "Follow actual time of day",
                                systemImage: "clock.arrow.circlepath",
                                isOn: $timeOfDayAutoMode
                            )
                            
                            if !timeOfDayAutoMode {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Time of Day")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundStyle(.primary)
                                        
                                        Spacer()
                                        
                                        Text(timeOfDayDisplayText)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundStyle(.blue)
                                    }
                                    .padding(.top, 8)
                                    
                                    Slider(value: $manualTimeOfDay, in: 0...1, step: 0.01) {
                                        Text("Time of Day")
                                    } minimumValueLabel: {
                                        Image(systemName: "moon.fill")
                                            .foregroundStyle(.secondary)
                                    } maximumValueLabel: {
                                        Image(systemName: "moon.fill")
                                            .foregroundStyle(.secondary)
                                    }
                                    .tint(.blue)
                                    
                                    HStack {
                                        Text("Midnight")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                        
                                        Spacer()
                                        
                                        Text("Noon")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                        
                                        Spacer()
                                        
                                        Text("Midnight")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("Visual Settings")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // Helper to convert time progress to display text
    private var timeOfDayDisplayText: String {
        let hours24 = Int(manualTimeOfDay * 24)
        let minutes = Int((manualTimeOfDay * 24 - Double(hours24)) * 60)
        
        let period = hours24 < 12 ? "AM" : "PM"
        let hours12 = hours24 == 0 ? 12 : (hours24 > 12 ? hours24 - 12 : hours24)
        
        return String(format: "%d:%02d %@", hours12, minutes, period)
    }
    
    // Helper computed properties for gradient settings
    private var gradientStyleDisplayName: String {
        switch gradientStyle {
        case "timeOfDay": return "Time of Day"
        case "custom": return "Custom Colors"
        case "preset": return "Dynamic Preset"
        default: return "Unknown"
        }
    }
    
    private var gradientDirectionDisplayName: String {
        switch gradientDirection {
        case "topToBottom": return "Top to Bottom"
        case "leftToRight": return "Left to Right"
        case "topLeadingToBottomTrailing": return "Diagonal ↘"
        case "topTrailingToBottomLeading": return "Diagonal ↙"
        case "radial": return "Radial"
        default: return "Unknown"
        }
    }
    
    // Function to apply gradient presets
    private func applyGradientPreset(colors: [Color]) {
        if colors.count >= 3 {
            setCustomGradientColor1(colors[0])
            setCustomGradientColor2(colors[1])
            setCustomGradientColor3(colors[2])
        }
    }
}

// MARK: - Firework Settings

struct FireworkSettingsView: View {
    @AppStorage("fireworkDensity") private var fireworkDensity: Double = 0.5
    @AppStorage("fireworkDuration") private var fireworkDuration: Double = 5.0
    @AppStorage("fireworkColorScheme") private var fireworkColorScheme: String = "vibrant"
    @AppStorage("fireworkSoundEffects") private var fireworkSoundEffects: Bool = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                LiquidGlassSection(title: "Firework Settings", subtitle: "Customize firework effects and behavior", systemImage: "fireworks") {
                    VStack(spacing: 16) {
                        SettingsSlider(
                            title: "Firework Density",
                            subtitle: "Number of fireworks spawned",
                            value: $fireworkDensity,
                            range: 0...1,
                            step: 0.1,
                            formatter: { String(format: "%.1f", $0) }
                        )

                        SettingsSlider(
                            title: "Duration",
                            subtitle: "How long fireworks last",
                            value: $fireworkDuration,
                            range: 1...10,
                            step: 1,
                            formatter: { "\($0)s" }
                        )
                        
                        SettingsToggle(
                            title: "Sound Effects",
                            subtitle: "Play sounds during fireworks",
                            systemImage: "speaker.wave.3",
                            isOn: $fireworkSoundEffects
                        )
                    }
                }
                
                LiquidGlassSection(title: "Color Schemes", subtitle: "Customize firework color effects", systemImage: "paintbrush") {
                    VStack(spacing: 16) {
                        ColorSchemeButton(
                            title: "Vibrant",
                            isSelected: fireworkColorScheme == "vibrant"
                        ) {
                            fireworkColorScheme = "vibrant"
                        }

                        ColorSchemeButton(
                            title: "Pastel",
                            isSelected: fireworkColorScheme == "pastel"
                        ) {
                            fireworkColorScheme = "pastel"
                        }

                        ColorSchemeButton(
                            title: "Neon",
                            isSelected: fireworkColorScheme == "neon"
                        ) {
                            fireworkColorScheme = "neon"
                        }

                        ColorSchemeButton(
                            title: "Custom",
                            isSelected: fireworkColorScheme == "custom"
                        ) {
                            fireworkColorScheme = "custom"
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("Firework Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ColorSchemeButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? .white : .primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.white)
                }
            }
            .padding(12)
            .background(
                isSelected ? .blue : .clear,
                in: RoundedRectangle(cornerRadius: 12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? .clear : .secondary.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Weather Settings

struct WeatherSettingsView: View {
    @AppStorage("weatherAutoMode") private var weatherAutoMode: Bool = true
    @AppStorage("weatherOffMode") private var weatherOffMode: Bool = false
    @AppStorage("manualWeatherCondition") private var manualWeatherConditionRaw: String = "clear"
    @AppStorage("vortexRainIntensity") private var vortexRainIntensity: Double = 0.7
    @AppStorage("vortexSplashEnabled") private var vortexSplashEnabled: Bool = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Weather Mode Section
                LiquidGlassSection(title: "Weather Control", subtitle: "Control weather effects and conditions", systemImage: "cloud.sun") {
                    VStack(spacing: 16) {
                        // Weather On/Off Toggle
                        SettingsToggle(
                            title: "Weather Effects",
                            subtitle: "Enable or disable all weather effects",
                            systemImage: "cloud.drizzle",
                            isOn: Binding(
                                get: { !weatherOffMode },
                                set: { weatherOffMode = !$0 }
                            )
                        )
                        
                        // Only show weather controls if weather is enabled
                        if !weatherOffMode {
                            Divider()
                                .padding(.vertical, 8)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Weather Mode")
                                            .font(.body)
                                            .fontWeight(.medium)

                                        Text(weatherAutoMode ? "Weather changes automatically every 30 seconds" : "Weather stays as selected until changed")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    Text(weatherAutoMode ? "Auto" : "Manual")
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.blue)
                                }

                                SettingsToggle(
                                    title: "Automatic Weather",
                                    subtitle: "Weather changes automatically over time",
                                    systemImage: "clock.arrow.2.circlepath",
                                    isOn: $weatherAutoMode
                                )
                                
                                // Manual weather condition picker (only shown when automatic is off)
                                if !weatherAutoMode {
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text("Weather Condition")
                                                    .font(.body)
                                                    .fontWeight(.medium)
                                                
                                                Text("Choose the weather condition")
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                            }
                                            
                                            Spacer()
                                            
                                            Picker("Weather Condition", selection: $manualWeatherConditionRaw) {
                                                ForEach(WeatherCondition.allCases, id: \.rawValue) { condition in
                                                    HStack {
                                                        Image(systemName: condition.iconName)
                                                            .foregroundStyle(.blue)
                                                        Text(condition.displayName)
                                                    }
                                                    .tag(condition.rawValue)
                                                }
                                            }
                                            .pickerStyle(MenuPickerStyle())
                                        }
                                    }
                                    .padding(.top, 8)
                                }
                                
                                // Vortex Rain Intensity Slider
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Rain Effect Intensity")
                                        .font(.body)
                                    Slider(value: $vortexRainIntensity, in: 0.2...1.5, step: 0.05) {
                                        Text("Rain Intensity")
                                    }
                                    .accentColor(.blue)
                                    Text(String(format: "%.2f", vortexRainIntensity))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                // Vortex Splash Toggle
                                SettingsToggle(
                                    title: "Storm Splash Effect",
                                    subtitle: "Show splash particles during storms",
                                    systemImage: "drop.fill",
                                    isOn: $vortexSplashEnabled
                                )
                            }
                        }
                    }
                }
                
                // Weather Info Section
                LiquidGlassSection(title: "Weather Info", subtitle: "Current weather configuration", systemImage: "info.circle") {
                    VStack(spacing: 16) {
                        PerformanceInfoRow(
                            title: "Mode",
                            value: weatherAutoMode ? "Automatic" : "Manual",
                            systemImage: weatherAutoMode ? "cloud.sun" : "hand.point.up"
                        )
                        
                        if !weatherAutoMode {
                            PerformanceInfoRow(
                                title: "Condition",
                                value: WeatherConditionUtility.condition(from: manualWeatherConditionRaw).displayName,
                                systemImage: WeatherConditionUtility.condition(from: manualWeatherConditionRaw).iconName
                            )
                        }
                        
                        PerformanceInfoRow(
                            title: "Weather Effects",
                            value: !weatherOffMode ? "Enabled" : "Disabled",
                            systemImage: !weatherOffMode ? "checkmark.circle" : "xmark.circle"
                        )
                        
                        Text("Weather effects include rain, snow, storms, clouds, and atmospheric animations.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("Weather Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Supporting Views

struct LiquidGlassSection<Content: View>: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let content: Content

    init(title: String, subtitle: String, systemImage: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.headline)
                    .foregroundStyle(.blue)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            content
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28))
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct OrientationButton: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let value: String
    @Binding var currentValue: String
    
    @State private var isApplying = false

    var isSelected: Bool {
        currentValue == value
    }

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                isApplying = true
            }
            
            currentValue = value
            
            // Post notification with slight delay to show visual feedback
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NotificationCenter.default.post(name: .orientationLockChanged, object: nil)
                
                // Reset applying state after orientation change
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isApplying = false
                    }
                }
            }
        } label: {
            HStack(spacing: 16) {
                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundStyle(isSelected ? .white : .primary)
                    .frame(width: 24)
                    .rotationEffect(.degrees(isApplying ? 360 : 0))
                    .animation(.easeInOut(duration: 0.5), value: isApplying)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(isSelected ? .white : .primary)

                    Text(isApplying ? "Applying..." : subtitle)
                        .font(.caption)
                        .foregroundStyle(isSelected ? .white.opacity(0.8) : .secondary)
                        .animation(.easeInOut(duration: 0.3), value: isApplying)
                }

                Spacer()

                if isSelected && !isApplying {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.white)
                } else if isApplying {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: isSelected ? .white : .blue))
                        .scaleEffect(0.8)
                }
            }
            .padding(16)
            .background(
                isSelected ? .blue : .clear,
                in: RoundedRectangle(cornerRadius: 16)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? .clear : .secondary.opacity(0.3), lineWidth: 1)
            )
            .contentShape(Rectangle())
        }
        .disabled(isApplying)
    }
}

struct SettingsSlider<T: BinaryFloatingPoint>: View where T.Stride: BinaryFloatingPoint {
    let title: String
    let subtitle: String
    @Binding var value: T
    let range: ClosedRange<T>
    let step: T.Stride
    let formatter: (T) -> String

    init(title: String, subtitle: String, value: Binding<T>, range: ClosedRange<T>, step: T.Stride, formatter: @escaping (T) -> String) {
        self.title = title
        self.subtitle = subtitle
        self._value = value
        self.range = range
        self.step = step
        self.formatter = formatter
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(formatter(value))
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
            }

            Slider(value: $value, in: range, step: step)
                .tint(.blue)
        }
    }
}

// Integer version of SettingsSlider
extension SettingsSlider where T == Double {
    init(title: String, subtitle: String, value: Binding<Int>, range: ClosedRange<Int>, step: Int, formatter: @escaping (Double) -> String) {
        self.title = title
        self.subtitle = subtitle
        self._value = Binding(
            get: { Double(value.wrappedValue) },
            set: { value.wrappedValue = Int($0) }
        )
        self.range = Double(range.lowerBound)...Double(range.upperBound)
        self.step = Double(step)
        self.formatter = formatter
    }
}

struct SettingsToggle: View {
    let title: String
    let subtitle: String
    let systemImage: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
    }
}

struct PerformanceInfoRow: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(.green)
                .frame(width: 24)

            Text(title)
                .font(.body)
                .fontWeight(.medium)

            Spacer()

            Text(value)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundStyle(.green)
        }
    }
}

// MARK: - Gradient Customization Supporting Views

struct ColorPickerRow: View {
    let title: String
    @Binding var color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Text(title)
                .font(.body)
                .fontWeight(.medium)
            
            Spacer()
            
            ColorPicker("", selection: $color)
                .labelsHidden()
                .frame(width: 44, height: 44)
                .background(color, in: RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.primary.opacity(0.2), lineWidth: 1)
                )
        }
        .padding(.vertical, 4)
    }
}

struct GradientPresetButton: View {
    let title: String
    let colors: [Color]
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                // Gradient preview
                LinearGradient(
                    gradient: Gradient(colors: colors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.primary.opacity(0.2), lineWidth: 1)
                )
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
            }
            .padding(12)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.primary.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - CodableColor for AppStorage

struct CodableColor: Codable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
    
    init(color: Color) {
        let uiColor = UIColor(color)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        self.red = Double(r)
        self.green = Double(g)
        self.blue = Double(b)
        self.alpha = Double(a)
    }
    
    var color: Color {
        Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}

#Preview {
    SettingsView(onFireworksTrigger: {})
}
