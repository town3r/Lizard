import SwiftUI

/// Animated gradient background with subtle color transitions
struct GradientBackgroundView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let now = timeline.date
            let t = progressOfDay(now)
            
            // Create gradient colors based on time of day
            let colors = gradientColors(for: t, scheme: colorScheme)
            
            LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 2), value: colors)
        }
        .onAppear {
            withAnimation(.linear(duration: 30).repeatForever(autoreverses: false)) {
                animationOffset = 360
            }
        }
    }
    
    private func progressOfDay(_ date: Date) -> Double {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let second = components.second ?? 0
        
        let totalSeconds = Double(hour * 3600 + minute * 60 + second)
        return totalSeconds / 86400.0 // 24 hours in seconds
    }
    
    private func gradientColors(for t: Double, scheme: ColorScheme) -> [Color] {
        let isLight = scheme == .light
        
        if t < 0.25 { // Night (midnight to 6 AM)
            return isLight ? 
                [.indigo.opacity(0.3), .purple.opacity(0.2), .blue.opacity(0.1)] :
                [.black, .indigo.opacity(0.8), .purple.opacity(0.6)]
        } else if t < 0.35 { // Dawn (6 AM to 8:24 AM)
            return isLight ?
                [.orange.opacity(0.4), .pink.opacity(0.3), .yellow.opacity(0.2)] :
                [.orange.opacity(0.7), .pink.opacity(0.5), .purple.opacity(0.4)]
        } else if t < 0.75 { // Day (8:24 AM to 6 PM)
            return isLight ?
                [.blue.opacity(0.2), .cyan.opacity(0.15), .mint.opacity(0.1)] :
                [.blue.opacity(0.6), .cyan.opacity(0.4), .teal.opacity(0.3)]
        } else if t < 0.9 { // Dusk (6 PM to 9:36 PM)
            return isLight ?
                [.orange.opacity(0.3), .red.opacity(0.2), .pink.opacity(0.15)] :
                [.orange.opacity(0.6), .red.opacity(0.4), .purple.opacity(0.3)]
        } else { // Night (9:36 PM to midnight)
            return isLight ?
                [.purple.opacity(0.2), .indigo.opacity(0.15), .blue.opacity(0.1)] :
                [.purple.opacity(0.7), .indigo.opacity(0.5), .black]
        }
    }
}

#Preview {
    GradientBackgroundView()
}
