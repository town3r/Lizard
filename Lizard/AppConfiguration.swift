// AppConfiguration.swift
// Centralized configuration management for the Lizard app
import Foundation
import CoreGraphics

/// Centralized configuration constants for the entire Lizard app.
/// Consolidates scattered Config structs into a single, well-organized system.
enum AppConfiguration {
    
    // MARK: - Physics & Game Engine
    enum Physics {
        static let gravityDown: CGFloat = -9.8
        static let gravityScale: CGFloat = 9.8
        static let maxPhysicsLizards = 300
        static let baseLizardSize: CGFloat = 80
        static let lizardLifetime: TimeInterval = 10
        static let rainDropsPerBurst = 16
        static let motionUpdateInterval = 1.0 / 60.0
    }
    
    // MARK: - Performance Monitoring
    enum Performance {
        static let lowFPSThreshold: Double = 45
        static let maxConsecutiveLowFPS = 10
        static let fpsUpdateAlpha = 0.15
        static let targetFPS = 60.0
        static let smoothingAlpha = 1.0 / 60.0
    }
    
    // MARK: - UI Layout & Styling
    enum UI {
        // Button sizing
        static let centerButtonSize: CGFloat = 240
        static let lizardImageSize: CGFloat = 180
        static let buttonCornerRadius: CGFloat = 20
        static let shadowRadius: CGFloat = 10
        
        // Liquid glass effect
        static let liquidGlassCornerRadius: CGFloat = 28
        static let liquidGlassDepth: CGFloat = 12
        static let liquidGlassBlur: CGFloat = 20
        static let liquidGlassHighlight: CGFloat = 0.7
        static let liquidGlassShadow: CGFloat = 0.3
        static let liquidGlassReflection: CGFloat = 0.25
    }
    
    // MARK: - Animation & Timing
    enum Animation {
        static let buttonHideDelay: TimeInterval = 2.0
        static let buttonAnimationDuration: TimeInterval = 0.4
        static let jitterIntensity: CGFloat = 2.0
        static let jitterSpeed: TimeInterval = 0.1
        static let sizeJitterHold: CGFloat = 0.6
        static let sizeJitterSingle: CGFloat = 0.2
    }
    
    // MARK: - Game Timing
    enum Timing {
        static let spewTimerInterval: TimeInterval = 0.07
        static let rainTimerInterval: TimeInterval = 0.08
    }
    
    // MARK: - watchOS Specific
    enum WatchOS {
        static let maxLizards = 20  // Much lower for watchOS performance
        static let lizardSize: CGFloat = 30
        static let animationDuration: TimeInterval = 2.0
        static let spawnButtonSize: CGFloat = 80
    }
    
    // MARK: - Background Performance
    enum Background {
        static let animationUpdateInterval = 1.0 / 30.0  // 30 FPS for background animation
        static let weatherUpdateInterval: TimeInterval = 30.0
        static let rainDropCountRange = 15...30
        static let rainDropSizeRange = 2.0...8.0
        static let rainDropOpacityRange = 0.3...0.8
        static let rainAnimationDelay = 0.0...3.0
    }
    
    // MARK: - Audio
    enum Audio {
        static let rateLimitInterval: CFTimeInterval = 0.03  // 30ms
        static let defaultVoiceCount = 6
    }
}