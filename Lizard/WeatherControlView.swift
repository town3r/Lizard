//
//  WeatherControlView.swift
//  Lizard
//
//  Created by Enhanced Weather System
//

import SwiftUI

/// Weather control panel for adjusting weather conditions
struct WeatherControlView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Weather mode settings
    @AppStorage("weatherAutoMode") private var weatherAutoMode: Bool = true
    @AppStorage("weatherOffMode") private var weatherOffMode: Bool = false
    @AppStorage("manualWeatherCondition") private var manualWeatherConditionRaw: String = "clear"
    
    // Vortex rain settings
    @AppStorage("vortexRainIntensity") private var vortexRainIntensity: Double = 0.7
    @AppStorage("vortexSplashEnabled") private var vortexSplashEnabled: Bool = true
    
    private var manualWeatherCondition: WeatherCondition {
        get { WeatherConditionUtility.condition(from: manualWeatherConditionRaw) }
        set { manualWeatherConditionRaw = WeatherConditionUtility.string(from: newValue) }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Weather Mode") {
                    Toggle("Auto Weather", isOn: $weatherAutoMode)
                        .disabled(weatherOffMode)
                    
                    Toggle("Weather Off", isOn: $weatherOffMode)
                    
                    if !weatherAutoMode && !weatherOffMode {
                        Picker("Manual Weather", selection: .constant(manualWeatherCondition)) {
                            ForEach(WeatherCondition.allCases, id: \.self) { condition in
                                Label(condition.displayName, systemImage: condition.iconName)
                                    .tag(condition)
                            }
                        }
                        .onChange(of: manualWeatherCondition) { _, newValue in
                            manualWeatherConditionRaw = WeatherConditionUtility.string(from: newValue)
                        }
                    }
                }
                
                if !weatherOffMode {
                    Section("Rain Vortex Effects") {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Rain Intensity")
                                Spacer()
                                Text("\(Int(vortexRainIntensity * 100))%")
                                    .foregroundColor(.secondary)
                            }
                            Slider(value: $vortexRainIntensity, in: 0.1...1.0, step: 0.1)
                        }
                        
                        Toggle("Storm Splash Effects", isOn: $vortexSplashEnabled)
                    }
                    
                    Section("Weather Effects Preview") {
                        weatherPreviewGrid
                    }
                }
            }
            .navigationTitle("Weather Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var weatherPreviewGrid: some View {
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
    
    private func weatherPreviewCard(for condition: WeatherCondition) -> some View {
        VStack(spacing: 8) {
            Image(systemName: condition.iconName)
                .font(.title2)
                .foregroundColor(weatherCardColor(for: condition))
                .frame(height: 30)
            
            Text(condition.displayName)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
            
            if condition == .rain || condition == .storm {
                Text("Rain: \(Int(vortexRainIntensity * 100))%")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                if condition == .storm && vortexSplashEnabled {
                    Text("+ Splash")
                        .font(.caption2)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    manualWeatherCondition == condition && !weatherAutoMode && !weatherOffMode
                        ? .blue
                        : .clear,
                    lineWidth: 2
                )
        )
        .onTapGesture {
            if !weatherOffMode {
                weatherAutoMode = false
                manualWeatherConditionRaw = WeatherConditionUtility.string(from: condition)
            }
        }
    }
    
    private func weatherCardColor(for condition: WeatherCondition) -> Color {
        switch condition {
        case .none:
            return .gray
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
        }
    }
}

#Preview {
    WeatherControlView()
}
