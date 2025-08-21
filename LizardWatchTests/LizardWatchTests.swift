// LizardWatchTests.swift
import XCTest
@testable import LizardWatch_WatchKit_App

final class LizardWatchTests: XCTestCase {
    
    func testAnimatedLizardCreation() throws {
        // Test that AnimatedLizard can be created with expected properties
        let lizard = AnimatedLizard(
            id: UUID(),
            position: CGPoint(x: 100, y: 100),
            opacity: 1.0,
            scale: 1.0,
            createdAt: Date()
        )
        
        XCTAssertEqual(lizard.position.x, 100)
        XCTAssertEqual(lizard.position.y, 100)
        XCTAssertEqual(lizard.opacity, 1.0)
        XCTAssertEqual(lizard.scale, 1.0)
        XCTAssertNotNil(lizard.id)
    }
    
    func testWatchSoundPlayerSingleton() throws {
        // Test that sound player is a proper singleton
        let player1 = WatchSoundPlayer.shared
        let player2 = WatchSoundPlayer.shared
        
        XCTAssertTrue(player1 === player2, "WatchSoundPlayer should be a singleton")
    }
    
    func testWatchGameCenterManagerSingleton() throws {
        // Test that GameCenter manager is a proper singleton
        let manager1 = WatchGameCenterManager.shared
        let manager2 = WatchGameCenterManager.shared
        
        XCTAssertTrue(manager1 === manager2, "WatchGameCenterManager should be a singleton")
    }
    
    func testAchievementIDs() throws {
        // Test that achievement IDs are properly defined
        XCTAssertEqual(WatchGameCenterManager.AchievementIDs.first50, "com.town3r.lizard.watch.first50")
        XCTAssertEqual(WatchGameCenterManager.AchievementIDs.first100, "com.town3r.lizard.watch.first100")
        XCTAssertEqual(WatchGameCenterManager.AchievementIDs.tap50, "com.town3r.lizard.watch.tap50")
    }
    
    func testLeaderboardIDs() throws {
        // Test that leaderboard IDs are properly defined
        XCTAssertEqual(WatchGameCenterManager.LeaderboardIDs.totalSpawned, "com.town3r.lizard.watch.totalspawned")
        XCTAssertEqual(WatchGameCenterManager.LeaderboardIDs.buttonTaps, "com.town3r.lizard.watch.buttontaps")
    }
    
    func testSoundPlayerCleanup() throws {
        // Test that sound player cleanup doesn't crash
        let player = WatchSoundPlayer.shared
        XCTAssertNoThrow(player.cleanup())
    }
    
    func testSoundPlayerPlaySound() throws {
        // Test that play sound doesn't crash (even without audio files)
        let player = WatchSoundPlayer.shared
        XCTAssertNoThrow(player.playSound())
    }
    
    func testGameCenterAuthenticate() throws {
        // Test that authenticate method doesn't crash
        let manager = WatchGameCenterManager.shared
        XCTAssertNoThrow(manager.authenticate())
    }
    
    func testGameCenterScoreReporting() throws {
        // Test that score reporting doesn't crash (even when not authenticated)
        let manager = WatchGameCenterManager.shared
        XCTAssertNoThrow(manager.reportScore(totalSpawned: 10, buttonTaps: 5))
    }
    
    func testGameCenterAchievementReporting() throws {
        // Test that achievement reporting doesn't crash (even when not authenticated)
        let manager = WatchGameCenterManager.shared
        XCTAssertNoThrow(manager.reportAchievements(totalSpawned: 100, buttonTaps: 50))
    }
}