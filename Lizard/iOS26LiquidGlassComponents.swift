//
//  iOS26LiquidGlassComponents.swift
//  Lizard
//
//  iOS 26 Beta Liquid Glass UI Components
//

import SwiftUI

// MARK: - iOS 26 Liquid Glass Button Component

struct iOS26LiquidGlassButton: View {
    let title: String?
    let systemImage: String?
    let font: Font
    let style: ButtonStyle
    let width: CGFloat?
    let isJittering: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var jitterOffset: CGSize = .zero
    @State private var jitterTimer: Timer?
    
    enum ButtonStyle {
        case primary, secondary
    }
    
    init(title: String, font: Font, style: ButtonStyle, width: CGFloat? = nil, isJittering: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = nil
        self.font = font
        self.style = style
        self.width = width
        self.isJittering = isJittering
        self.action = action
    }
    
    init(systemImage: String, font: Font, style: ButtonStyle, width: CGFloat? = nil, isJittering: Bool = false, action: @escaping () -> Void) {
        self.title = nil
        self.systemImage = systemImage
        self.font = font
        self.style = style
        self.width = width
        self.isJittering = isJittering
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Group {
                if let title = title {
                    Text(title)
                        .font(font)
                } else if let systemImage = systemImage {
                    Image(systemName: systemImage)
                        .font(font)
                }
            }
            .foregroundStyle(style == .primary ? .primary : .secondary)
            .padding(.vertical, 16)
            .frame(maxWidth: width == nil ? .infinity : width)
        }
        .buttonStyle(.plain)
        .background {
            iOS26LiquidGlass(isPressed: isPressed, size: .medium)
        }
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .offset(jitterOffset)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .onAppear {
            if isJittering {
                startJittering()
            }
        }
        .onChange(of: isJittering) { _, newValue in
            if newValue {
                startJittering()
            } else {
                stopJittering()
            }
        }
        .onDisappear {
            stopJittering()
        }
    }
    
    private func startJittering() {
        jitterTimer?.invalidate()

        jitterTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            Task { @MainActor in
                guard isJittering else { return }

                withAnimation(.easeInOut(duration: 0.1)) {
                    jitterOffset = CGSize(
                        width: Double.random(in: -2.0...2.0),
                        height: Double.random(in: -2.0...2.0)
                    )
                }
            }
        }
    }
    
    private func stopJittering() {
        jitterTimer?.invalidate()
        jitterTimer = nil
        
        withAnimation(.easeOut(duration: 0.2)) {
            jitterOffset = .zero
        }
    }
}

// MARK: - iOS 26 Liquid Glass Base Component

struct iOS26LiquidGlass: View {
    let isPressed: Bool
    let size: Size
    @Environment(\.colorScheme) private var colorScheme
    
    enum Size {
        case small, medium, large
        
        var cornerRadius: CGFloat {
            switch self {
            case .small: return 16
            case .medium: return 24
            case .large: return 32
            }
        }
        
        var depth: CGFloat {
            switch self {
            case .small: return 6
            case .medium: return 8
            case .large: return 12
            }
        }
        
        var strokeWidth: CGFloat {
            switch self {
            case .small: return 1.0
            case .medium: return 1.5
            case .large: return 2.0
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Base liquid glass material - perfectly balanced visibility
            RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                .fill(.regularMaterial.opacity(isPressed ? 0.4 : 0.3))
                .overlay {
                    RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial.opacity(isPressed ? 0.6 : 0.5))
                }
            
            // Prominent edge highlights like iOS 26
            RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            .white.opacity(isPressed ? 0.5 : 0.7),
                            .white.opacity(isPressed ? 0.3 : 0.4),
                            .white.opacity(isPressed ? 0.1 : 0.2),
                            .clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: size.strokeWidth
                )
            
            // Inner glass reflection with proper iOS 26 intensity
            RoundedRectangle(cornerRadius: size.cornerRadius - 2, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            .white.opacity(isPressed ? 0.2 : 0.3),
                            .white.opacity(isPressed ? 0.1 : 0.15),
                            .clear,
                            .clear,
                            .black.opacity(isPressed ? 0.08 : 0.12)
                        ],
                        startPoint: UnitPoint(x: 0.2, y: 0.2),
                        endPoint: UnitPoint(x: 0.8, y: 0.8)
                    )
                )
                .padding(2)
            
            // Ambient reflection layer for depth
            RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                .fill(
                    RadialGradient(
                        colors: [
                            .white.opacity(isPressed ? 0.15 : 0.25),
                            .clear
                        ],
                        center: UnitPoint(x: 0.3, y: 0.3),
                        startRadius: 8,
                        endRadius: size.cornerRadius * 2
                    )
                )
        }
        .compositingGroup()
        .shadow(
            color: .black.opacity(isPressed ? 0.2 : 0.3),
            radius: isPressed ? size.depth * 0.6 : size.depth,
            x: 0,
            y: isPressed ? size.depth * 0.3 : size.depth * 0.6
        )
        .shadow(
            color: .black.opacity(isPressed ? 0.08 : 0.12),
            radius: isPressed ? size.depth * 0.3 : size.depth * 0.5,
            x: 0,
            y: isPressed ? size.depth * 0.15 : size.depth * 0.25
        )
    }
}

