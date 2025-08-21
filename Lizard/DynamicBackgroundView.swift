import SwiftUI

/// Enhanced time-of-day reactive background with dynamic weather effects:
/// - Animated sky that shifts through the day with weather conditions
/// - Moving clouds with dynamic opacity and layering
/// - Animated sun with rays and position tracking
/// - Rain effects with screen raindrops
/// - Enhanced sunrise/sunset transitions
/// - Stars and moon at night with weather interaction
/// - Layered grassy hills with weather shadows
struct DynamicBackgroundView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var weatherCondition: WeatherCondition = .clear
    @State private var animationOffset: CGFloat = 0
    @State private var rainDrops: [RainDrop] = []
    @State private var weatherTimer: Timer?
    @AppStorage("weatherAutoMode") private var weatherAutoMode: Bool = true
    @AppStorage("weatherOffMode") private var weatherOffMode: Bool = false
    @AppStorage("timeOfDayAutoMode") private var timeOfDayAutoMode: Bool = true
    @AppStorage("manualTimeOfDay") private var manualTimeOfDay: Double = 0.5
    @WeatherConditionStorage(key: "manualWeatherCondition") private var manualWeatherCondition: WeatherCondition
    // Add shared current weather condition storage
    @WeatherConditionStorage(key: "currentWeatherCondition") private var currentWeatherCondition: WeatherCondition

    var body: some View {
        TimelineView(.animation) { timeline in
            let now = timeline.date
            // Use manual time if override is enabled, otherwise use actual time
            let t = timeOfDayAutoMode ? progressOfDay(now) : manualTimeOfDay
            let dayness = dayCurve(t)             // 0 at midnight → 1 at noon → 0 at midnight
            let isNight = dayness < 0.35
            let isDawn = t > 0.2 && t < 0.35      // 4:48 AM - 8:24 AM
            let isDusk = t > 0.75 && t < 0.9      // 6:00 PM - 9:36 PM
            
            // Use .none weather condition when weather is turned off
            let effectiveWeather = weatherOffMode ? WeatherCondition.none : weatherCondition

            ZStack(alignment: .bottom) {
                // Enhanced sky with weather effects
                EnhancedSkyGradientView(
                    t: t,
                    dayness: dayness,
                    weather: effectiveWeather,
                    scheme: colorScheme
                )
                .ignoresSafeArea()

                // Moving clouds system (disabled when weather is off)
                if !weatherOffMode {
                    CloudLayerView(
                        t: t,
                        dayness: dayness,
                        weather: effectiveWeather,
                        animationOffset: animationOffset
                    )
                    .ignoresSafeArea()
                }

                // Sun with rays and animation
                if !isNight {
                    SunView(
                        t: t,
                        dayness: dayness,
                        weather: effectiveWeather,
                        isDawn: isDawn,
                        isDusk: isDusk
                    )
                    .ignoresSafeArea()
                }

                // Night sky elements
                if isNight {
                    StarFieldView(t: t, weather: effectiveWeather)
                        .ignoresSafeArea()
                    MoonView(t: t, weather: effectiveWeather)
                        .ignoresSafeArea()
                }

                // Rain effects (disabled when weather is off)
                if !weatherOffMode && (effectiveWeather == .rain || effectiveWeather == .storm) {
                    RainEffectView(
                        intensity: effectiveWeather == .storm ? 1.0 : 0.6,
                        animationOffset: animationOffset
                    )
                    .ignoresSafeArea()
                }

                // Snow effects (disabled when weather is off)
                if !weatherOffMode && effectiveWeather == .winter {
                    SnowEffectView(
                        intensity: 0.8,
                        animationOffset: animationOffset
                    )
                    .ignoresSafeArea()
                }

                // Thunder and lightning effects for storms (disabled when weather is off)
                if !weatherOffMode && effectiveWeather == .storm {
                    ThunderLightningView()
                        .ignoresSafeArea()
                }

                // Hills with weather shadows
                EnhancedHillsLayerView(
                    t: dayness,
                    weather: effectiveWeather,
                    scheme: colorScheme
                )
                .ignoresSafeArea()

                // Screen raindrops overlay (disabled when weather is off)
                if !weatherOffMode && (effectiveWeather == .rain || effectiveWeather == .storm) {
                    ScreenRaindropsView(drops: rainDrops)
                        .ignoresSafeArea()
                }
            }
        }
        .onAppear {
            startWeatherAnimation()
            
            // Initialize current weather condition if not set
            if currentWeatherCondition == .clear && UserDefaults.standard.object(forKey: "currentWeatherCondition") == nil {
                currentWeatherCondition = weatherCondition
            }
            
            updateWeatherCondition()
            
            // Apply manual weather if not in auto mode and weather is not off
            if !weatherAutoMode && !weatherOffMode {
                weatherCondition = manualWeatherCondition
                if weatherCondition == .rain || weatherCondition == .storm {
                    generateRaindrops()
                }
            }
        }
        .onDisappear {
            weatherTimer?.invalidate()
        }
        .onChange(of: weatherAutoMode) { _, newValue in
            if newValue && !weatherOffMode {
                updateWeatherCondition()
            } else {
                weatherTimer?.invalidate()
                if !weatherOffMode {
                    weatherCondition = manualWeatherCondition
                    if weatherCondition == .rain || weatherCondition == .storm {
                        generateRaindrops()
                    } else {
                        withAnimation(.easeOut(duration: 2)) {
                            rainDrops.removeAll()
                        }
                    }
                }
            }
        }
        .onChange(of: weatherOffMode) { _, newValue in
            if newValue {
                // Weather turned off - stop all weather effects
                weatherTimer?.invalidate()
                withAnimation(.easeOut(duration: 2)) {
                    rainDrops.removeAll()
                }
                weatherCondition = .none
            } else {
                // Weather turned back on - restore previous behavior
                if weatherAutoMode {
                    updateWeatherCondition()
                } else {
                    weatherCondition = manualWeatherCondition
                    if weatherCondition == .rain || weatherCondition == .storm {
                        generateRaindrops()
                    }
                }
            }
        }
        .onChange(of: weatherCondition) { _, newCondition in
            // Update the shared current weather condition whenever it changes
            currentWeatherCondition = newCondition
        }
        .onChange(of: manualWeatherCondition) { _, _ in
            if !weatherAutoMode && !weatherOffMode {
                weatherCondition = manualWeatherCondition
                if weatherCondition == .rain || weatherCondition == .storm {
                    generateRaindrops()
                } else {
                    withAnimation(.easeOut(duration: 2)) {
                        rainDrops.removeAll()
                    }
                }
            }
        }
    }
}

