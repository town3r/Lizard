// WeatherConditionUtility.swift
// Shared utilities for weather condition management
import Foundation
import SwiftUI

/// Utility for converting between WeatherCondition enum and string storage
enum WeatherConditionUtility {
    
    /// Convert string to WeatherCondition enum
    static func condition(from string: String) -> WeatherCondition {
        switch string {
        case "none": return .none
        case "clear": return .clear
        case "partlyCloudy": return .partlyCloudy
        case "cloudy": return .cloudy
        case "rain": return .rain
        case "storm": return .storm
        case "winter": return .winter
        default: return .clear
        }
    }
    
    /// Convert WeatherCondition enum to string
    static func string(from condition: WeatherCondition) -> String {
        switch condition {
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

/// Property wrapper for AppStorage with WeatherCondition
@propertyWrapper
struct WeatherConditionStorage: DynamicProperty {
    private let key: String
    private let defaultValue: WeatherCondition
    
    @AppStorage private var rawValue: String
    
    init(key: String, defaultValue: WeatherCondition = .clear) {
        self.key = key
        self.defaultValue = defaultValue
        self._rawValue = AppStorage(wrappedValue: defaultValue.rawValue, key)
    }
    
    var wrappedValue: WeatherCondition {
        get {
            WeatherCondition.fromRawValue(rawValue) ?? defaultValue
        }
        nonmutating set {
            rawValue = newValue.rawValue
        }
    }
    
    var projectedValue: Binding<WeatherCondition> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}

extension WeatherCondition {
    static func fromRawValue(_ rawValue: String) -> WeatherCondition? {
        switch rawValue {
        case "none": return WeatherCondition.none
        case "clear": return .clear
        case "partlyCloudy": return .partlyCloudy
        case "cloudy": return .cloudy
        case "rain": return .rain
        case "storm": return .storm
        case "winter": return .winter
        default: return nil
        }
    }
}
