// ContentView.swift - Simplified watchOS Version
import SwiftUI
import WatchKit

struct ContentView: View {
    @AppStorage("totalLizardsSpawned") private var totalSpawned = 0
    @AppStorage("mainButtonTaps") private var mainButtonTaps = 0
    
    @State private var animatingLizards: [AnimatedLizard] = []
    @State private var isPressed = false
    
    // Simple configuration for watchOS (local constants to avoid cross-target dependencies)
    private struct Config {
        static let maxLizards = 20  // Much lower for watchOS performance
        static let lizardSize: CGFloat = 30
        static let animationDuration: TimeInterval = 2.0
        static let spawnButtonSize: CGFloat = 80
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Simple gradient background
                LinearGradient(
                    colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Animated lizards
                ForEach(animatingLizards) { lizard in
                    Text("🦎")
                        .font(.system(size: Config.lizardSize))
                        .position(lizard.position)
                        .opacity(lizard.opacity)
                        .scaleEffect(lizard.scale)
                }
                
                VStack(spacing: 20) {
                    // Stats at top
                    VStack(spacing: 4) {
                        Text("🦎 \(totalSpawned)")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.secondary)
                        Text("👆 \(mainButtonTaps)")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
                    
                    Spacer()
                    
                    // Main spawn button
                    Button {
                        spawnLizard(in: geometry)
                        mainButtonTaps += 1
                        totalSpawned += 1
                        
                        // Sound and haptic feedback
                        WatchSoundPlayer.shared.playSound()
                        
                        // Report to GameCenter
                        WatchGameCenterManager.shared.reportScore(
                            totalSpawned: totalSpawned,
                            buttonTaps: mainButtonTaps
                        )
                        WatchGameCenterManager.shared.reportAchievements(
                            totalSpawned: totalSpawned,
                            buttonTaps: mainButtonTaps
                        )
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.regularMaterial)
                                .frame(width: Config.spawnButtonSize, height: Config.spawnButtonSize)
                            
                            Text("🦎")
                                .font(.system(size: 40))
                                .scaleEffect(isPressed ? 0.9 : 1.0)
                        }
                    }
                    .buttonStyle(.plain)
                    .scaleEffect(isPressed ? 0.95 : 1.0)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            isPressed = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                isPressed = false
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Setup GameCenter
            WatchGameCenterManager.shared.authenticate()
            
            // Clean up old lizards periodically
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                cleanupLizards()
            }
        }
    }
    
    private func spawnLizard(in geometry: GeometryProxy) {
        // Create a new animated lizard
        let startX = geometry.size.width / 2
        let startY = geometry.size.height / 2
        let endX = Double.random(in: 20...(geometry.size.width - 20))
        let endY = Double.random(in: 20...(geometry.size.height - 20))
        
        let newLizard = AnimatedLizard(
            id: UUID(),
            position: CGPoint(x: startX, y: startY),
            opacity: 1.0,
            scale: 1.0,
            createdAt: Date()
        )
        
        animatingLizards.append(newLizard)
        
        // Animate the lizard
        withAnimation(.easeOut(duration: Config.animationDuration)) {
            if let index = animatingLizards.firstIndex(where: { $0.id == newLizard.id }) {
                animatingLizards[index].position = CGPoint(x: endX, y: endY)
            }
        }
        
        // Fade out and remove
        DispatchQueue.main.asyncAfter(deadline: .now() + Config.animationDuration * 0.7) {
            withAnimation(.easeOut(duration: Config.animationDuration * 0.3)) {
                if let index = animatingLizards.firstIndex(where: { $0.id == newLizard.id }) {
                    animatingLizards[index].opacity = 0
                    animatingLizards[index].scale = 0.5
                }
            }
        }
        
        // Remove completely
        DispatchQueue.main.asyncAfter(deadline: .now() + Config.animationDuration) {
            animatingLizards.removeAll { $0.id == newLizard.id }
        }
    }
    
    private func cleanupLizards() {
        let now = Date()
        animatingLizards.removeAll { lizard in
            now.timeIntervalSince(lizard.createdAt) > Config.animationDuration + 1.0
        }
        
        // Limit total lizards for performance
        if animatingLizards.count > Config.maxLizards {
            animatingLizards.removeFirst(animatingLizards.count - Config.maxLizards)
        }
    }
}

struct AnimatedLizard: Identifiable {
    let id: UUID
    var position: CGPoint
    var opacity: Double
    var scale: Double
    let createdAt: Date
}

#Preview {
    ContentView()
}