// MARK: - Weather System

internal enum WeatherCondition: CaseIterable {
    case none, clear, partlyCloudy, cloudy, rain, storm, winter
    
    var cloudCoverage: Double {
        switch self {
        case .none: return 0.0
        case .clear: return 0.1
        case .partlyCloudy: return 0.4
        case .cloudy: return 0.8
        case .rain: return 0.9
        case .storm: return 1.0
        case .winter: return 0.7
        }
    }
    
    var sunVisibility: Double {
        switch self {
        case .none: return 1.0
        case .clear: return 1.0
        case .partlyCloudy: return 0.7
        case .cloudy: return 0.3
        case .rain: return 0.1
        case .storm: return 0.05
        case .winter: return 0.4
        }
    }
    
    var displayName: String {
        switch self {
        case .none: return "No Weather"
        case .clear: return "Clear"
        case .partlyCloudy: return "Partly Cloudy"
        case .cloudy: return "Cloudy"
        case .rain: return "Rain"
        case .storm: return "Storm"
        case .winter: return "Snow"
        }
    }
    
    var iconName: String {
        switch self {
        case .none: return "minus.circle"
        case .clear: return "sun.max.fill"
        case .partlyCloudy: return "cloud.sun.fill"
        case .cloudy: return "cloud.fill"
        case .rain: return "cloud.rain.fill"
        case .storm: return "cloud.bolt.rain.fill"
        case .winter: return "cloud.snow.fill"
        }
    }
}

extension DynamicBackgroundView {
    private func startWeatherAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            Task { @MainActor in
                withAnimation(.linear(duration: 0.016)) {
                    animationOffset += 1
                }
            }
        }
    }
    
    private func updateWeatherCondition() {
        guard weatherAutoMode else { return } // Don't auto-update if in manual mode
        
        weatherTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            Task { @MainActor in
                guard weatherAutoMode else { return } // Double check in case mode changed
                
                // Simulate dynamic weather changes
                let conditions = WeatherCondition.allCases
                weatherCondition = conditions.randomElement() ?? .clear
                
                // Update raindrops for rain conditions
                if weatherCondition == .rain || weatherCondition == .storm {
                    generateRaindrops()
                } else {
                    withAnimation(.easeOut(duration: 2)) {
                        rainDrops.removeAll()
                    }
                }
            }
        }
    }
    
    // Methods for manual weather control
    func setWeatherMode(auto: Bool) {
        weatherAutoMode = auto
        if auto {
            updateWeatherCondition()
        } else {
            weatherTimer?.invalidate()
        }
    }
    
    mutating func setManualWeather(_ condition: WeatherCondition) {
        manualWeatherCondition = condition
        if !weatherAutoMode {
            weatherCondition = condition
            
            if condition == .rain || condition == .storm {
                generateRaindrops()
            } else {
                withAnimation(.easeOut(duration: 2)) {
                    rainDrops.removeAll()
                }
            }
        }
    }
    
    private func generateRaindrops() {
        let newDrops = (0..<Int.random(in: 15...30)).map { _ in
            RainDrop(
                x: Double.random(in: 0...1),
                y: Double.random(in: 0...1),
                size: Double.random(in: 2...8),
                opacity: Double.random(in: 0.3...0.8),
                animationDelay: Double.random(in: 0...3)
            )
        }
        
        withAnimation(.easeIn(duration: 1)) {
            rainDrops = newDrops
        }
    }
}

