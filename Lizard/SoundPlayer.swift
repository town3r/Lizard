// SoundPlayer.swift
import AVFoundation

enum AudioSession {
    static func configure() {
        do {
            let s = AVAudioSession.sharedInstance()
            try s.setCategory(.playback, options: [.mixWithOthers])
            try s.setActive(true)
        } catch {
            print("⚠️ AudioSession configuration error:", error)
        }
    }
}

/// Lightweight pool + tiny rate-limit to avoid spawning many AVAudioPlayers per frame.
final class SoundPlayer: NSObject {
    static let shared = SoundPlayer()

    private var pool: [AVAudioPlayer] = []
    private var nextIndex = 0
    private var lastPlay: CFTimeInterval = 0
    private let minInterval: CFTimeInterval = AppConfiguration.Audio.rateLimitInterval
    private var currentSoundName: String?
    private var currentSoundExt: String?

    /// Call once early (optional). We'll lazy-init if you don't.
    func preload(name: String, ext: String, voices: Int = AppConfiguration.Audio.defaultVoiceCount) {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("⚠️ Sound file \(name).\(ext) not found.")
            return
        }
        
        // Clean up existing pool if switching sounds
        if currentSoundName != name || currentSoundExt != ext {
            pool.removeAll()
            currentSoundName = name
            currentSoundExt = ext
        }
        
        // Create player pool for better performance
        for _ in 0..<max(1, voices) {
            do {
                let p = try AVAudioPlayer(contentsOf: url)
                p.prepareToPlay()
                pool.append(p)
            } catch {
                print("⚠️ Failed to create AVAudioPlayer: \(error)")
            }
        }
    }

    func play(name: String, ext: String) {
        if pool.isEmpty || currentSoundName != name || currentSoundExt != ext {
            preload(name: name, ext: ext)
        }

        let now = CACurrentMediaTime()
        if now - lastPlay < minInterval { return }   // rate limit
        lastPlay = now

        guard !pool.isEmpty else { 
            print("⚠️ SoundPlayer: No audio players available for \(name).\(ext)")
            return 
        }
        
        let p = pool[nextIndex]
        nextIndex = (nextIndex + 1) % pool.count
        p.currentTime = 0
        
        // Add error handling for play
        if !p.play() {
            print("⚠️ SoundPlayer: Failed to play \(name).\(ext)")
        }
    }
    
    // MARK: - Memory management
    
    /// Clean up resources when needed
    func cleanup() {
        pool.forEach { $0.stop() }
        pool.removeAll()
        nextIndex = 0
        currentSoundName = nil
        currentSoundExt = nil
    }
}
