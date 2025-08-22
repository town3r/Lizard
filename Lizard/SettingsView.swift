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
                            range: 50...1000,
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

// MARK: - Firework Settings

struct FireworkSettingsView: View {
    @AppStorage("fireworkEnabled") private var fireworkEnabled: Bool = true
    @AppStorage("fireworkIntensity") private var fireworkIntensity: Double = 0.5
    // Remove the problematic color encoding - use simple string instead
    @AppStorage("fireworkColorScheme") private var fireworkColorScheme: String = "red"
    
    // Additional firework customization options
    @AppStorage("fireworkDuration") private var fireworkDuration: Double = 3.0
    @AppStorage("fireworkParticleCount") private var fireworkParticleCount: Int = 100
    @AppStorage("fireworkExplosionPattern") private var fireworkExplosionPattern: String = "burst"
    @AppStorage("fireworkTriggerMode") private var fireworkTriggerMode: String = "manual"
    @AppStorage("fireworkAutoInterval") private var fireworkAutoInterval: Double = 10.0
    @AppStorage("fireworkShowLength") private var fireworkShowLength: Double = 5.0
    @AppStorage("fireworkTrailEnabled") private var fireworkTrailEnabled: Bool = true
    @AppStorage("fireworkGlowEnabled") private var fireworkGlowEnabled: Bool = true
    @AppStorage("fireworkSoundEnabled") private var fireworkSoundEnabled: Bool = true
    @AppStorage("fireworkMultiColor") private var fireworkMultiColor: Bool = false
    @AppStorage("fireworkGravityAffected") private var fireworkGravityAffected: Bool = true
    @AppStorage("fireworkFadeSpeed") private var fireworkFadeSpeed: Double = 1.0
    @AppStorage("fireworkScale") private var fireworkScale: Double = 1.0
    @AppStorage("fireworkPreset") private var fireworkPreset: String = "classic"
    
    // Helper computed property for firework color - simple and fast
    private var fireworkColor: Color {
        switch fireworkColorScheme {
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "yellow": return .yellow
        case "purple": return .purple
        case "orange": return .orange
        case "pink": return .pink
        default: return .red
        }
    }
    