// MARK: - Enhanced Sky

private struct EnhancedSkyGradientView: View {
    var t: Double
    var dayness: Double
    var weather: WeatherCondition
    var scheme: ColorScheme

    var body: some View {
        let colors = gradientColors(t: t, dayness: dayness, weather: weather, scheme: scheme)
        LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private func gradientColors(t: Double, dayness: Double, weather: WeatherCondition, scheme: ColorScheme) -> [Color] {
        let isDawn = t > 0.2 && t < 0.35
        let isDusk = t > 0.75 && t < 0.9
        
        // Base palettes
        let night = [
            Color(red: 0.02, green: 0.02, blue: 0.06),
            Color(red: 0.06, green: 0.06, blue: 0.14),
            Color(red: 0.08, green: 0.10, blue: 0.20),
            Color(red: 0.10, green: 0.12, blue: 0.24),
        ]
        
        let dawn = [
            Color(red: 0.98, green: 0.65, blue: 0.32),
            Color(red: 0.96, green: 0.75, blue: 0.52),
            Color(red: 0.88, green: 0.85, blue: 0.75),
            Color(red: 0.82, green: 0.90, blue: 0.95),
        ]
        
        let day = [
            Color(red: 0.55, green: 0.80, blue: 0.98),
            Color(red: 0.68, green: 0.86, blue: 0.99),
            Color(red: 0.82, green: 0.92, blue: 1.0),
            Color(red: 0.92, green: 0.96, blue: 1.0),
        ]
        
        let dusk = [
            Color(red: 0.85, green: 0.45, blue: 0.25),
            Color(red: 0.92, green: 0.65, blue: 0.35),
            Color(red: 0.75, green: 0.75, blue: 0.85),
            Color(red: 0.65, green: 0.70, blue: 0.88),
        ]
        
        // Weather modifications
        let weatherDarkening = 1.0 - (weather.cloudCoverage * 0.4)
        
        var baseColors: [Color]
        if isDawn {
            baseColors = dawn
        } else if isDusk {
            baseColors = dusk
        } else {
            let bias: Double = (scheme == .dark) ? 0.65 : 0.35
            let w = clamp(dayness * 0.85 + bias * 0.15, 0, 1)
            baseColors = zip(night, day).map { mix($0, $1, weight: w) }
        }
        
        // Apply weather effects
        return baseColors.map { color in
            let components = color.components
            return Color(
                red: components.r * weatherDarkening,
                green: components.g * weatherDarkening,
                blue: components.b * weatherDarkening,
                opacity: components.a
            )
        }
    }
}

// MARK: - Cloud System

private struct CloudLayerView: View {
    var t: Double
    var dayness: Double
    var weather: WeatherCondition
    var animationOffset: CGFloat
    
    private static let cloudLayers: [CloudLayer] = {
        var rng = SeededRandom(123)
        return (0..<3).map { layerIndex in
            let clouds = (0..<8).map { _ in
                Cloud(
                    x: rng.nextDouble(),
                    y: rng.nextDouble(in: 0...0.6),
                    scale: rng.nextDouble(in: 0.8...2.2),
                    speed: rng.nextDouble(in: 0.3...1.2),
                    opacity: rng.nextDouble(in: 0.6...0.9)
                )
            }
            return CloudLayer(
                clouds: clouds,
                depth: Double(layerIndex),
                baseOpacity: 0.8 - Double(layerIndex) * 0.2
            )
        }
    }()
    
    var body: some View {
        Canvas { ctx, size in
            let coverage = weather.cloudCoverage
            let dayOpacity = min(1.0, dayness + 0.3)
            
            // Storm wind effect - increased speed during storms
            let stormWindMultiplier = weather == .storm ? 3.0 : (weather == .rain ? 2.0 : 1.0)
            
            for layer in Self.cloudLayers {
                let layerSpeed = (1.0 + layer.depth * 0.5) * stormWindMultiplier
                let layerOffset = animationOffset * CGFloat(layerSpeed) * 0.02
                
                for cloud in layer.clouds {
                    let x = (cloud.x + Double(layerOffset / size.width)).truncatingRemainder(dividingBy: 1.0)
                    let finalX = x * size.width
                    let finalY = cloud.y * size.height
                    
                    let cloudOpacity = cloud.opacity * layer.baseOpacity * coverage * dayOpacity
                    
                    drawCloud(
                        ctx: ctx,
                        center: CGPoint(x: finalX, y: finalY),
                        scale: cloud.scale,
                        opacity: cloudOpacity,
                        weather: weather
                    )
                }
            }
        }
        .allowsHitTesting(false)
    }
    
