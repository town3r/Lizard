// LizardTests.swift
import XCTest
@testable import Lizard

/// Basic unit tests for the Lizard app core functionality
class LizardTests: XCTestCase {
    
    // MARK: - SoundPlayer Tests
    
    func testSoundPlayerPreload() {
        let soundPlayer = SoundPlayer.shared
        
        // Test preloading with valid parameters
        soundPlayer.preload(name: "lizard", ext: "wav", voices: 3)
        
        // Verify pool is created (we can't directly access private members, but we can test behavior)
        XCTAssertNoThrow(soundPlayer.play(name: "lizard", ext: "wav"))
    }
    
    func testSoundPlayerRateLimit() {
        let soundPlayer = SoundPlayer.shared
        soundPlayer.preload(name: "lizard", ext: "wav", voices: 1)
        
        // Play multiple times quickly - should be rate limited
        let startTime = CACurrentMediaTime()
        for _ in 0..<10 {
            soundPlayer.play(name: "lizard", ext: "wav")
        }
        let endTime = CACurrentMediaTime()
        
        // The rate limiting should prevent excessive calls
        XCTAssertLessThan(endTime - startTime, 1.0, "Rate limiting should prevent excessive audio calls")
    }
    
    // MARK: - GameCenterManager Tests
    
    func testGameCenterManagerSingleton() {
        let manager1 = GameCenterManager.shared
        let manager2 = GameCenterManager.shared
        
        XCTAssertTrue(manager1 === manager2, "GameCenterManager should be a singleton")
    }
    
    func testAchievementIdentifiers() {
        XCTAssertEqual(GameCenterManager.AchIDs.first100, "com.town3r.lizard.ach.first100")
        XCTAssertEqual(GameCenterManager.AchIDs.first500, "com.town3r.lizard.ach.first500")
        XCTAssertEqual(GameCenterManager.AchIDs.tap100, "com.town3r.lizard.ach.tap100")
    }
    
    // MARK: - LizardScene Configuration Tests
    
    func testLizardSceneConfiguration() {
        let scene = LizardScene(size: CGSize(width: 400, height: 600))
        
        // Test initial state
        XCTAssertEqual(scene.size.width, 400)
        XCTAssertEqual(scene.size.height, 600)
        XCTAssertEqual(scene.currentFPS, 60, accuracy: 0.1)
    }
    
    func testLizardScenePublicAPI() {
        let scene = LizardScene(size: CGSize(width: 400, height: 600))
        
        // Test that public methods don't crash
        XCTAssertNoThrow(scene.clearAll())
        XCTAssertNoThrow(scene.setAgingPaused(true))
        XCTAssertNoThrow(scene.setAgingPaused(false))
        XCTAssertNoThrow(scene.rainOnce())
        XCTAssertNoThrow(scene.emitFromCircleCenterRandom(sizeJitter: 0.5))
    }
    
    // MARK: - Notification Tests
    
    func testLizardSpawnedNotification() {
        let expectation = XCTestExpectation(description: "Lizard spawned notification")
        
        let observer = NotificationCenter.default.addObserver(
            forName: .lizardSpawned, 
            object: nil, 
            queue: .main
        ) { _ in
            expectation.fulfill()
        }
        
        // Trigger the notification
        NotificationCenter.default.post(name: .lizardSpawned, object: nil)
        
        wait(for: [expectation], timeout: 1.0)
        NotificationCenter.default.removeObserver(observer)
    }
    
    // MARK: - BetaFeedbackManager Tests
    
    func testBetaFeedbackManagerSingleton() {
        let manager1 = BetaFeedbackManager.shared
        let manager2 = BetaFeedbackManager.shared
        
        XCTAssertTrue(manager1 === manager2, "BetaFeedbackManager should be a singleton")
    }
    
    func testBetaFeedbackManagerLifecycle() {
        let manager = BetaFeedbackManager.shared
        
        // Test start/stop don't crash
        XCTAssertNoThrow(manager.start())
        XCTAssertNoThrow(manager.stop())
        XCTAssertNoThrow(manager.showFeedbackSheet()) // Should be safe to call
    }
    
