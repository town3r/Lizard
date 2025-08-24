//
//  SettingsTabView.swift
//  Lizard
//
//  Settings and preferences tab with iOS 26 liquid glass styling
//

import SwiftUI

/// Settings tab for app configuration and preferences
struct SettingsTabView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // App Header
                    appHeaderSection
                    
                    // Settings Categories
                    settingsCategoriesSection
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - App Header Section
    
    var appHeaderSection: some View {
        LiquidGlassSection(
            title: "Lizard",
            subtitle: "Physics-based iOS game with advanced liquid glass effects",
            systemImage: "🦎"
        ) {
            VStack(spacing: 16) {
                // App Icon and Info
                HStack(spacing: 16) {
                    Image("lizard")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.regularMaterial)
                        }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Lizard")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("iOS 26 Physics Simulation")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text("Version 2.0.0 • Build 26")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                    
                    Spacer()
                }
                
                // Quick Description
                Text("Experience realistic lizard physics with device-controlled gravity, GameCenter integration, and iOS 26's advanced liquid glass interface.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
            }
        }
    }
    
    // MARK: - Settings Categories Section
    
    var settingsCategoriesSection: some View {
        VStack(spacing: 16) {
            // Physics Settings
            NavigationLink(destination: PhysicsSettingsView()) {
                SettingsCategoryRow(
                    title: "Physics Settings",
                    subtitle: "Control lizard behavior and performance",
                    systemImage: "speedometer",
                    color: .green
                )
            }
            
            // Screen Orientation
            NavigationLink(destination: ScreenOrientationSettingsView()) {
                SettingsCategoryRow(
                    title: "Screen Orientation",
                    subtitle: "Lock orientation for better physics",
                    systemImage: "rotate.3d",
                    color: .blue
                )
            }
            
            // Audio Settings
            NavigationLink(destination: AudioSettingsView()) {
                SettingsCategoryRow(
                    title: "Audio Settings",
                    subtitle: "Configure sound effects and volume",
                    systemImage: "speaker.wave.3.fill",
                    color: .purple
                )
            }
            
            // Visual Settings
            NavigationLink(destination: VisualSettingsView()) {
                SettingsCategoryRow(
                    title: "Visual Settings",
                    subtitle: "Customize backgrounds and visual effects",
                    systemImage: "paintbrush.fill",
                    color: .orange
                )
            }
            
            // Performance Settings
            NavigationLink(destination: PerformanceSettingsView()) {
                SettingsCategoryRow(
                    title: "Performance",
                    subtitle: "Monitor and optimize app performance",
                    systemImage: "chart.line.uptrend.xyaxis",
                    color: .red
                )
            }
            
            // About & Support
            NavigationLink(destination: AboutSupportView()) {
                SettingsCategoryRow(
                    title: "About & Support",
                    subtitle: "App information and support resources",
                    systemImage: "info.circle.fill",
                    color: .cyan
                )
            }
        }
    }
}

// MARK: - Settings Category Row Component

struct SettingsCategoryRow: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 30)
            
            // Text Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(20)
        .background {
            iOS26LiquidGlass(isPressed: false, size: .medium)
        }
    }
}

// MARK: - Individual Settings Views

struct PhysicsSettingsView: View {
    @AppStorage("maxLizards") private var maxLizards: Int = 300
    @AppStorage("lizardSize") private var lizardSize: Double = 80.0
    @AppStorage("randomSizeLizards") private var randomSizeLizards: Bool = false
    @AppStorage("rainIntensity") private var rainIntensity: Int = 15
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                LiquidGlassSection(title: "Physics Settings", subtitle: "Control lizard behavior and performance", systemImage: "speedometer") {
                    VStack(spacing: 16) {
                        // Max Lizards Slider
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Max Lizards")
                                    .font(.body)
                                    .fontWeight(.medium)
                                Spacer()
                                Text("\(maxLizards)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: .init(get: { Double(maxLizards) }, set: { maxLizards = Int($0) }), in: 50...500, step: 10)
                        }
                        
                        // Lizard Size Slider
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Lizard Size")
                                    .font(.body)
                                    .fontWeight(.medium)
                                Spacer()
                                Text("\(Int(lizardSize))pt")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: $lizardSize, in: 40...120, step: 5)
                        }
                        
                        // Random Size Toggle
                        SettingsToggle(
                            title: "Random Sizes",
                            subtitle: "Enable variable lizard sizes",
                            systemImage: "shuffle",
                            isOn: $randomSizeLizards
                        )
                        