    private func drawCloud(ctx: GraphicsContext, center: CGPoint, scale: Double, opacity: Double, weather: WeatherCondition) {
        let cloudColor: Color = {
            switch weather {
            case .none, .clear, .partlyCloudy:
                return .white
            case .cloudy:
                return Color(.systemGray4)
            case .rain:
                return Color(.systemGray2)
            case .storm:
                return Color(.systemGray)
            case .winter:
                return Color(.white)
            }
        }()
        
        let baseSize: CGFloat = 60 * scale
        let positions = [
            CGPoint(x: center.x, y: center.y),
            CGPoint(x: center.x - baseSize * 0.6, y: center.y + baseSize * 0.2),
            CGPoint(x: center.x + baseSize * 0.6, y: center.y + baseSize * 0.2),
            CGPoint(x: center.x - baseSize * 0.3, y: center.y - baseSize * 0.3),
            CGPoint(x: center.x + baseSize * 0.3, y: center.y - baseSize * 0.3),
        ]
        
        let sizes = [
            baseSize, baseSize * 0.8, baseSize * 0.8, baseSize * 0.6, baseSize * 0.6
        ]
        
        for (position, size) in zip(positions, sizes) {
            let rect = CGRect(
                x: position.x - size/2,
                y: position.y - size/2,
                width: size,
                height: size
            )
            
            ctx.fill(
                Path(ellipseIn: rect),
                with: .color(cloudColor.opacity(opacity))
            )
        }
    }
}

private struct CloudLayer {
    let clouds: [Cloud]
    let depth: Double
    let baseOpacity: Double
}

private struct Cloud {
    let x: Double
    let y: Double
    let scale: Double
    let speed: Double
    let opacity: Double
}

// MARK: - Sun System

private struct SunView: View {
    var t: Double
    var dayness: Double
    var weather: WeatherCondition
    var isDawn: Bool
    var isDusk: Bool
    
    var body: some View {
        GeometryReader { geo in
            let sunPath = calculateSunPosition(t: t, size: geo.size)
            let sunOpacity = weather.sunVisibility * dayness
            let sunColor = calculateSunColor(isDawn: isDawn, isDusk: isDusk, weather: weather)
            
            ZStack {
                // Sun rays
                if sunOpacity > 0.3 {
                    SunRaysView(opacity: sunOpacity * 0.6, color: sunColor)
                        .frame(width: 120, height: 120)
                        .position(sunPath)
                }
                
                // Main sun
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                sunColor,
                                sunColor.opacity(0.8),
                                sunColor.opacity(0.4)
                            ],
                            center: .center,
                            startRadius: 15,
                            endRadius: 30
                        )
                    )
                    .frame(width: 60, height: 60)
                    .opacity(sunOpacity)
                    .shadow(color: sunColor.opacity(0.5), radius: 20)
                    .position(sunPath)
            }
        }
    }
    
    private func calculateSunPosition(t: Double, size: CGSize) -> CGPoint {
        // Sun arc across the sky
        let sunProgress = max(0, min(1, (t - 0.25) / 0.5)) // 6 AM to 6 PM
        let arcX = size.width * (0.1 + 0.8 * sunProgress)
        let arcY = size.height * (0.2 + 0.3 * sin(sunProgress * .pi))
        
        return CGPoint(x: arcX, y: arcY)
    }
    
    private func calculateSunColor(isDawn: Bool, isDusk: Bool, weather: WeatherCondition) -> Color {
        if isDawn || isDusk {
            return Color(red: 1.0, green: 0.6, blue: 0.2)
        }
        
        switch weather {
        case .none, .clear:
            return Color(red: 1.0, green: 0.95, blue: 0.8)
        case .partlyCloudy:
            return Color(red: 1.0, green: 0.9, blue: 0.7)
        case .cloudy, .rain, .storm:
            return Color(red: 0.9, green: 0.85, blue: 0.75)
        case .winter:
            return Color(red: 0.8, green: 0.9, blue: 1.0)
        }
    }
}

private struct SunRaysView: View {
    let opacity: Double
    let color: Color
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            ForEach(0..<12, id: \.self) { index in
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                color.opacity(opacity),
                                color.opacity(opacity * 0.3),
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 40, height: 2)
                    .offset(x: 20)
                    .rotationEffect(.degrees(Double(index) * 30 + rotationAngle))
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
        }
    }
}

// MARK: - Rain Effects

private struct RainEffectView: View {
    let intensity: Double
    let animationOffset: CGFloat
    
    private static let rainLines: [RainLine] = {
        var rng = SeededRandom(456)
        return (0..<200).map { _ in
            RainLine(
                x: rng.nextDouble(),
                speed: rng.nextDouble(in: 0.8...1.5),
                length: rng.nextDouble(in: 10...25),
                opacity: rng.nextDouble(in: 0.3...0.7)
            )
        }
    }()
    
