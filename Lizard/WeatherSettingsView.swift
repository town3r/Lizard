//
//  WeatherSettingsView.swift
//  Lizard
//
//  Weather settings view with iOS 26 liquid glass styling
//

import SwiftUI

/// Weather settings view for controlling weather conditions and visual effects
struct WeatherSettingsView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    // Weather mode settings
    @AppStorage("weatherAutoMode") private var weatherAutoMode: Bool = true
    @AppStorage("weatherOffMode") private var weatherOffMode: Bool = false
    @AppStorage("manualWeatherCondition") private var manualWeatherConditionRaw: String = "clear"
    
    // Vortex rain settings
    @AppStorage("vortexRainIntensity") private var vortexRainIntensity: Double = 0.7
    @AppStorage("vortexSplashEnabled") private var vortexSplashEnabled: Bool = true
    
    private var manualWeatherCondition: WeatherCondition {
        WeatherConditionUtility.condition(from: manualWeatherConditionRaw)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Weather Mode Section
                weatherModeSection
                
                // Weather Effects Section
                if !weatherOffMode {
                    weatherEffectsSection
                }
                
                // Weather Preview Section
                weatherPreviewSection
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .navigationTitle("Weather Settings")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // MARK: - Weather Mode Section
    
    var weatherModeSection: some View {
        LiquidGlassSection(
            title: "Weather Mode",
            subtitle: "Control how weather conditions are managed",
            systemImage: "cloud.fill"
        ) {
            VStack(spacing: 16) {
                SettingsToggle(
                    title: "Auto Weather",
                    subtitle: "Automatically change weather based on time",
                    systemImage: "clock.fill",
                    isOn: $weatherAutoMode
                )
                .disabled(weatherOffMode)
                
                SettingsToggle(
                    title: "Weather Off",
                    subtitle: "Disable all weather effects",
                    systemImage: "xmark.circle.fill",
                    isOn: $weatherOffMode
                )
                
                if !weatherAutoMode && !weatherOffMode {
                    // Manual Weather Selection
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "hand.point.up.fill")
                                .font(.body)
                                .foregroundStyle(.blue)
                            
                            Text("Manual Weather Selection")
                                .font(.body)
                                .fontWeight(.medium)
                        }
                        
                        Picker("Weather Condition", selection: Binding(
                            get: { manualWeatherCondition },
                            set: { newValue in
                                manualWeatherConditionRaw = WeatherConditionUtility.string(from: newValue)
                            }
                        )) {
                            ForEach(WeatherCondition.allCases.filter { $0 != .none }, id: \.self) { condition in
                                Label(condition.displayName, systemImage: condition.iconName)
                                    .tag(condition)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .background {
                            iOS26LiquidGlass(isPressed: false, size: .small)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Weather Effects Section
    
    var weatherEffectsSection: some View {
        LiquidGlassSection(
            title: "Weather Effects",
            subtitle: "Customize weather visual effects and intensity",
            systemImage: "sparkles"
        ) {
            VStack(spacing: 16) {
                // Rain Intensity Control
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Rain Intensity")
                            .font(.body)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text("\(Int(vortexRainIntensity * 100))%")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background {
                                Capsule()
                                    .fill(.regularMaterial)
                            }
                    }
                    
                    Slider(value: $vortexRainIntensity, in: 0.1...1.0, step: 0.1)
                        .tint(.blue)
                }
                
                // Storm Effects Toggle
                SettingsToggle(
                    title: "Storm Splash Effects",
                    subtitle: "Enable splash and impact effects during storms",
                    systemImage: "drop.circle.fill",
                    isOn: $vortexSplashEnabled
                )
            }
        }
    }
    
    // MARK: - Weather Preview Section
    
    var weatherPreviewSection: some View {
        LiquidGlassSection(
            title: "Weather Conditions",
            subtitle: "Preview and learn about different weather types",
            systemImage: "eye.fill"
        ) {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(WeatherCondition.allCases.filter { $0 != .none }, id: \.self) { condition in
                    weatherPreviewCard(for: condition)
                }
            }
        }
    }
    
    private func weatherPreviewCard(for condition: WeatherCondition) -> some View {
        VStack(spacing: 8) {
            Image(systemName: condition.iconName)
                .font(.title2)
                .foregroundColor(weatherCardColor(for: condition))
                .frame(height: 30)
            
            Text(condition.displayName)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
            
            Text(weatherDescription(for: condition))
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background {
            iOS26LiquidGlass(
                isPressed: !weatherOffMode && !weatherAutoMode && manualWeatherCondition == condition,
                size: .small
            )
        }
        .onTapGesture {
            if !weatherOffMode && !weatherAutoMode {
                manualWeatherConditionRaw = WeatherConditionUtility.string(from: condition)
            }
        }
    }
    
    private func weatherCardColor(for condition: WeatherCondition) -> Color {
        switch condition {
        case .clear:
            return .yellow
        case .partlyCloudy:
            return .orange
        case .cloudy:
            return .gray
        case .rain:
            return .blue
        case .storm:
            return .purple
        case .none:
            return .clear
        }
    }
    
    private func weatherDescription(for condition: WeatherCondition) -> String {
        switch condition {
        case .clear:
            return "Bright sunny sky with excellent visibility"
        case .partlyCloudy:
            return "Mix of sun and clouds with pleasant atmosphere"
        case .cloudy:
            return "Overcast sky with soft, diffused lighting"
        case .rain:
            return "Light to moderate rain with water effects"
        case .storm:
            return "Heavy rain with lightning and thunder"
        case .none:
            return "No weather effects"
        }
    }
}

#Preview {
    NavigationView {
        WeatherSettingsView()
    }
}