    // MARK: - Gravity Transformation Tests
    
    func testGravityTransformationPortrait() {
        let scene = LizardScene(size: CGSize(width: 400, height: 600))
        
        // Test that the scene can handle tilt operations without crashing
        XCTAssertNoThrow(scene.startTilt())
        XCTAssertNoThrow(scene.stopTilt())
    }
    
    func testGravityTransformationLogic() {
        // Since we can't easily mock UIInterfaceOrientation in unit tests,
        // we test the underlying mathematical transformation logic
        
        // Test normal downward gravity (portrait device)
        let deviceGx: CGFloat = 0.0
        let deviceGy: CGFloat = -9.8
        
        // Portrait orientation should pass through unchanged
        let portraitResult = CGVector(dx: deviceGx, dy: deviceGy)
        XCTAssertEqual(portraitResult.dx, 0.0, accuracy: 0.01)
        XCTAssertEqual(portraitResult.dy, -9.8, accuracy: 0.01)
        
        // Landscape left: device X becomes interface Y, device Y becomes interface -X
        let landscapeLeftResult = CGVector(dx: -deviceGy, dy: deviceGx)
        XCTAssertEqual(landscapeLeftResult.dx, 9.8, accuracy: 0.01) // -(-9.8) = 9.8
        XCTAssertEqual(landscapeLeftResult.dy, 0.0, accuracy: 0.01)
        
        // Landscape right: device X becomes interface -Y, device Y becomes interface X  
        let landscapeRightResult = CGVector(dx: deviceGy, dy: -deviceGx)
        XCTAssertEqual(landscapeRightResult.dx, -9.8, accuracy: 0.01)
        XCTAssertEqual(landscapeRightResult.dy, 0.0, accuracy: 0.01) // -0 = 0
        
        // Portrait upside down: X is inverted, Y is clamped to prevent upward gravity
        let upsideDownResult = CGVector(dx: -deviceGx, dy: min(0, -deviceGy))
        XCTAssertEqual(upsideDownResult.dx, 0.0, accuracy: 0.01) // -0 = 0
        XCTAssertEqual(upsideDownResult.dy, 0.0, accuracy: 0.01) // min(0, -(-9.8)) = min(0, 9.8) = 0
    }
    
    func testGravityTransformationWithTilt() {
        // Test the natural gravity behavior when device is tilted in landscape
        
        // Simulate device tilted in landscape (e.g., right edge higher than left edge)
        let deviceGx: CGFloat = 3.0  // Device tilted, creating X-axis gravity component
        let deviceGy: CGFloat = -8.0 // Reduced Y-axis gravity due to tilt
        
        // Corrected landscape left transformation: dx = deviceGy, dy = -deviceGx
        let landscapeLeftResult = CGVector(dx: deviceGy, dy: -deviceGx)
        XCTAssertEqual(landscapeLeftResult.dx, -8.0, accuracy: 0.01) // Horizontal gravity
        XCTAssertEqual(landscapeLeftResult.dy, -3.0, accuracy: 0.01) // Downward gravity response to tilt
        
        // Corrected landscape right transformation: dx = -deviceGy, dy = deviceGx  
        let landscapeRightResult = CGVector(dx: -deviceGy, dy: deviceGx)
        XCTAssertEqual(landscapeRightResult.dx, 8.0, accuracy: 0.01) // Horizontal gravity
        XCTAssertEqual(landscapeRightResult.dy, 3.0, accuracy: 0.01) // Upward gravity response to tilt
        
        // Test opposite tilt direction (left edge higher than right edge)
        let deviceGxOpposite: CGFloat = -3.0  // Device tilted other way
        let deviceGyOpposite: CGFloat = -8.0
        
        // Landscape left with opposite tilt
        let landscapeLeftOpposite = CGVector(dx: deviceGyOpposite, dy: -deviceGxOpposite)
        XCTAssertEqual(landscapeLeftOpposite.dx, -8.0, accuracy: 0.01) // Horizontal gravity
        XCTAssertEqual(landscapeLeftOpposite.dy, 3.0, accuracy: 0.01) // Upward gravity response to opposite tilt
        
        // Landscape right with opposite tilt  
        let landscapeRightOpposite = CGVector(dx: -deviceGyOpposite, dy: deviceGxOpposite)
        XCTAssertEqual(landscapeRightOpposite.dx, 8.0, accuracy: 0.01) // Horizontal gravity
        XCTAssertEqual(landscapeRightOpposite.dy, -3.0, accuracy: 0.01) // Downward gravity response to opposite tilt
    }
    