    var body: some View {
        Canvas { ctx, size in
            for line in Self.rainLines.prefix(Int(Double(Self.rainLines.count) * intensity)) {
                let x = line.x * size.width
                let speed = line.speed * 8
                let y = (animationOffset * CGFloat(speed)).truncatingRemainder(dividingBy: size.height + 100) - 50
                
                let start = CGPoint(x: x, y: y)
                let end = CGPoint(x: x - 5, y: y + CGFloat(line.length))
                
                var path = Path()
                path.move(to: start)
                path.addLine(to: end)
                
                ctx.stroke(
                    path,
                    with: .color(.blue.opacity(line.opacity * intensity)),
                    lineWidth: 1
                )
            }
        }
        .allowsHitTesting(false)
    }
}

private struct RainLine {
    let x: Double
    let speed: Double
    let length: Double
    let opacity: Double
}

// MARK: - Thunder and Lightning Effects

private struct ThunderLightningView: View {
    @State private var lightningFlash = false
    @State private var flashTimer: Timer?
    
    var body: some View {
        ZStack {
            // Lightning flash overlay
            if lightningFlash {
                Rectangle()
                    .fill(.white.opacity(0.3))
                    .transition(.opacity)
                    .ignoresSafeArea()
            }
            
            // Lightning bolts
            LightningBoltView(isVisible: lightningFlash)
                .ignoresSafeArea()
        }
        .onAppear {
            scheduleNextLightning()
        }
        .onDisappear {
            flashTimer?.invalidate()
        }
    }
    
    private func scheduleNextLightning() {
        flashTimer?.invalidate()
        
        // Random interval between lightning strikes (5-15 seconds)
        let interval = Double.random(in: 5.0...15.0)
        
        flashTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            Task { @MainActor in
                triggerLightning()
                scheduleNextLightning()
            }
        }
    }
    
    private func triggerLightning() {
        // Visual lightning flash
        withAnimation(.easeInOut(duration: 0.1)) {
            lightningFlash = true
        }
        
        // Turn off flash quickly
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeOut(duration: 0.3)) {
                lightningFlash = false
            }
        }
        
        // Play thunder sound with slight delay
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.5...2.0)) {
            SoundPlayer.shared.play(name: "thunder", ext: "wav")
        }
    }
}

private struct LightningBoltView: View {
    let isVisible: Bool
    @State private var boltPath: Path = Path()
    
    var body: some View {
        Canvas { ctx, size in
            if isVisible {
                // Generate lightning bolt path
                let bolt = generateLightningBolt(in: size)
                
                // Draw main bolt
                ctx.stroke(
                    bolt,
                    with: .color(.white),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                )
                
                // Draw glow effect
                ctx.stroke(
                    bolt,
                    with: .color(.cyan.opacity(0.6)),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                
                // Draw outer glow
                ctx.stroke(
                    bolt,
                    with: .color(.white.opacity(0.3)),
                    style: StrokeStyle(lineWidth: 15, lineCap: .round)
                )
            }
        }
        .allowsHitTesting(false)
    }
    
    private func generateLightningBolt(in size: CGSize) -> Path {
        var path = Path()
        
        // Start from top of screen
        let startX = Double.random(in: 0.2...0.8) * size.width
        let startY: CGFloat = 0
        
        var currentX = startX
        var currentY = startY
        
        path.move(to: CGPoint(x: currentX, y: currentY))
        
        // Create jagged lightning path
        let segments = Int.random(in: 8...15)
        let segmentHeight = size.height / CGFloat(segments)
        
        for i in 0..<segments {
            let targetY = currentY + segmentHeight
            let maxDeviation = min(80, size.width * 0.15)
            let deviation = Double.random(in: -maxDeviation...maxDeviation)
            let targetX = currentX + deviation
            
            // Add some sub-branches occasionally
            if i > 2 && Double.random(in: 0...1) < 0.3 {
                let branchX = currentX + Double.random(in: -50...50)
                let branchY = currentY + Double.random(in: 20...60)
                path.addLine(to: CGPoint(x: branchX, y: branchY))
                path.move(to: CGPoint(x: currentX, y: currentY))
            }
            
            currentX = targetX
            currentY = targetY
            
            path.addLine(to: CGPoint(x: currentX, y: currentY))
        }
        
        return path
    }
}

// MARK: - Screen Raindrops

private struct ScreenRaindropsView: View {
    let drops: [RainDrop]
    @State private var animationTime: TimeInterval = 0
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, size in
                let currentTime = timeline.date.timeIntervalSince1970
                
