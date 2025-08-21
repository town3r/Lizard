//
//  WeatherControlView.swift
//  Lizard
//
//  Created by Enhanced Weather System
//

import SwiftUI

struct WeatherControlView: View {
    @AppStorage("weatherAutoMode") private var weatherAutoMode: Bool = true
    @AppStorage("weatherOffMode") private var weatherOffMode: Bool = false
    @AppStorage("manualWeatherCondition") private var manualWeatherConditionRaw: String = "clear"
    @Environment(\.dismiss) private var dismiss
    
    let onWeatherChange: (WeatherCondition) -> Void
    let onModeChange: (Bool) -> Void
    
    private var currentWeatherCondition: WeatherCondition {
        if weatherOffMode {
            return .none
        }
        switch manualWeatherConditionRaw {
        case "clear": return .clear
        case "partlyCloudy": return .partlyCloudy
        case "cloudy": return .cloudy
        case "rain": return .rain
        case "storm": return .storm
        case "winter": return .winter
        default: return .clear
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("Weather Control")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("Done") {
                    dismiss()
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.blue)
            }
            .padding(.horizontal)
            
            // Auto/Manual/Off Toggle
            VStack(alignment: .leading, spacing: 12) {
                Text("Mode")
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                VStack(spacing: 12) {
                    HStack(spacing: 16) {
                        Button {
                            weatherAutoMode = true
                            weatherOffMode = false
                            onModeChange(true)
                        } label: {
                            HStack {
                                Image(systemName: weatherAutoMode && !weatherOffMode ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(weatherAutoMode && !weatherOffMode ? .blue : .secondary)
                                Text("Automatic")
                                    .foregroundStyle(weatherAutoMode && !weatherOffMode ? .primary : .secondary)
                            }
                        }
                        .buttonStyle(.plain)
                        
                        Spacer()
                    }
                    
                    HStack(spacing: 16) {
                        Button {
                            weatherAutoMode = false
                            weatherOffMode = false
                            onModeChange(false)
                        } label: {
                            HStack {
                                Image(systemName: !weatherAutoMode && !weatherOffMode ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(!weatherAutoMode && !weatherOffMode ? .blue : .secondary)
                                Text("Manual")
                                    .foregroundStyle(!weatherAutoMode && !weatherOffMode ? .primary : .secondary)
                            }
                        }
                        .buttonStyle(.plain)
                        
                        Spacer()
                    }
                    
                    HStack(spacing: 16) {
                        Button {
                            weatherOffMode = true
                            weatherAutoMode = false
                            onModeChange(false)
                            onWeatherChange(.none)
                        } label: {
                            HStack {
                                Image(systemName: weatherOffMode ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(weatherOffMode ? .blue : .secondary)
                                Text("Off")
                                    .foregroundStyle(weatherOffMode ? .primary : .secondary)
                            }
                        }
                        .buttonStyle(.plain)
                        
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
            
            // Current Condition Display
            VStack(alignment: .leading, spacing: 12) {
                Text("Current Condition")
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                HStack {
                    Image(systemName: currentWeatherCondition.iconName)
                        .font(.title)
                        .foregroundStyle(weatherOffMode ? Color.secondary : .blue)
                    
                    Text(currentWeatherCondition.displayName)
                        .font(.title3)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    if weatherOffMode {
                        Text("Off")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.gray.opacity(0.2))
                            .foregroundStyle(.secondary)
                            .clipShape(Capsule())
                    } else if weatherAutoMode {
                        Text("Auto")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.blue.opacity(0.2))
                            .foregroundStyle(.blue)
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background {
                    iOS26LiquidGlass(isPressed: false, size: .medium)
                }
            }
            .padding(.horizontal)
            
            // Manual Weather Selection (only visible in manual mode)
            if !weatherAutoMode && !weatherOffMode {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Weather")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(WeatherCondition.allCases.filter { $0 != .none }, id: \.self) { condition in
                            WeatherConditionButton(
                                condition: condition,
                                isSelected: condition == currentWeatherCondition
                            ) {
                                selectWeatherCondition(condition)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            Spacer()
            
            // Info text
            Text(getInfoText())
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.top)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(radius: 20)
        .animation(.easeInOut(duration: 0.3), value: weatherAutoMode)
        .animation(.easeInOut(duration: 0.3), value: weatherOffMode)
    }
    
    private func getInfoText() -> String {
        if weatherOffMode {
            return "Weather effects are disabled"
        } else if weatherAutoMode {
            return "Weather changes automatically every 30 seconds"
        } else {
            return "Weather will remain as selected until changed"
        }
    }
    
    private func selectWeatherCondition(_ condition: WeatherCondition) {
        switch condition {
        case .none: manualWeatherConditionRaw = "none"
        case .clear: manualWeatherConditionRaw = "clear"
        case .partlyCloudy: manualWeatherConditionRaw = "partlyCloudy"
        case .cloudy: manualWeatherConditionRaw = "cloudy"
        case .rain: manualWeatherConditionRaw = "rain"
        case .storm: manualWeatherConditionRaw = "storm"
        case .winter: manualWeatherConditionRaw = "winter"
        }
        
        onWeatherChange(condition)
    }
}

private struct WeatherConditionButton: View {
    let condition: WeatherCondition
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: condition.iconName)
                    .font(.title2)
                    .foregroundStyle(isSelected ? .white : .blue)
                
                Text(condition.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background {
                if isSelected {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.blue)
                } else {
                    iOS26LiquidGlass(isPressed: false, size: .small)
                }
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    WeatherControlView(
        onWeatherChange: { _ in },
        onModeChange: { _ in }
    )
    .frame(height: 500)
}
