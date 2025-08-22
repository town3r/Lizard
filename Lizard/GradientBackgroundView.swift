import SwiftUI

/// Animated gradient background with customizable colors and directions
struct GradientBackgroundView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var animationOffset: CGFloat = 0
    
    // Gradient customization settings
    @AppStorage("gradientStyle") private var gradientStyle: String = "timeOfDay"
    @AppStorage("customGradientColor1") private var customGradientColor1Data: Data = try! JSONEncoder().encode(CodableColor(color: .blue))
    @AppStorage("customGradientColor2") private var customGradientColor2Data: Data = try! JSONEncoder().encode(CodableColor(color: .purple))
    @AppStorage("customGradientColor3") private var customGradientColor3Data: Data = try! JSONEncoder().encode(CodableColor(color: .pink))
    @AppStorage("gradientDirection") private var gradientDirection: String = "topToBottom"
    @AppStorage("gradientAnimationEnabled") private var gradientAnimationEnabled: Bool = true
    @AppStorage("gradientAnimationSpeed") private var gradientAnimationSpeed: Double = 1.0
    @AppStorage("timeOfDayAutoMode") private var timeOfDayAutoMode: Bool = true
    @AppStorage("manualTimeOfDay") private var manualTimeOfDay: Double = 0.5
    
    private var customGradientColor1: Color {
        (try? JSONDecoder().decode(CodableColor.self, from: customGradientColor1Data))?.color ?? .blue
    }
    
    private var customGradientColor2: Color {
        (try? JSONDecoder().decode(CodableColor.self, from: customGradientColor2Data))?.color ?? .purple
    }
    
    private var customGradientColor3: Color {
        (try? JSONDecoder().decode(CodableColor.self, from: customGradientColor3Data))?.color ?? .pink
    }
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let now = timeline.date
            let colors = getGradientColors(for: now)
            
            gradientView(with: colors)
                .animation(gradientAnimationEnabled ? .easeInOut(duration: 2.0 / gradientAnimationSpeed) : .none, value: colors)
        }
        .ignoresSafeArea()
        .onAppear {
            if gradientAnimationEnabled {
                startAnimation()
            }
        }
        .onChange(of: gradientAnimationEnabled) { _, newValue in
            if newValue {
                startAnimation()
            }
        }
        .onChange(of: gradientAnimationSpeed) { _, _ in
            if gradientAnimationEnabled {
                startAnimation()
            }
        }
    }
    
    @ViewBuilder
    private func gradientView(with colors: [Color]) -> some View {
        switch gradientDirection {
        case "topToBottom":
            LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: .top,
                endPoint: .bottom
            )
            
        case "leftToRight":
            LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: .leading,
                endPoint: .trailing
            )
            
        case "topLeadingToBottomTrailing":
            LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
        case "topTrailingToBottomLeading":
            LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            
        case "radial":
            RadialGradient(
                gradient: Gradient(colors: colors),
                center: .center,
                startRadius: 50,
                endRadius: 500
            )
            
        default:
            LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private func getGradientColors(for date: Date) -> [Color] {
        switch gradientStyle {
        case "custom":
            return [customGradientColor1, customGradientColor2, customGradientColor3]
            
        case "preset":
            return getDynamicPresetColors(for: date)
            
        case "timeOfDay":
            fallthrough
        default:
            let t = timeOfDayAutoMode ? progressOfDay(date) : manualTimeOfDay
            return timeBasedGradientColors(for: t, scheme: colorScheme)
        }
    }
    
    private func getDynamicPresetColors(for date: Date) -> [Color] {
        // Cycle through different preset combinations based on time
        let timeMultiplier = date.timeIntervalSince1970 / (30.0 / gradientAnimationSpeed) // Change every 30 seconds (adjusted by speed)
        let presetIndex = Int(timeMultiplier) % 6
        
        switch presetIndex {
        case 0: return [.blue, .cyan, .teal] // Ocean
        case 1: return [.orange, .pink, .purple] // Sunset
        case 2: return [.green, .mint, .yellow] // Forest
        case 3: return [.purple, .indigo, .black] // Night
        case 4: return [.red, .orange, .yellow] // Fire
        case 5: return [.indigo, .blue, .cyan] // Sky
        default: return [.blue, .purple, .pink] // Default
        }
    }
    
    private func startAnimation() {
        withAnimation(.linear(duration: 30.0 / gradientAnimationSpeed).repeatForever(autoreverses: false)) {
            animationOffset = 360
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
    
    private func timeBasedGradientColors(for t: Double, scheme: ColorScheme) -> [Color] {
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