                for drop in drops {
                    // Calculate sliding position with gravity
                    let slideTime = currentTime - drop.startTime
                    let slideDistance = min(size.height * 0.3, slideTime * drop.slideSpeed * 100)
                    
                    let startX = drop.x * size.width
                    let startY = drop.y * size.height
                    let currentX = startX + slideDistance * 0.1 // Slight diagonal slide
                    let currentY = startY + slideDistance
                    
                    // Skip drops that have slid off screen
                    if currentY > size.height + 20 { continue }
                    
                    let radius = CGFloat(drop.size)
                    
                    // Draw trail behind the drop
                    if slideDistance > 5 {
                        let trailLength = min(30, slideDistance * 0.5)
                        for i in 0..<Int(trailLength / 3) {
                            let trailProgress = Double(i) / Double(trailLength / 3)
                            let trailX = currentX - (slideDistance * 0.1 * trailProgress)
                            let trailY = currentY - (slideDistance * trailProgress)
                            let trailRadius = radius * (1.0 - trailProgress * 0.7)
                            let trailOpacity = drop.opacity * (1.0 - trailProgress) * 0.2
                            
                            let trailRect = CGRect(
                                x: trailX - trailRadius,
                                y: trailY - trailRadius,
                                width: trailRadius * 2,
                                height: trailRadius * 2
                            )
                            
                            ctx.fill(
                                Path(ellipseIn: trailRect),
                                with: .color(.blue.opacity(trailOpacity))
                            )
                        }
                    }
                    
                    // Drop shadow
                    let shadowRect = CGRect(
                        x: currentX - radius + 1,
                        y: currentY - radius + 1,
                        width: radius * 2,
                        height: radius * 2
                    )
                    ctx.fill(
                        Path(ellipseIn: shadowRect),
                        with: .color(.black.opacity(0.1))
                    )
                    
                    // Main drop
                    let dropRect = CGRect(
                        x: currentX - radius,
                        y: currentY - radius,
                        width: radius * 2,
                        height: radius * 2
                    )
                    
                    ctx.fill(
                        Path(ellipseIn: dropRect),
                        with: .color(.blue.opacity(drop.opacity * 0.3))
                    )
                    
                    // Highlight
                    let highlightRect = CGRect(
                        x: currentX - radius * 0.3,
                        y: currentY - radius * 0.3,
                        width: radius * 0.6,
                        height: radius * 0.6
                    )
                    ctx.fill(
                        Path(ellipseIn: highlightRect),
                        with: .color(.white.opacity(drop.opacity * 0.6))
                    )
                }
            }
        }
        .allowsHitTesting(false)
    }
}

internal struct RainDrop {
    let x: Double
    let y: Double
    let size: Double
    let opacity: Double
    let animationDelay: Double
    let startTime: TimeInterval
    let slideSpeed: Double
    
    init(x: Double, y: Double, size: Double, opacity: Double, animationDelay: Double) {
        self.x = x
        self.y = y
        self.size = size
        self.opacity = opacity
        self.animationDelay = animationDelay
        self.startTime = Date().timeIntervalSince1970 + animationDelay
        self.slideSpeed = Double.random(in: 0.8...1.5)
    }
}

// MARK: - Enhanced Stars

private struct StarFieldView: View {
    var t: Double
    var weather: WeatherCondition

    private static let stars: [(x: Double, y: Double, r: CGFloat, twk: Double, twp: Double)] = {
        var rng = SeededRandom(42)
        return (0..<140).map { _ in
            (x: rng.nextDouble(),
             y: rng.nextDouble(),
             r: CGFloat(rng.nextDouble(in: 0.6...1.6)),
             twk: rng.nextDouble(in: 0.6...1.2),
             twp: rng.nextDouble(in: 0...2 * .pi))
        }
    }()

    var body: some View {
        Canvas { ctx, size in
            let cloudCoverage = weather.cloudCoverage
            let starVisibility = 1.0 - cloudCoverage * 0.8
            
            for s in Self.stars {
                let px = s.x * size.width
                let py = s.y * size.height * 0.60
                let tw = 0.8 + 0.15 * sin((t * 2 * .pi) * s.twk + s.twp)
                let alpha = min(1.0, max(0.0, tw * starVisibility))
                let rect = CGRect(x: px - s.r, y: py - s.r, width: s.r * 2, height: s.r * 2)
                ctx.fill(Path(ellipseIn: rect), with: .color(.white.opacity(alpha)))
            }
        }
        .opacity(0.85)
    }
}

// MARK: - Enhanced Moon

private struct MoonView: View {
    var t: Double
    var weather: WeatherCondition

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let nightT = nightPhase(t)
            let x = w * (0.1 + 0.8 * nightT)
            let y = h * (0.12 + 0.06 * sin(nightT * 2 * .pi))
            let moonOpacity = 1.0 - weather.cloudCoverage * 0.6
            
            Circle()
                .fill(Color.white.opacity(0.9 * moonOpacity))
                .frame(width: 14, height: 14)
                .position(x: x, y: y)
                .shadow(color: .white.opacity(0.55 * moonOpacity), radius: 8)
        }
    }

    private func nightPhase(_ t: Double) -> Double {
        if t >= 0.75 { return (t - 0.75) / 0.25 }
        if t <= 0.25 { return (t + 0.25) / 0.25 }
        return 0
    }
}

// MARK: - Enhanced Hills

private struct EnhancedHillsLayerView: View {
    var t: Double
    var weather: WeatherCondition
    var scheme: ColorScheme
    @State private var windOffset: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let colors = hillColors(t: t, weather: weather, scheme: scheme)

