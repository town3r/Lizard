//
//  BackgroundTabView.swift
//  Lizard
//
//  Background and environment selection tab with iOS 26 liquid glass styling
//

import SwiftUI

/// Background tab for selecting different dynamic environments
struct BackgroundTabView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    // Background selection settings
    @AppStorage("selectedEnvironment") private var selectedEnvironment: String = "grassyHills"
    @AppStorage("environmentAutoMode") private var environmentAutoMode: Bool = true
    @AppStorage("timeOfDayAutoMode") private var timeOfDayAutoMode: Bool = true
    @AppStorage("manualTimeOfDay") private var manualTimeOfDay: Double = 0.5
    
    private var currentEnvironment: BackgroundEnvironment {
        BackgroundEnvironment.from(selectedEnvironment)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Environment Selection Section
                    environmentSelectionSection
                    
                    // Time of Day Controls
                    timeOfDaySection
                    
                    // Environment Preview Section
                    environmentPreviewSection
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .navigationTitle("Background")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Environment Selection Section
    
    var environmentSelectionSection: some View {
        LiquidGlassSection(
            title: "Environment",
            subtitle: "Choose your dynamic background environment",
            systemImage: "photo.fill"
        ) {
            VStack(spacing: 16) {
                SettingsToggle(
                    title: "Auto Environment",
                    subtitle: "Automatically cycle through environments",
                    systemImage: "arrow.triangle.2.circlepath",
                    isOn: $environmentAutoMode
                )
                
                if !environmentAutoMode {
                    // Manual Environment Selection
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "hand.point.up.fill")
                                .font(.body)
                                .foregroundStyle(.blue)
                            
                            Text("Manual Environment Selection")
                                .font(.body)
                                .fontWeight(.medium)
                        }
                        
                        Picker("Environment", selection: Binding(
                            get: { currentEnvironment },
                            set: { newValue in
                                selectedEnvironment = newValue.rawValue
                            }
                        )) {
                            ForEach(BackgroundEnvironment.allCases, id: \.self) { environment in
                                Label(environment.displayName, systemImage: environment.iconName)
                                    .tag(environment)
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
    
    // MARK: - Time of Day Section
    
    var timeOfDaySection: some View {
        LiquidGlassSection(
            title: "Time of Day",
            subtitle: "Control lighting and atmospheric conditions",
            systemImage: "clock.fill"
        ) {
            VStack(spacing: 16) {
                SettingsToggle(
                    title: "Auto Time",
                    subtitle: "Use real-time lighting and day/night cycle",
                    systemImage: "clock.arrow.circlepath",
                    isOn: $timeOfDayAutoMode
                )
                
                if !timeOfDayAutoMode {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Manual Time")
                                .font(.body)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Text(timeOfDayString(for: manualTimeOfDay))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background {
                                    Capsule()
                                        .fill(.regularMaterial)
                                }
                        }
                        
                        Slider(value: $manualTimeOfDay, in: 0.0...1.0, step: 0.01)
                            .tint(.orange)
                    }
                }
            }
        }
    }
    
    // MARK: - Environment Preview Section
    
    var environmentPreviewSection: some View {
        LiquidGlassSection(
            title: "Environment Preview",
            subtitle: "Explore different dynamic backgrounds and their features",
            systemImage: "eye.fill"
        ) {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(BackgroundEnvironment.allCases, id: \.self) { environment in
                    environmentPreviewCard(for: environment)
                }
            }
        }
    }
    
    private func environmentPreviewCard(for environment: BackgroundEnvironment) -> some View {
        VStack(spacing: 12) {
            Image(systemName: environment.iconName)
                .font(.title)
                .foregroundColor(environmentCardColor(for: environment))
                .frame(height: 40)
            
            Text(environment.displayName)
                .font(.headline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
            
            Text(environment.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background {
            iOS26LiquidGlass(
                isPressed: !environmentAutoMode && currentEnvironment == environment,
                size: .medium
            )
        }
        .onTapGesture {
            if !environmentAutoMode {
                selectedEnvironment = environment.rawValue
            }
        }
    }
    
    private func environmentCardColor(for environment: BackgroundEnvironment) -> Color {
        switch environment {
        case .grassyHills:
            return .green
        case .oceanBeach:
            return .blue
        case .cityStreets:
            return .gray
        case .forestPath:
            return .brown
        case .desertDunes:
            return .orange
        case .mountainPeaks:
            return .purple
        }
    }
    
    private func timeOfDayString(for value: Double) -> String {
        let hour = Int(value * 24)
        let minute = Int((value * 24 - Double(hour)) * 60)
        return String(format: "%02d:%02d", hour, minute)
    }
}

// MARK: - Background Environment Enum

enum BackgroundEnvironment: String, CaseIterable {
    case grassyHills = "grassyHills"
    case oceanBeach = "oceanBeach"
    case cityStreets = "cityStreets"
    case forestPath = "forestPath"
    case desertDunes = "desertDunes"
    case mountainPeaks = "mountainPeaks"
    
    var displayName: String {
        switch self {
        case .grassyHills:
            return "Grassy Hills"
        case .oceanBeach:
            return "Ocean Beach"
        case .cityStreets:
            return "City Streets"
        case .forestPath:
            return "Forest Path"
        case .desertDunes:
            return "Desert Dunes"
        case .mountainPeaks:
            return "Mountain Peaks"
        }
    }
    
    var iconName: String {
        switch self {
        case .grassyHills:
            return "leaf.fill"
        case .oceanBeach:
            return "water.waves"
        case .cityStreets:
            return "building.2.fill"
        case .forestPath:
            return "tree.fill"
        case .desertDunes:
            return "sun.max.fill"
        case .mountainPeaks:
            return "mountain.2.fill"
        }
    }
    
    var description: String {
        switch self {
        case .grassyHills:
            return "Rolling green hills with animated grass and peaceful countryside atmosphere"
        case .oceanBeach:
            return "Scenic oceanside with waves, sandy shores, and seagulls overhead"
        case .cityStreets:
            return "Urban environment with skyscrapers, street lights, and city sounds"
        case .forestPath:
            return "Dense woodland with tall trees, filtered sunlight, and nature sounds"
        case .desertDunes:
            return "Vast sandy landscape with shifting dunes and desert wildlife"
        case .mountainPeaks:
            return "Majestic mountain ranges with snow caps and alpine atmosphere"
        }
    }
    
    static func from(_ string: String) -> BackgroundEnvironment {
        return BackgroundEnvironment(rawValue: string) ?? .grassyHills
    }
}

#Preview {
    BackgroundTabView()
}