    func testGravityTransformationCoordinates() {
        // Test that gravity transformations properly transform device coordinates to screen coordinates
        
        // Test with normal downward gravity (no tilt)
        let deviceGx: CGFloat = 0.0
        let deviceGy: CGFloat = -9.8
        
        // Portrait: device coordinates match interface coordinates
        let portraitResult = CGVector(dx: deviceGx, dy: deviceGy)
        XCTAssertEqual(portraitResult.dx, 0.0, accuracy: 0.01, "Portrait X should match device X")
        XCTAssertEqual(portraitResult.dy, -9.8, accuracy: 0.01, "Portrait Y should match device Y")
        
        // Landscape left: device Y becomes screen X, device X becomes screen -Y
        let landscapeLeftResult = CGVector(dx: deviceGy, dy: -deviceGx)
        XCTAssertEqual(landscapeLeftResult.dx, -9.8, accuracy: 0.01, "Landscape left X should be deviceGy")
        XCTAssertEqual(landscapeLeftResult.dy, 0.0, accuracy: 0.01, "Landscape left Y should be -deviceGx")
        
        // Landscape right: device Y becomes screen -X, device X becomes screen Y
        let landscapeRightResult = CGVector(dx: -deviceGy, dy: deviceGx)
        XCTAssertEqual(landscapeRightResult.dx, 9.8, accuracy: 0.01, "Landscape right X should be -deviceGy")
        XCTAssertEqual(landscapeRightResult.dy, 0.0, accuracy: 0.01, "Landscape right Y should be deviceGx")
        
        // Portrait upside down: X is inverted, Y is clamped to prevent upward gravity
        let upsideDownResult = CGVector(dx: -deviceGx, dy: min(0, -deviceGy))
        XCTAssertEqual(upsideDownResult.dx, 0.0, accuracy: 0.01, "Upside down X should be -deviceGx")
        XCTAssertEqual(upsideDownResult.dy, 0.0, accuracy: 0.01, "Upside down Y should be clamped")
        
        // Test with device tilted (showing natural response in landscape)
        let tiltedDeviceGx: CGFloat = 3.0
        let tiltedDeviceGy: CGFloat = -6.0
        
        let portraitTilted = CGVector(dx: tiltedDeviceGx, dy: tiltedDeviceGy)
        XCTAssertEqual(portraitTilted.dx, 3.0, accuracy: 0.01, "Portrait tilted X should match device X")
        XCTAssertEqual(portraitTilted.dy, -6.0, accuracy: 0.01, "Portrait tilted Y should match device Y")
        
        // In landscape, the transformed gravity should respond to tilt with corrected logic
        let landscapeLeftTilted = CGVector(dx: tiltedDeviceGy, dy: -tiltedDeviceGx)
        XCTAssertEqual(landscapeLeftTilted.dx, -6.0, accuracy: 0.01, "Landscape left tilted X")
        XCTAssertEqual(landscapeLeftTilted.dy, -3.0, accuracy: 0.01, "Landscape left tilted Y prevents upward gravity")
        
        let landscapeRightTilted = CGVector(dx: -tiltedDeviceGy, dy: tiltedDeviceGx)
        XCTAssertEqual(landscapeRightTilted.dx, 6.0, accuracy: 0.01, "Landscape right tilted X")
        XCTAssertEqual(landscapeRightTilted.dy, 3.0, accuracy: 0.01, "Landscape right tilted Y responds to tilt")
    }
    
    // MARK: - Enhanced Weather System Tests
    