            ZStack(alignment: .bottom) {
                // Background hills - extend beyond screen edges to ensure full coverage
                HillShape(offset: 0, amplitude: 22)
                    .fill(colors[0])
                    .frame(width: geo.size.width + 100, height: geo.size.height * 0.35)
                    .position(x: geo.size.width / 2, y: geo.size.height - (geo.size.height * 0.35) / 2)

                HillShape(offset: 60, amplitude: 18)
                    .fill(colors[1])
                    .frame(width: geo.size.width + 100, height: geo.size.height * 0.28)
                    .position(x: geo.size.width / 2, y: geo.size.height - (geo.size.height * 0.28) / 2 + 12)

                HillShape(offset: 120, amplitude: 14)
                    .fill(colors[2])
                    .frame(width: geo.size.width + 100, height: geo.size.height * 0.22)
                    .position(x: geo.size.width / 2, y: geo.size.height - (geo.size.height * 0.22) / 2 + 24)
                
                // Enhanced landscape elements
                LandscapeElementsView(
                    size: geo.size,
                    weather: weather,
                    windOffset: windOffset,
                    dayness: t
                )
            }
            .clipped()
        }
        .onAppear {
            startWindAnimation()
        }
    }
    
    private func startWindAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            Task { @MainActor in
                let windSpeed = weather == .storm ? 3.0 : (weather == .rain ? 2.0 : 1.0)
                withAnimation(.linear(duration: 0.016)) {
                    windOffset += CGFloat(windSpeed)
                }
            }
        }
    }

    private func hillColors(t: Double, weather: WeatherCondition, scheme: ColorScheme) -> [Color] {
        // Winter/snow colors - white hills with slight blue tint
        let winterLight = [
            Color(red: 0.95, green: 0.96, blue: 0.98),  // Nearly white with cool tint
            Color(red: 0.90, green: 0.92, blue: 0.95),  // Slightly darker white
            Color(red: 0.85, green: 0.88, blue: 0.92)   // Deeper snow shadow
        ]
        let winterDark = [
            Color(red: 0.80, green: 0.82, blue: 0.85),  // Dark mode snow
            Color(red: 0.75, green: 0.77, blue: 0.80),  // Darker snow
            Color(red: 0.70, green: 0.72, blue: 0.75)   // Deepest snow shadow
        ]
        
        // Regular green hills
        let light = [
            Color(red: 0.36, green: 0.76, blue: 0.38),
            Color(red: 0.28, green: 0.62, blue: 0.30),
            Color(red: 0.21, green: 0.52, blue: 0.26)
        ]
        let dark = [
            Color(red: 0.08, green: 0.20, blue: 0.10),
            Color(red: 0.05, green: 0.14, blue: 0.08),
            Color(red: 0.12, green: 0.28, blue: 0.14)
        ]
        
        // Use winter colors when snowing
        let baseLight = weather == .winter ? winterLight : light
        let baseDark = weather == .winter ? winterDark : dark
        
        let bias: Double = (scheme == .dark) ? 0.40 : 0.15
        let w = clamp(t * 0.9 + bias * 0.1, 0, 1)
        let weatherDarkening = weather == .winter ? 1.0 : (1.0 - (weather.cloudCoverage * 0.2))
        
        return zip(baseDark, baseLight).map { darkColor, lightColor in
            let mixedColor = mix(darkColor, lightColor, weight: w)
            let components = mixedColor.components
            return Color(
                red: components.r * weatherDarkening,
                green: components.g * weatherDarkening,
                blue: components.b * weatherDarkening,
                opacity: 0.95
            )
        }
    }
}

private struct HillShape: Shape {
    var offset: CGFloat
    var amplitude: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let baseY = rect.height * 0.55
        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: baseY))

        let step: CGFloat = 16
        var x: CGFloat = 0
        while x <= rect.width {
            let y = baseY - amplitude * sin((x + offset) / 90)
                         - amplitude * 0.4 * sin((x + offset) / 28)
            path.addLine(to: CGPoint(x: x, y: y))
            x += step
        }

        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.closeSubpath()
        return path
    }
}

// MARK: - Enhanced Landscape Elements

private struct LandscapeElementsView: View {
    let size: CGSize
    let weather: WeatherCondition
    let windOffset: CGFloat
    let dayness: Double
    
    var body: some View {
        // No landscape elements - clean hills only
        EmptyView()
    }
}

// MARK: - Utility functions

private func progressOfDay(_ date: Date) -> Double {
    let cal = Calendar.current
    let comps = cal.dateComponents([.hour, .minute, .second], from: date)
    let h = Double(comps.hour ?? 0)
    let m = Double(comps.minute ?? 0)
    let s = Double(comps.second ?? 0)
    let seconds = h * 3600 + m * 60 + s
    return seconds / 86400.0
}

private func dayCurve(_ t: Double) -> Double {
    let v = 0.5 - 0.5 * cos(2 * .pi * t)
    return max(0, min(1, v))
}