    // Helper function for setting firework color - simple and fast
    private func setFireworkColor(_ color: Color) {
        // Convert Color to string - fast and simple
        if color == .red { fireworkColorScheme = "red" }
        else if color == .blue { fireworkColorScheme = "blue" }
        else if color == .green { fireworkColorScheme = "green" }
        else if color == .yellow { fireworkColorScheme = "yellow" }
        else if color == .purple { fireworkColorScheme = "purple" }
        else if color == .orange { fireworkColorScheme = "orange" }
        else if color == .pink { fireworkColorScheme = "pink" }
        else { fireworkColorScheme = "red" }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                basicControlsSection
                
                if fireworkEnabled {
                    appearanceSection
                    behaviorSection
                }
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("Firework Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - View Components
    
    private var basicControlsSection: some View {
        LiquidGlassSection(title: "Basic Controls", subtitle: "Enable and control firework effects", systemImage: "fireworks") {
            VStack(spacing: 16) {
                SettingsToggle(
                    title: "Enable Fireworks",
                    subtitle: "Turn firework effects on or off",
                    systemImage: "sparkles",
                    isOn: $fireworkEnabled
                )
                
                if fireworkEnabled {
                    basicControlsSliders
                }
            }
        }
    }
    
    private var basicControlsSliders: some View {
        Group {
            SettingsSlider(
                title: "Overall Intensity",
                subtitle: "Master intensity control",
                value: $fireworkIntensity,
                range: 0.1...2.0,
                step: 0.1,
                formatter: { String(format: "%.1fx", $0) }
            )
            
            SettingsSlider(
                title: "Scale",
                subtitle: "Size of firework effects",
                value: $fireworkScale,
                range: 0.5...3.0,
                step: 0.1,
                formatter: { String(format: "%.1fx", $0) }
            )
        }
    }
    
    private var appearanceSection: some View {
        LiquidGlassSection(title: "Appearance", subtitle: "Customize visual effects and colors", systemImage: "paintpalette") {
            VStack(spacing: 16) {
                colorPickerSection
                appearanceToggles
                fadeSpeedSlider
            }
        }
    }
    
    private var colorPickerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Primary Color")
                .font(.headline)
            HStack {
                ForEach(["red", "blue", "green", "yellow", "purple", "orange", "pink"], id: \.self) { colorName in
                    Button {
                        fireworkColorScheme = colorName
                    } label: {
                        Circle()
                            .fill(getColorFromName(colorName))
                            .frame(width: 30, height: 30)
                            .overlay(
                                Circle()
                                    .stroke(fireworkColorScheme == colorName ? Color.primary : Color.clear, lineWidth: 2)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private var appearanceToggles: some View {
        Group {
            SettingsToggle(
                title: "Multi-Color Mode",
                subtitle: "Use rainbow colors instead of single color",
                systemImage: "rainbow",
                isOn: $fireworkMultiColor
            )
            
            SettingsToggle(
                title: "Particle Trails",
                subtitle: "Show trailing effects behind particles",
                systemImage: "line.diagonal",
                isOn: $fireworkTrailEnabled
            )
            
            SettingsToggle(
                title: "Glow Effects",
                subtitle: "Add soft glow around particles",
                systemImage: "sun.max",
                isOn: $fireworkGlowEnabled
            )
        }
    }
    
    private var fadeSpeedSlider: some View {
        SettingsSlider(
            title: "Fade Speed",
            subtitle: "How quickly particles fade out",
            value: $fireworkFadeSpeed,
            range: 0.3...3.0,
            step: 0.1,
            formatter: { String(format: "%.1fx", $0) }
        )
    }
    
    private var behaviorSection: some View {
        LiquidGlassSection(title: "Behavior", subtitle: "Control timing and physics", systemImage: "timer") {
            VStack(spacing: 16) {
                behaviorSliders
                behaviorToggles
            }
        }
    }
    
    private var behaviorSliders: some View {
        Group {
            SettingsSlider(
                title: "Duration",
                subtitle: "How long fireworks last",
                value: $fireworkDuration,
                range: 1.0...8.0,
                step: 0.5,
                formatter: { String(format: "%.1f sec", $0) }
            )
            
            SettingsSlider(
                title: "Show Length",
                subtitle: "Total duration of firework display",
                value: $fireworkShowLength,
                range: 2.0...30.0,
                step: 1.0,
                formatter: { String(format: "%.0f sec", $0) }
            )
            
            SettingsSlider(
                title: "Particle Count",
                subtitle: "Number of particles per explosion",
                value: Binding(
                    get: { Double(fireworkParticleCount) },
                    set: { fireworkParticleCount = Int($0) }
                ),
                range: 25...300,
                step: 25,
                formatter: { "\(Int($0))" }
            )
        }
    }
    
    private var behaviorToggles: some View {
        Group {
            SettingsToggle(
                title: "Gravity Effects",
                subtitle: "Particles affected by device gravity",
                systemImage: "arrow.down.circle",
                isOn: $fireworkGravityAffected
            )
            
            SettingsToggle(
                title: "Sound Effects",
                subtitle: "Play explosion sounds",
                systemImage: "speaker.wave.2",
                isOn: $fireworkSoundEnabled
            )
        }
    }
    
    // Helper function to get Color from string name
    private func getColorFromName(_ name: String) -> Color {
        switch name {
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "yellow": return .yellow
        case "purple": return .purple
        case "orange": return .orange
        case "pink": return .pink
        default: return .red
        }
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

// MARK: - Firework Customization Supporting Views

struct FireworkPresetButton: View {
    let title: String
    let description: String
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: systemImage)
                        .font(.title2)
                        .foregroundStyle(.blue)
                        .frame(width: 24, height: 24)
                    
                    Spacer()
                }
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
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
