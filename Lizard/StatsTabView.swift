//
//  StatsTabView.swift
//  Lizard
//
//  Game Center stats and achievements tab with iOS 26 liquid glass styling
//

import SwiftUI
import GameKit

/// Stats tab for displaying Game Center leaderboards and achievements
struct StatsTabView: View {
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage("totalLizardsSpawned") private var totalSpawned = 0
    @AppStorage("mainButtonTaps") private var mainButtonTaps = 0
    
    @State private var isAuthenticated = false
    @State private var playerDisplayName = ""
    @State private var showGameCenterDashboard = false
    
    // Achievement progress tracking
    @State private var achievement100Progress: Double = 0
    @State private var achievement500Progress: Double = 0
    @State private var tap100Progress: Double = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Player Status Section
                    playerStatusSection
                    
                    // Quick Stats Section
                    quickStatsSection
                    
                    // Achievements Section
                    achievementsSection
                    
                    // Leaderboards Section
                    leaderboardsSection
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .navigationTitle("Stats")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            updateAuthenticationStatus()
            updateAchievementProgress()
        }
        .onChange(of: totalSpawned) { _, _ in
            updateAchievementProgress()
        }
        .onChange(of: mainButtonTaps) { _, _ in
            updateAchievementProgress()
        }
    }
    
    // MARK: - Player Status Section
    
    var playerStatusSection: some View {
        LiquidGlassSection(
            title: "Game Center",
            subtitle: isAuthenticated ? "Signed in as \(playerDisplayName)" : "Sign in to track progress",
            systemImage: "gamecontroller.fill"
        ) {
            VStack(spacing: 16) {
                if isAuthenticated {
                    // Authenticated status
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.green)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Connected to Game Center")
                                .font(.body)
                                .fontWeight(.medium)
                            
                            Text(playerDisplayName)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    
                    // Game Center Dashboard Button
                    iOS26LiquidGlassButton(
                        title: "Open Game Center",
                        font: .system(size: 16, weight: .semibold),
                        style: .primary
                    ) {
                        GameCenterManager.shared.presentLeaderboards()
                    }
                } else {
                    // Not authenticated
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.title2)
                            .foregroundStyle(.orange)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Not Connected")
                                .font(.body)
                                .fontWeight(.medium)
                            
                            Text("Sign in to sync achievements and leaderboards")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    
                    // Sign In Button
                    iOS26LiquidGlassButton(
                        title: "Sign In to Game Center",
                        font: .system(size: 16, weight: .semibold),
                        style: .primary
                    ) {
                        authenticateWithGameCenter()
                    }
                }
            }
        }
    }
    
    // MARK: - Quick Stats Section
    
    var quickStatsSection: some View {
        LiquidGlassSection(
            title: "Quick Stats",
            subtitle: "Your lizard spawning performance",
            systemImage: "chart.bar.fill"
        ) {
            VStack(spacing: 16) {
                StatRow(
                    title: "Total Lizards Spawned",
                    value: "\(totalSpawned)",
                    systemImage: "🦎",
                    color: .green
                )
                
                StatRow(
                    title: "Button Taps",
                    value: "\(mainButtonTaps)",
                    systemImage: "hand.tap.fill",
                    color: .blue
                )
                
                StatRow(
                    title: "Efficiency Rate",
                    value: mainButtonTaps > 0 ? String(format: "%.1f%%", (Double(totalSpawned) / Double(mainButtonTaps)) * 100) : "0%",
                    systemImage: "speedometer",
                    color: .orange
                )
            }
        }
    }
    
    // MARK: - Achievements Section
    
    var achievementsSection: some View {
        LiquidGlassSection(
            title: "Achievements",
            subtitle: "Unlock rewards by reaching milestones",
            systemImage: "trophy.fill"
        ) {
            VStack(spacing: 16) {
                AchievementRow(
                    title: "First 100 Lizards",
                    description: "Spawn your first 100 lizards",
                    progress: achievement100Progress,
                    isCompleted: totalSpawned >= 100,
                    systemImage: "100.circle.fill"
                )
                
                AchievementRow(
                    title: "Lizard Master",
                    description: "Spawn 500 lizards",
                    progress: achievement500Progress,
                    isCompleted: totalSpawned >= 500,
                    systemImage: "500.circle.fill"
                )
                
                AchievementRow(
                    title: "Tap Champion",
                    description: "Tap the button 100 times",
                    progress: tap100Progress,
                    isCompleted: mainButtonTaps >= 100,
                    systemImage: "hand.tap.fill"
                )
            }
        }
    }
    
    // MARK: - Leaderboards Section
    
    var leaderboardsSection: some View {
        LiquidGlassSection(
            title: "Leaderboards",
            subtitle: "Compare your stats with other players",
            systemImage: "list.number"
        ) {
            VStack(spacing: 12) {
                LeaderboardRow(
                    title: "Total Lizards Spawned",
                    currentValue: totalSpawned,
                    systemImage: "🦎"
                ) {
                    GameCenterManager.shared.presentLeaderboards(leaderboardID: "total_lizards_spawned")
                }
                
                LeaderboardRow(
                    title: "Button Taps",
                    currentValue: mainButtonTaps,
                    systemImage: "hand.tap.fill"
                ) {
                    GameCenterManager.shared.presentLeaderboards(leaderboardID: "total_button_taps")
                }
            }
        }
    }
}

// MARK: - Private Methods

private extension StatsTabView {
    func updateAuthenticationStatus() {
        isAuthenticated = GKLocalPlayer.local.isAuthenticated
        playerDisplayName = GKLocalPlayer.local.displayName
    }
    
    func updateAchievementProgress() {
        achievement100Progress = min(Double(totalSpawned) / 100.0, 1.0)
        achievement500Progress = min(Double(totalSpawned) / 500.0, 1.0)
        tap100Progress = min(Double(mainButtonTaps) / 100.0, 1.0)
    }
    
    func authenticateWithGameCenter() {
        GameCenterManager.shared.authenticate { [weak topViewController = topViewController()] in
            return topViewController
        }
        
        // Update status after authentication attempt
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            updateAuthenticationStatus()
        }
    }
    
    func topViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return nil }
        
        var topController = window.rootViewController
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        return topController
    }
}

// MARK: - Supporting Views

struct StatRow: View {
    let title: String
    let value: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(color)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct AchievementRow: View {
    let title: String
    let description: String
    let progress: Double
    let isCompleted: Bool
    let systemImage: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(isCompleted ? .yellow : .secondary)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    if isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.body)
                            .foregroundStyle(.green)
                    }
                }
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: isCompleted ? .green : .blue))
                    .frame(height: 4)
            }
        }
        .padding(.vertical, 4)
    }
}

struct LeaderboardRow: View {
    let title: String
    let currentValue: Int
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
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
                    
                    Text("Your score: \(currentValue)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
        .background {
            iOS26LiquidGlass(isPressed: false, size: .small)
        }
    }
}

#Preview {
    StatsTabView()
}