private func clamp(_ v: Double, _ a: Double, _ b: Double) -> Double {
    return min(max(v, a), b)
}

private func mix(_ a: Color, _ b: Color, weight w: Double) -> Color {
    let ca = a.components
    let cb = b.components
    func lerp(_ x: Double, _ y: Double, _ t: Double) -> Double { x + (y - x) * t }
    return Color(
        red:   lerp(ca.r, cb.r, w),
        green: lerp(ca.g, cb.g, w),
        blue:  lerp(ca.b, cb.b, w),
        opacity: lerp(ca.a, cb.a, w)
    )
}

private extension Color {
    var components: (r: Double, g: Double, b: Double, a: Double) {
        #if canImport(UIKit)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        return (Double(r), Double(g), Double(b), Double(a))
        #else
        return (0, 0, 0, 1)
        #endif
    }
}

private struct SeededRandom {
    private var state: UInt64
    init(_ seed: UInt64) { self.state = seed &* 0x9E3779B97F4A7C15 }

    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }

    mutating func nextDouble() -> Double {
        Double(next() & 0x1FFFFFFFFFFFFF) / Double(0x20000000000000)
    }

    mutating func nextDouble(in range: ClosedRange<Double>) -> Double {
        range.lowerBound + (range.upperBound - range.lowerBound) * nextDouble()
    }
}

// MARK: - Snow Effects

private struct SnowEffectView: View {
    let intensity: Double
    let animationOffset: CGFloat
    
    private static let snowFlakes: [SnowFlake] = {
        var rng = SeededRandom(789)
        return (0..<150).map { _ in
            SnowFlake(
                x: rng.nextDouble(),
                speed: rng.nextDouble(in: 0.3...0.8),
                size: rng.nextDouble(in: 2...6),
                opacity: rng.nextDouble(in: 0.4...0.9),
                drift: rng.nextDouble(in: -1...1),
                rotation: rng.nextDouble(in: 0...360)
            )
        }
    }()
    
    var body: some View {
        Canvas { ctx, size in
            for flake in Self.snowFlakes.prefix(Int(Double(Self.snowFlakes.count) * intensity)) {
                let x = flake.x * size.width
                let speed = flake.speed * 3
                let y = (animationOffset * CGFloat(speed)).truncatingRemainder(dividingBy: size.height + 100) - 50
                
                // Add horizontal drift for more realistic snow movement
                let driftOffset = sin(animationOffset * 0.01 + CGFloat(flake.x * 10)) * CGFloat(flake.drift) * 20
                let finalX = x + driftOffset
                
                let snowflakeSize = CGFloat(flake.size)
                
                // Draw snowflake as a small star/crystal shape
                let center = CGPoint(x: finalX, y: y)
                drawSnowflake(
                    ctx: ctx,
                    center: center,
                    size: snowflakeSize,
                    opacity: flake.opacity * intensity,
                    rotation: flake.rotation + Double(animationOffset * 0.5)
                )
            }
        }
        .allowsHitTesting(false)
    }
    
    private func drawSnowflake(ctx: GraphicsContext, center: CGPoint, size: CGFloat, opacity: Double, rotation: Double) {
        let halfSize = size / 2
        
        // Create snowflake path with 6 spokes
        var path = Path()
        
        for i in 0..<6 {
            let angle = Double(i) * 60.0 + rotation
            let radians = angle * .pi / 180.0
            
            let endX = center.x + cos(radians) * halfSize
            let endY = center.y + sin(radians) * halfSize
            
            path.move(to: center)
            path.addLine(to: CGPoint(x: endX, y: endY))
            
            // Add small perpendicular lines for snowflake details
            let detailSize = halfSize * 0.3
            let detailAngle1 = radians + .pi / 4
            let detailAngle2 = radians - .pi / 4
            
            let detail1X = endX - cos(detailAngle1) * detailSize
            let detail1Y = endY - sin(detailAngle1) * detailSize
            let detail2X = endX - cos(detailAngle2) * detailSize
            let detail2Y = endY - sin(detailAngle2) * detailSize
            
            path.move(to: CGPoint(x: endX, y: endY))
            path.addLine(to: CGPoint(x: detail1X, y: detail1Y))
            path.move(to: CGPoint(x: endX, y: endY))
            path.addLine(to: CGPoint(x: detail2X, y: detail2Y))
        }
        
        ctx.stroke(
            path,
            with: .color(.white.opacity(opacity)),
            lineWidth: 1
        )
        
        // Add a small center dot
        let centerRect = CGRect(
            x: center.x - 1,
            y: center.y - 1,
            width: 2,
            height: 2
        )
        ctx.fill(
            Path(ellipseIn: centerRect),
            with: .color(.white.opacity(opacity * 0.8))
        )
    }
}

private struct SnowFlake {
    let x: Double
    let speed: Double
    let size: Double
    let opacity: Double
    let drift: Double
    let rotation: Double
}
