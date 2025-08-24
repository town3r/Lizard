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
            title: "App Details",
            subtitle: "Physics-based iOS game with advanced liquid glass effects",
            systemImage: "apple.logo"
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
            // Audio Settings (Red - first color of rainbow)
            NavigationLink(destination: AudioSettingsView()) {
                SettingsCategoryRow(
                    title: "Audio Settings",
                    subtitle: "Configure sound effects and volume",
                    systemImage: "speaker.wave.3.fill",
                    color: .red
                )
            }
            
            // Physics Settings (Orange)
            NavigationLink(destination: PhysicsSettingsView()) {
                SettingsCategoryRow(
                    title: "Physics Settings",
                    subtitle: "Control lizard behavior and performance",
                    systemImage: "speedometer",
                    color: .orange
                )
            }
            
            // Screen Orientation (Yellow)
            NavigationLink(destination: ScreenOrientationSettingsView()) {
                SettingsCategoryRow(
                    title: "Screen Orientation",
                    subtitle: "Lock orientation for better physics",
                    systemImage: "rotate.3d",
                    color: .yellow
                )
            }
            
            // Visual Settings (Green)
            NavigationLink(destination: VisualSettingsView()) {
                SettingsCategoryRow(
                    title: "Visual Settings",
                    subtitle: "Customize backgrounds and visual effects",
                    systemImage: "paintbrush.fill",
                    color: .green
                )
            }
            
            // Weather Settings (Blue)
            NavigationLink(destination: WeatherSettingsView()) {
                SettingsCategoryRow(
                    title: "Weather Settings",
                    subtitle: "Configure weather effects and conditions",
                    systemImage: "cloud.rain.fill",
                    color: .blue
                )
            }
        }
    }
}

#Preview {
    SettingsTabView()
}