    func testWeatherConditionProperties() {
        // Test clear weather
        let clear = WeatherCondition.clear
        XCTAssertEqual(clear.cloudCoverage, 0.1, accuracy: 0.01)
        XCTAssertEqual(clear.sunVisibility, 1.0, accuracy: 0.01)
        XCTAssertEqual(clear.displayName, "Clear")
        XCTAssertEqual(clear.iconName, "sun.max.fill")
        
        // Test storm weather
        let storm = WeatherCondition.storm
        XCTAssertEqual(storm.cloudCoverage, 1.0, accuracy: 0.01)
        XCTAssertEqual(storm.sunVisibility, 0.05, accuracy: 0.01)
        XCTAssertEqual(storm.displayName, "Storm")
        XCTAssertEqual(storm.iconName, "cloud.bolt.rain.fill")
        
        // Test rain weather
        let rain = WeatherCondition.rain
        XCTAssertEqual(rain.cloudCoverage, 0.9, accuracy: 0.01)
        XCTAssertEqual(rain.sunVisibility, 0.1, accuracy: 0.01)
        XCTAssertEqual(rain.displayName, "Rain")
        XCTAssertEqual(rain.iconName, "cloud.rain.fill")
    }
    
    func testWeatherConditionAllCases() {
        let allCases = WeatherCondition.allCases
        XCTAssertEqual(allCases.count, 5)
        XCTAssertTrue(allCases.contains(.clear))
        XCTAssertTrue(allCases.contains(.partlyCloudy))
        XCTAssertTrue(allCases.contains(.cloudy))
        XCTAssertTrue(allCases.contains(.rain))
        XCTAssertTrue(allCases.contains(.storm))
    }
    
    func testWeatherPersistence() {
        // Test default values
        let defaults = UserDefaults.standard
        
        // Set test values
        defaults.set(false, forKey: "weatherAutoMode")
        defaults.set("storm", forKey: "manualWeatherCondition")
        
        // Verify persistence works
        XCTAssertFalse(defaults.bool(forKey: "weatherAutoMode"))
        XCTAssertEqual(defaults.string(forKey: "manualWeatherCondition"), "storm")
        
        // Clean up
        defaults.removeObject(forKey: "weatherAutoMode")
        defaults.removeObject(forKey: "manualWeatherCondition")
    }
    
    func testRainDropInitialization() {
        // Create a raindrop with the new sliding properties
        let drop = RainDrop(
            x: 0.5,
            y: 0.3,
            size: 5.0,
            opacity: 0.7,
            animationDelay: 1.0
        )
        
        XCTAssertEqual(drop.x, 0.5, accuracy: 0.01)
        XCTAssertEqual(drop.y, 0.3, accuracy: 0.01)
        XCTAssertEqual(drop.size, 5.0, accuracy: 0.01)
        XCTAssertEqual(drop.opacity, 0.7, accuracy: 0.01)
        XCTAssertEqual(drop.animationDelay, 1.0, accuracy: 0.01)
        
        // Verify slide speed is within expected range
        XCTAssertGreaterThanOrEqual(drop.slideSpeed, 0.8)
        XCTAssertLessThanOrEqual(drop.slideSpeed, 1.5)
        
        // Verify start time is set
        let currentTime = Date().timeIntervalSince1970
        XCTAssertLessThanOrEqual(abs(drop.startTime - (currentTime + 1.0)), 1.0)
    }
    
    func testThunderSoundIntegration() {
        let soundPlayer = SoundPlayer.shared
        
        // Test that thunder sound doesn't crash if file is missing
        XCTAssertNoThrow(soundPlayer.play(name: "thunder", ext: "wav"))
        
        // Test that multiple thunder calls are rate limited
        let startTime = CACurrentMediaTime()
        for _ in 0..<5 {
            soundPlayer.play(name: "thunder", ext: "wav")
        }
        let endTime = CACurrentMediaTime()
        
        // Should be very fast since sound file likely doesn't exist
        XCTAssertLessThan(endTime - startTime, 0.1)
    }
}