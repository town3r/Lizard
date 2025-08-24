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
        case physics = "Main"
        case stats = "Stats"
        case background = "Background"
        case settings = "Settings"
        
        var systemImage: String {
            switch self {
            case .physics: return "lizard.fill"
            case .stats: return "trophy.fill"
            case .background: return "photo.fill"
            case .settings: return "gearshape.fill"
            }
        }
        
        // Animation properties for each tab
        var animationType: AnimationType {
            switch self {
            case .physics: return .bounce
            case .stats: return .rotateScale
            case .background: return .pulse
            case .settings: return .spin
            }
        }
    }
    
    enum AnimationType {
        case bounce
        case rotateScale
        case pulse
        case spin
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Physics Tab - Main lizard physics simulation
            PhysicsTabView()
                .tabItem {
                    AnimatedTabIcon(
                        systemImage: Tab.physics.systemImage,
                        title: Tab.physics.rawValue,
                        isSelected: selectedTab == .physics,
                        animationType: Tab.physics.animationType
                    )
                }
                .tag(Tab.physics)
            
            // Stats Tab - Game Center leaderboards and achievements
            StatsTabView()
                .tabItem {
                    AnimatedTabIcon(
                        systemImage: Tab.stats.systemImage,
                        title: Tab.stats.rawValue,
                        isSelected: selectedTab == .stats,
                        animationType: Tab.stats.animationType
                    )
                }
                .tag(Tab.stats)
            
            // Background Tab - Visual effects and dynamic backgrounds
            BackgroundTabView()
                .tabItem {
                    AnimatedTabIcon(
                        systemImage: Tab.background.systemImage,
                        title: Tab.background.rawValue,
                        isSelected: selectedTab == .background,
                        animationType: Tab.background.animationType
                    )
                }
                .tag(Tab.background)

            // Settings Tab - App configuration and preferences
            SettingsTabView()
                .tabItem {
                    AnimatedTabIcon(
                        systemImage: Tab.settings.systemImage,
                        title: Tab.settings.rawValue,
                        isSelected: selectedTab == .settings,
                        animationType: Tab.settings.animationType
                    )
                }
                .tag(Tab.settings)
        }
        .tabViewStyle(.automatic)
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
