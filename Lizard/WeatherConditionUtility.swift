// WeatherConditionUtility.swift
// Shared utilities for weather condition management
import Foundation
import SwiftUI

/// Utility for converting between weather condition strings and enum values
struct WeatherConditionUtility {
    
    /// Convert a string representation to a WeatherCondition enum
    static func condition(from string: String) -> WeatherCondition {
        switch string.lowercased() {
        case "none":
            return .none
        case "clear":
            return .clear
        case "partlycloudy", "partly_cloudy", "partly cloudy":
            return .partlyCloudy
        case "cloudy":
            return .cloudy
        case "rain":
            return .rain
        case "storm":
            return .storm
        case "winter", "snow":
            return .storm // Map winter/snow to storm since winter case doesn't exist
        default:
            return .clear // Default fallback
        }
    }
    
    /// Convert a WeatherCondition enum to its string representation
    static func string(from condition: WeatherCondition) -> String {
        switch condition {
        case .none:
            return "none"
        case .clear:
            return "clear"
        case .partlyCloudy:
            return "partlycloudy"
        case .cloudy:
            return "cloudy"
        case .rain:
            return "rain"
        case .storm:
            return "storm"
        }
    }
    
    /// Get all available weather conditions for UI selection
    static var allConditions: [WeatherCondition] {
        return WeatherCondition.allCases
    }
    
    /// Get weather condition display name for UI
    static func displayName(for condition: WeatherCondition) -> String {
        return condition.displayName
    }
    
    /// Get weather condition icon name for UI
    static func iconName(for condition: WeatherCondition) -> String {
        return condition.iconName
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
    var rawValue: String {
        return WeatherConditionUtility.string(from: self)
    }
    
    static func fromRawValue(_ rawValue: String) -> WeatherCondition? {
        return WeatherConditionUtility.condition(from: rawValue)
    }
}
