import SwiftUI

// MARK: - Main Settings View with Navigation

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

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
                        
                        NavigationLink(destination: AudioSettingsView()) {
                            SettingsCategoryRow(
                                title: "Audio Settings",
                                subtitle: "Sound effects and audio controls",
                                systemImage: "speaker.wave.2",
                                color: .pink
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
                        
                        NavigationLink(destination: WeatherControlSettingsView()) {
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
                        SettingsSliderInt(
                            title: "Max Lizards",
                            subtitle: "Performance limit",
                            value: $maxLizards,
                            range: 50...1000,
                            step: 25,
                            formatter: { "\($0)" }
                        )

                        SettingsSlider(
                            title: "Lizard Size",
                            subtitle: "Base size in points",
                            value: $lizardSize,
                            range: 40...120,
                            step: 5,
                            formatter: { "\(Int($0))pt" }
                        )
                        
                        SettingsSliderInt(
                            title: "Rain Intensity",
                            subtitle: "Lizards per second when raining",
                            value: $rainIntensity,
                            range: 5...30,
                            step: 1,
                            formatter: { "\($0)" }
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

// MARK: - Audio Settings

struct AudioSettingsView: View {
    @AppStorage("soundEffectsEnabled") private var soundEffectsEnabled: Bool = true
    @AppStorage("lizardSoundEnabled") private var lizardSoundEnabled: Bool = true
    @AppStorage("thunderSoundEnabled") private var thunderSoundEnabled: Bool = true
    @AppStorage("soundVolume") private var soundVolume: Double = 1.0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                LiquidGlassSection(title: "Sound Effects", subtitle: "Control game audio and sound effects", systemImage: "speaker.wave.2") {
                    VStack(spacing: 16) {
                        SettingsToggle(
                            title: "Sound Effects",
                            subtitle: "Enable or disable all sound effects",
                            systemImage: "speaker.wave.3",
                            isOn: $soundEffectsEnabled
                        )
                        
                        if soundEffectsEnabled {
                            Divider()
                                .padding(.vertical, 8)
                            
                            SettingsToggle(
                                title: "Lizard Sounds",
                                subtitle: "Play sound when lizards spawn",
                                systemImage: "lizard",
                                isOn: $lizardSoundEnabled
                            )
                            
                            SettingsToggle(
                                title: "Thunder Sounds",
                                subtitle: "Play thunder during storms",
                                systemImage: "cloud.bolt",
                                isOn: $thunderSoundEnabled
                            )
                            
                            SettingsSlider(
                                title: "Volume",
                                subtitle: "Overall sound effect volume",
                                value: $soundVolume,
                                range: 0...1,
                                step: 0.05,
                                formatter: { String(format: "%.0f%%", $0 * 100) }
                            )
                        }
                    }
                }
                
                LiquidGlassSection(title: "Audio Info", subtitle: "Current audio configuration", systemImage: "info.circle") {
                    VStack(spacing: 16) {
                        PerformanceInfoRow(
                            title: "Sound Effects",
                            value: soundEffectsEnabled ? "Enabled" : "Disabled",
                            systemImage: soundEffectsEnabled ? "checkmark.circle" : "xmark.circle"
                        )
                        
                        if soundEffectsEnabled {
                            PerformanceInfoRow(
                                title: "Lizard Sounds",
                                value: lizardSoundEnabled ? "On" : "Off",
                                systemImage: lizardSoundEnabled ? "speaker.wave.2" : "speaker.slash"
                            )
                            
                            PerformanceInfoRow(
                                title: "Volume Level",
                                value: String(format: "%.0f%%", soundVolume * 100),
                                systemImage: "speaker.wave.1"
                            )
                        }
                        
                        Text("Sound effects enhance the gameplay experience with audio feedback when lizards spawn and during weather events.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("Audio Settings")
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
    @AppStorage("customGradientColor1") private var customGradientColor1Data: Data = {
        do {
            return try JSONEncoder().encode(CodableColor(color: .blue))
        } catch {
            return Data()
        }
    }()
    @AppStorage("customGradientColor2") private var customGradientColor2Data: Data = {
        do {
            return try JSONEncoder().encode(CodableColor(color: .purple))
        } catch {
            return Data()
        }
    }()
    @AppStorage("customGradientColor3") private var customGradientColor3Data: Data = {
        do {
            return try JSONEncoder().encode(CodableColor(color: .pink))
        } catch {
            return Data()
        }
    }()
    @AppStorage("gradientDirection") private var gradientDirection: String = "topToBottom"
    @AppStorage("gradientAnimationEnabled") private var gradientAnimationEnabled: Bool = true
    @AppStorage("gradientAnimationSpeed") private var gradientAnimationSpeed: Double = 1.0
    
    // Helper computed properties for gradient colors with safe decoding
    private var customGradientColor1: Color {
        get {
            do {
                let codableColor = try JSONDecoder().decode(CodableColor.self, from: customGradientColor1Data)
                return codableColor.color
            } catch {
                return .blue // Safe fallback
            }
        }
    }
    
    private var customGradientColor2: Color {
        get {
            do {
                let codableColor = try JSONDecoder().decode(CodableColor.self, from: customGradientColor2Data)
                return codableColor.color
            } catch {
                return .purple // Safe fallback
            }
        }
    }
    
    private var customGradientColor3: Color {
        get {
            do {
                let codableColor = try JSONDecoder().decode(CodableColor.self, from: customGradientColor3Data)
                return codableColor.color
            } catch {
                return .pink // Safe fallback
            }
        }
    }
    
    // Helper functions for setting custom colors with safe encoding
    private func setCustomGradientColor1(_ color: Color) {
        do {
            customGradientColor1Data = try JSONEncoder().encode(CodableColor(color: color))
        } catch {
            print("Failed to encode gradient color 1: \(error)")
        }
    }
    
    private func setCustomGradientColor2(_ color: Color) {
        do {
            customGradientColor2Data = try JSONEncoder().encode(CodableColor(color: color))
        } catch {
            print("Failed to encode gradient color 2: \(error)")
        }
    }
    
    private func setCustomGradientColor3(_ color: Color) {
        do {
            customGradientColor3Data = try JSONEncoder().encode(CodableColor(color: color))
        } catch {
            print("Failed to encode gradient color 3: \(error)")
        }
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

// MARK: - Weather Settings

struct WeatherControlSettingsView: View {
    @AppStorage("weatherAutoMode") private var weatherAutoMode: Bool = true
    @AppStorage("weatherOffMode") private var weatherOffMode: Bool = false
    @AppStorage("manualWeatherCondition") private var manualWeatherConditionRaw: String = "clear"
    
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
                                                Text("Clear").tag("clear")
                                                Text("Partly Cloudy").tag("partlyCloudy")
                                                Text("Cloudy").tag("cloudy")
                                                Text("Rain").tag("rain")
                                                Text("Storm").tag("storm")
                                                Text("Snow").tag("snow")
                                            }
                                            .pickerStyle(MenuPickerStyle())
                                        }
                                    }
                                    .padding(.top, 8)
                                }
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

// MARK: - Helper Components

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
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundStyle(.blue)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            
            content
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct SettingsSlider: View {
    let title: String
    let subtitle: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let formatter: (Double) -> String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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
            
            Slider(value: $value, in: range, step: step) {
                Text(title)
            }
            .tint(.blue)
        }
    }
}

struct SettingsSliderInt: View {
    let title: String
    let subtitle: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let step: Int
    let formatter: (Int) -> String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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
            
            Slider(value: Binding(
                get: { Double(value) },
                set: { value = Int($0) }
            ), in: Double(range.lowerBound)...Double(range.upperBound), step: Double(step)) {
                Text(title)
            }
            .tint(.blue)
        }
    }
}

struct SettingsToggle: View {
    let title: String
    let subtitle: String
    let systemImage: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 24, height: 24)
            
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
                .labelsHidden()
        }
    }
}

