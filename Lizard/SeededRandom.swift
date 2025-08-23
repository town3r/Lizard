import Foundation

/// A seeded random number generator for deterministic pseudo-random values
/// Used to generate consistent patterns for clouds and other visual elements
class SeededRandom {
    private var seed: UInt64
    
    init(_ seed: Int) {
        self.seed = UInt64(seed)
    }
    
    /// Generate next random double between 0.0 and 1.0
    func nextDouble() -> Double {
        // Linear congruential generator algorithm
        seed = seed &* 1103515245 &+ 12345
        return Double(seed % 2147483647) / Double(2147483647)
    }
    
    /// Generate next random double within specified range
    func nextDouble(in range: ClosedRange<Double>) -> Double {
        let randomValue = nextDouble()
        return range.lowerBound + randomValue * (range.upperBound - range.lowerBound)
    }
}