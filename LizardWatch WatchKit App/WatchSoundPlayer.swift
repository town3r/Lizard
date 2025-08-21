// WatchSoundPlayer.swift - Simplified Sound Player for watchOS
import AVFoundation
import WatchKit

/// Simplified sound player for watchOS with reduced complexity
final class WatchSoundPlayer {
    static let shared = WatchSoundPlayer()
    
    private var audioPlayer: AVAudioPlayer?
    private var lastPlayTime: TimeInterval = 0
    private let minInterval: TimeInterval = 0.1 // Rate limiting
    
    private init() {
        setupAudioSession()
        preloadSound()
    }
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    private func preloadSound() {
        // Try to load a simple system sound for watchOS
        // Since we don't have the original lizard.wav, we'll use a simple approach
        guard let soundPath = Bundle.main.path(forResource: "lizard", ofType: "wav") else {
            print("Could not find lizard.wav sound file")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath))
            audioPlayer?.prepareToPlay()
        } catch {
            print("Failed to load sound: \(error)")
        }
    }
    
    func playSound() {
        let now = CACurrentMediaTime()
        guard now - lastPlayTime >= minInterval else { return }
        lastPlayTime = now
        
        // Use haptic feedback as primary feedback mechanism for watchOS
        WKInterfaceDevice.current().play(.click)
        
        // Also try to play sound if available
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        audioPlayer?.play()
    }
    
    func cleanup() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}