                        // Rain Intensity
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Rain Intensity")
                                    .font(.body)
                                    .fontWeight(.medium)
                                Spacer()
                                Text("\(rainIntensity)/sec")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: .init(get: { Double(rainIntensity) }, set: { rainIntensity = Int($0) }), in: 5...30, step: 1)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("Physics Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct AudioSettingsView: View {
    @AppStorage("soundEffectsEnabled") private var soundEffectsEnabled: Bool = true
    @AppStorage("lizardSoundEnabled") private var lizardSoundEnabled: Bool = true
    @AppStorage("thunderSoundEnabled") private var thunderSoundEnabled: Bool = true
    @AppStorage("soundVolume") private var soundVolume: Double = 1.0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                LiquidGlassSection(title: "Audio Settings", subtitle: "Configure sound effects and volume", systemImage: "speaker.wave.3.fill") {
                    VStack(spacing: 16) {
                        SettingsToggle(
                            title: "Sound Effects",
                            subtitle: "Enable all sound effects",
                            systemImage: "speaker.fill",
                            isOn: $soundEffectsEnabled
                        )
                        
                        SettingsToggle(
                            title: "Lizard Sounds",
                            subtitle: "Play sounds when lizards spawn",
                            systemImage: "🦎",
                            isOn: $lizardSoundEnabled
                        )
                        .disabled(!soundEffectsEnabled)
                        
                        SettingsToggle(
                            title: "Thunder Sounds",
                            subtitle: "Play thunder during storms",
                            systemImage: "cloud.bolt.fill",
                            isOn: $thunderSoundEnabled
                        )
                        .disabled(!soundEffectsEnabled)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Volume")
                                    .font(.body)
                                    .fontWeight(.medium)
                                Spacer()
                                Text("\(Int(soundVolume * 100))%")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: $soundVolume, in: 0...1, step: 0.1)
                                .disabled(!soundEffectsEnabled)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("Audio Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct VisualSettingsView: View {
    @AppStorage("backgroundType") private var backgroundType: String = "dynamic"
    @AppStorage("showFPSCounter") private var showFPSCounter: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                LiquidGlassSection(title: "Visual Settings", subtitle: "Customize backgrounds and visual effects", systemImage: "paintbrush.fill") {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Background Style")
                                .font(.body)
                                .fontWeight(.medium)
                            
                            Picker("Background Style", selection: $backgroundType) {
                                Text("Dynamic").tag("dynamic")
                                Text("Solid").tag("solid")
                                Text("Gradient").tag("gradient")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        SettingsToggle(
                            title: "FPS Counter",
                            subtitle: "Show performance metrics",
                            systemImage: "gauge.with.dots.needle.67percent",
                            isOn: $showFPSCounter
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("Visual Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct PerformanceSettingsView: View {
    @AppStorage("maxLizards") private var maxLizards: Int = 300
    @AppStorage("rainIntensity") private var rainIntensity: Int = 15
    @AppStorage("showFPSCounter") private var showFPSCounter: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
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
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("Performance")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct PerformanceInfoRow: View {
    let title: String
    let value: String
    let systemImage: String
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(value)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct AboutSupportView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                LiquidGlassSection(title: "About Lizard", subtitle: "App information and version details", systemImage: "info.circle.fill") {
                    VStack(spacing: 16) {
                        Text("Lizard is a physics-based iOS game that showcases advanced liquid glass effects and realistic gravity simulation. Built with SwiftUI and SpriteKit for iOS 26.")
                            .font(.body)
                            .multilineTextAlignment(.leading)
                        
                        HStack {
                            Text("Version:")
                                .fontWeight(.medium)
                            Spacer()
                            Text("2.0.0 (Build 26)")
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Text("Platform:")
                                .fontWeight(.medium)
                            Spacer()
                            Text("iOS 26.0+")
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Text("Engine:")
                                .fontWeight(.medium)
                            Spacer()
                            Text("SpriteKit + SwiftUI")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("About & Support")
        .navigationBarTitleDisplayMode(.large)
    }
}

// Copy ScreenOrientationSettingsView from the original SettingsView if needed
struct ScreenOrientationSettingsView: View {
    @AppStorage("orientationLock") private var orientationLock: String = "unlocked"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                LiquidGlassSection(title: "Screen Orientation", subtitle: "Lock orientation for better physics", systemImage: "rotate.3d") {
                    VStack(spacing: 12) {
                        OrientationOption(
                            title: "Unlocked",
                            subtitle: "Free rotation",
                            systemImage: "rotate.3d",
                            value: "unlocked",
                            currentValue: $orientationLock
                        )
                        
                        OrientationOption(
                            title: "Portrait",
                            subtitle: "Vertical orientation",
                            systemImage: "iphone",
                            value: "portrait",
                            currentValue: $orientationLock
                        )
                        
                        OrientationOption(
                            title: "Landscape Left",
                            subtitle: "Left-side gravity",
                            systemImage: "iphone.landscape",
                            value: "landscapeLeft",
                            currentValue: $orientationLock
                        )
                        
                        OrientationOption(
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

struct OrientationOption: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let value: String
    @Binding var currentValue: String
    
    var body: some View {
        Button {
            currentValue = value
            NotificationCenter.default.post(name: .orientationLockChanged, object: nil)
        } label: {
            HStack {
                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundStyle(.blue)
                    .frame(width: 30)
                
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
                
                if currentValue == value {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.body)
                        .foregroundStyle(.blue)
                }
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingsTabView()
}