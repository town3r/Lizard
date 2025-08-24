//
//  MainTabView.swift
//  Lizard
//
//  iOS 26 Beta Tab Bar Navigation with Liquid Glass Effects
//

import SwiftUI

/// Main tab view implementing iOS 26 beta tab bar navigation with liquid glass effects
struct MainTabView: View {
    @State private var selectedTab: Tab = .physics
    
    enum Tab: String, CaseIterable {
        case physics = "Physics"
        case settings = "Settings"
        case stats = "Stats"
        case weather = "Weather"
        
        var systemImage: String {
            switch self {
            case .physics: return "ball.circle.fill"
            case .settings: return "gearshape.fill"
            case .stats: return "trophy.fill"
            case .weather: return "cloud.rain.fill"
            }
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Physics Tab - Main lizard physics simulation
            PhysicsTabView()
                .tabItem {
                    Label(Tab.physics.rawValue, systemImage: Tab.physics.systemImage)
                }
                .tag(Tab.physics)
            
            // Settings Tab - App configuration and preferences
            SettingsTabView()
                .tabItem {
                    Label(Tab.settings.rawValue, systemImage: Tab.settings.systemImage)
                }
                .tag(Tab.settings)
            
            // Stats Tab - Game Center leaderboards and achievements
            StatsTabView()
                .tabItem {
                    Label(Tab.stats.rawValue, systemImage: Tab.stats.systemImage)
                }
                .tag(Tab.stats)
            
            // Weather Tab - Weather controls and visual effects
            WeatherTabView()
                .tabItem {
                    Label(Tab.weather.rawValue, systemImage: Tab.weather.systemImage)
                }
                .tag(Tab.weather)
        }
        .tabViewStyle(.automatic)
        // Enhanced tab bar styling with liquid glass effects
        .preferredColorScheme(nil)
        .onAppear {
            configureTabBarAppearance()
        }
    }
    
    private func configureTabBarAppearance() {
        // Enhanced Tab Bar Customization with Liquid Glass Effects
        let appearance = UITabBarAppearance()
        
        // Enable liquid glass-like effect for tab bar
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.85)
        
        // Enhanced blur configuration for liquid glass effect
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        
        // Enhanced tab item styling
        appearance.selectionIndicatorTintColor = UIColor.systemBlue
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemBlue
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.systemBlue,
            .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.secondaryLabel
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.secondaryLabel,
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
}