// MARK: - iOS 26 Liquid Glass Circle Component

struct iOS26LiquidGlassCircle: View {
    let isPressed: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Base liquid glass material with iOS 26 visibility
            Circle()
                .fill(.regularMaterial.opacity(isPressed ? 0.35 : 0.25))
                .overlay {
                    Circle()
                        .fill(.ultraThinMaterial.opacity(isPressed ? 0.6 : 0.5))
                }
            
            // Prominent edge highlight ring matching iOS 26
            Circle()
                .stroke(
                    AngularGradient(
                        colors: [
                            .white.opacity(isPressed ? 0.6 : 0.8),
                            .white.opacity(isPressed ? 0.4 : 0.6),
                            .white.opacity(isPressed ? 0.2 : 0.3),
                            .white.opacity(isPressed ? 0.4 : 0.6)
                        ],
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    lineWidth: 2
                )
                .blur(radius: 0.5)
            
            // Secondary highlight ring for definition
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            .white.opacity(isPressed ? 0.4 : 0.6),
                            .white.opacity(isPressed ? 0.1 : 0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
            
            // Complex glass reflection with iOS 26 intensity
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            .white.opacity(isPressed ? 0.2 : 0.35),
                            .white.opacity(isPressed ? 0.12 : 0.2),
                            .clear,
                            .clear,
                            .black.opacity(isPressed ? 0.05 : 0.08)
                        ],
                        center: UnitPoint(x: 0.25, y: 0.25),
                        startRadius: 20,
                        endRadius: 120
                    )
                )
            
            // Ambient light reflection
            Circle()
                .fill(
                    EllipticalGradient(
                        colors: [
                            .white.opacity(isPressed ? 0.15 : 0.25),
                            .clear
                        ],
                        center: UnitPoint(x: 0.7, y: 0.3),
                        startRadiusFraction: 0.1,
                        endRadiusFraction: 0.8
                    )
                )
            
            // Inner depth ring for enhanced 3D effect
            Circle()
                .stroke(
                    .black.opacity(isPressed ? 0.12 : 0.08),
                    lineWidth: 1
                )
                .padding(16)
        }
        .compositingGroup()
        .shadow(
            color: .black.opacity(isPressed ? 0.25 : 0.4),
            radius: isPressed ? 15 : 20,
            x: 0,
            y: isPressed ? 8 : 12
        )
        .shadow(
            color: .black.opacity(isPressed ? 0.12 : 0.18),
            radius: isPressed ? 8 : 12,
            x: 0,
            y: isPressed ? 4 : 6
        )
        .overlay {
            // Outer glow for premium iOS 26 feel
            Circle()
                .stroke(
                    RadialGradient(
                        colors: [
                            .white.opacity(isPressed ? 0.08 : 0.12),
                            .clear
                        ],
                        center: .center,
                        startRadius: 100,
                        endRadius: 140
                    ),
                    lineWidth: 3
                )
                .blur(radius: 2)
        }
    }
}

#Preview("Liquid Glass Button") {
    VStack(spacing: 20) {
        iOS26LiquidGlassButton(
            title: "Primary Button",
            font: .headline,
            style: .primary
        ) {
            print("Primary tapped")
        }
        
        iOS26LiquidGlassButton(
            systemImage: "star.fill",
            font: .title2,
            style: .secondary,
            width: 60
        ) {
            print("Secondary tapped")
        }
    }
    .padding()
    .background(.black.opacity(0.1))
}

#Preview("Liquid Glass Components") {
    VStack(spacing: 20) {
        iOS26LiquidGlass(isPressed: false, size: .small)
            .frame(width: 100, height: 50)
        
        iOS26LiquidGlass(isPressed: false, size: .medium)
            .frame(width: 150, height: 60)
        
        iOS26LiquidGlassCircle(isPressed: false)
            .frame(width: 120, height: 120)
    }
    .padding()
    .background(.black.opacity(0.1))
}