struct OrientationButton: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let value: String
    @Binding var currentValue: String
    
    var body: some View {
        Button {
            currentValue = value
        } label: {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.title3)
                    .foregroundStyle(currentValue == value ? .white : .blue)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(currentValue == value ? .white : .primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(currentValue == value ? .white.opacity(0.8) : .secondary)
                }
                
                Spacer()
                
                if currentValue == value {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.white)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(currentValue == value ? .blue : .clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(currentValue == value ? .clear : .blue.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct ColorPickerRow: View {
    let title: String
    @Binding var color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .fontWeight(.medium)
            
            Spacer()
            
            ColorPicker("", selection: $color)
                .labelsHidden()
                .frame(width: 40, height: 40)
        }
    }
}

struct GradientPresetButton: View {
    let title: String
    let colors: [Color]
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                LinearGradient(
                    colors: colors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: 20, height: 20)
                .clipShape(Circle())
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}

struct PerformanceInfoRow: View {
    let title: String
    let value: String
    let systemImage: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(value)
                    .font(.caption)
                    .foregroundStyle(.blue)
            }
            
            Spacer()
        }
    }
}

// MARK: - Supporting Types

struct CodableColor: Codable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
    
    init(color: Color) {
        // Extract color components using UIColor
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
    SettingsView()
}
