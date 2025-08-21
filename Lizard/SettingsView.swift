import SwiftUI

// MARK: - Main Settings View with Navigation

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    private struct Config {
        static let liquidGlassCornerRadius: CGFloat = 28
        static let liquidGlassBlur: CGFloat = 20
        static let sectionSpacing: CGFloat = 24
        static let itemSpacing: CGFloat = 16
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Config.sectionSpacing) {
                    // Header with lizard image
                    VStack(spacing: 8) {
                        Image("lizard")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                        Text("Lizard Settings")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding(.top, 20)

                    // Settings Categories
                    VStack(spacing: Config.itemSpacing) {
                        NavigationLink(destination: ScreenOrientationSettingsView()) {
                            SettingsCategoryRow(
                                title: "Screen Orientation",
                                subtitle: "Lock orientation for better physics",
                                systemImage: "rotate.3d"
                            )
                        }
                        
                        NavigationLink(destination: PhysicsSettingsView()) {
                            SettingsCategoryRow(
                                title: "Physics Settings",
                                subtitle: "Control lizard behavior",
                                systemImage: "speedometer"
                            )
                        }
                        
                        NavigationLink(destination: VisualSettingsView()) {
                            SettingsCategoryRow(
                                title: "Visual Settings",
                                subtitle: "Customize appearance",
                                systemImage: "paintbrush"
                            )
                        }
                        
                        NavigationLink(destination: WeatherSettingsView()) {
                            SettingsCategoryRow(
                                title: "Weather Settings",
                                subtitle: "Rain and environment",
                                systemImage: "cloud.rain"
                            )
                        }
                    }

                    Spacer(minLength: 20)
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
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon container
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.blue.gradient)
                    .frame(width: 44, height: 44)
                
                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundStyle(.white)
            }
            
            VStack(alignment: .leading, spacing: 2) {
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
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
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

                        Text("Lower max lizards if experiencing performance issues")
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
                            
                            Text("Dynamic: Full animated sky with weather effects\nSolid: Simple color background\nGradient: Animated gradient background")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.top, 4)
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
}

// MARK: - Weather Settings

struct WeatherSettingsView: View {
    @AppStorage("weatherEffects") private var weatherEffects: Bool = true
    @AppStorage("windEnabled") private var windEnabled: Bool = false
    @AppStorage("weatherAutoMode") private var weatherAutoMode: Bool = true
    @WeatherConditionStorage(key: "manualWeatherCondition") private var manualWeatherCondition: WeatherCondition
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Weather Mode Section
                LiquidGlassSection(title: "Weather Mode", subtitle: "Control weather condition behavior", systemImage: "cloud.sun") {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Weather Control")
                                        .font(.body)
                                        .fontWeight(.medium)

                                    Text("How weather conditions are determined")
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
                                title: "Auto Weather",
                                subtitle: "Weather changes automatically over time",
                                systemImage: "cloud.sun",
                                isOn: $weatherAutoMode
                            )
                            
                            if !weatherAutoMode {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Weather Condition")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.primary)
                                        .padding(.top, 8)
                                    
                                    Picker("Weather Condition", selection: $manualWeatherCondition) {
                                        Text("Clear").tag(WeatherCondition.clear)
                                        Text("Partly Cloudy").tag(WeatherCondition.partlyCloudy)
                                        Text("Cloudy").tag(WeatherCondition.cloudy)
                                        Text("Rain").tag(WeatherCondition.rain)
                                        Text("Storm").tag(WeatherCondition.storm)
                                        Text("Winter").tag(WeatherCondition.winter)
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                    .frame(height: 120)
                                }
                            }
                        }
                    }
                }
                
                // Weather Effects Section
                LiquidGlassSection(title: "Weather Effects", subtitle: "Rain effects and environmental controls", systemImage: "cloud.rain") {
                    VStack(spacing: 16) {
                        SettingsToggle(
                            title: "Weather Effects",
                            subtitle: "Visual weather enhancements",
                            systemImage: "cloud.drizzle",
                            isOn: $weatherEffects
                        )
                        
                        SettingsToggle(
                            title: "Wind Effects",
                            subtitle: "Horizontal physics influence",
                            systemImage: "wind",
                            isOn: $windEnabled
                        )
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
                                value: manualWeatherCondition.displayName,
                                systemImage: manualWeatherCondition.iconName
                            )
                        }
                        
                        PerformanceInfoRow(
                            title: "Effects",
                            value: weatherEffects ? "Enabled" : "Disabled",
                            systemImage: weatherEffects ? "checkmark.circle" : "xmark.circle"
                        )
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

extension WeatherCondition {
    var rawValue: String {
        switch self {
        case .none: return "none"
        case .clear: return "clear"
        case .partlyCloudy: return "partlyCloudy"
        case .cloudy: return "cloudy"
        case .rain: return "rain"
        case .storm: return "storm"
        case .winter: return "winter"
        }
    }
}

#Preview {
    SettingsView()
}
