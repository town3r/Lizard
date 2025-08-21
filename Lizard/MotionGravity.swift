// MotionGravity.swift
import Foundation
internal import CoreMotion

/// Reads device motion and provides a smoothed gravity vector in the
/// .xArbitraryZVertical frame (Z is aligned with gravity, X/Y float with device).
final class MotionGravity {
    private let manager = CMMotionManager()
    private let queue = OperationQueue()
    private(set) var gravity: CMAcceleration = .init(x: 0, y: -1, z: 0) // default portrait

    private let alpha: Double

    init(smoothing: Double = 0.12) {
        self.alpha = max(0.0, min(0.95, smoothing))
        queue.qualityOfService = .userInteractive
    }

    func start() {
        guard manager.isDeviceMotionAvailable else { return }
        manager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: queue) { [weak self] motion, _ in
            guard let self, let dm = motion else { return }
            let g = dm.gravity
            let a = self.alpha
            self.gravity = CMAcceleration(
                x: a * self.gravity.x + (1 - a) * g.x,
                y: a * self.gravity.y + (1 - a) * g.y,
                z: a * self.gravity.z + (1 - a) * g.z
            )
        }
    }

    func stop() {
        manager.stopDeviceMotionUpdates()
    }
}
