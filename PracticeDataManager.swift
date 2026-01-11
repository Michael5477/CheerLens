// MARK: - Practice Data Manager
// PracticeDataManager.swift

import Foundation

// Intelligent Data Manager
class PracticeDataManager {
    private var allScores: [SmileScore] = []
    private var displayScores: [SmileScore] = []
    private var smileTime: TimeInterval = 0
    private var lastScoreTime: TimeInterval = 0
    
    func addScore(_ score: SmileScore) {
        // Record all data for accurate percentage calculation
        allScores.append(score)
        
        // Calculate smile time in real time (time-based calculation)
        // This calculates the time interval between consecutive data points
        // If current point has probability > 0.3, the time since last point counts as smile time
        if allScores.count > 1 {
            let timeIncrement = score.time - lastScoreTime
            if score.probability > 0.3 {
                smileTime += timeIncrement
            }
        } else {
            // First data point: use a small default increment if it's a smile
            if score.probability > 0.3 {
                smileTime += 0.1
            }
        }
        lastScoreTime = score.time
        
        // Intelligent sampling for trend chart
        addToDisplayScores(score)
    }
    
    private func addToDisplayScores(_ score: SmileScore) {
        guard let lastDisplay = displayScores.last else {
            displayScores.append(score)
            return
        }
        
        let timeDiff = score.time - lastDisplay.time
        let probDiff = abs(score.probability - lastDisplay.probability)
        
        // Dynamic sampling strategy
        let samplingStrategy = getDynamicSamplingStrategy()
        
        if timeDiff > samplingStrategy.timeInterval || probDiff > samplingStrategy.probabilityThreshold {
            displayScores.append(score)
            
            // Automatically optimize the amount of displayed data
            if displayScores.count > 1000 {
                displayScores = optimizeDisplayData(displayScores)
            }
        }
    }
    
    private func getDynamicSamplingStrategy() -> (timeInterval: Double, probabilityThreshold: Float) {
        // Dynamically adjust the sampling strategy based on the amount of data
        let totalPoints = allScores.count
        switch totalPoints {
        case ..<100: return (0.5, 0.05)
        case 100..<500: return (1.0, 0.08)
        case 500..<1000: return (2.0, 0.12)
        default: return (3.0, 0.15)
        }
    }
    
    private func optimizeDisplayData(_ data: [SmileScore]) -> [SmileScore] {
        // Retain important feature points
        var optimized = findKeyPoints(data)
        
        // Uniform sampling supplement
        if optimized.count < 800 {
            let step = data.count / (800 - optimized.count)
            for i in stride(from: 0, to: data.count, by: step) {
                if !optimized.contains(where: { $0.time == data[i].time }) {
                    optimized.append(data[i])
                }
            }
        }
        
        return optimized.sorted { $0.time < $1.time }
    }
    
    private func findKeyPoints(_ data: [SmileScore]) -> [SmileScore] {
        var keyPoints: [SmileScore] = []
        
        // Keep the first and last points
        if let first = data.first { keyPoints.append(first) }
        if let last = data.last { keyPoints.append(last) }
        
        // Detect important feature points
        for i in 1..<(data.count - 1) {
            let prev = data[i-1].probability
            let current = data[i].probability
            let next = data[i+1].probability
            
            // Peaks and valleys
            if (current > 0.5 && current > prev && current > next) ||
               (current < 0.3 && current < prev && current < next) {
                keyPoints.append(data[i])
            }
            
            // Points crossing the 0.3 threshold
            if (prev <= 0.3 && current > 0.3) || (prev > 0.3 && current <= 0.3) {
                keyPoints.append(data[i])
            }
        }
        
        return keyPoints
    }
    
    func getSmilePercentage() -> Double {
        guard let totalTime = allScores.last?.time, totalTime > 0, !allScores.isEmpty else {
            return 0
        }
        
        // Recalculate smile time more accurately based on all data points
        // This ensures accuracy even if sampling is uneven
        var accurateSmileTime: TimeInterval = 0
        
        for i in 0..<allScores.count {
            let currentScore = allScores[i]
            
            if i == 0 {
                // First data point: if probability > 0.3, count a small default increment
                if currentScore.probability > 0.3 {
                    accurateSmileTime += 0.1
                }
            } else {
                // Calculate time interval between previous and current point
                let previousScore = allScores[i - 1]
                let timeInterval = currentScore.time - previousScore.time
                
                // If current point has probability > 0.3, the time since last point counts as smile time
                // This assumes that if the current reading shows a smile, the time since last reading was also smiling
                if currentScore.probability > 0.3 {
                    accurateSmileTime += timeInterval
                }
            }
        }
        
        return (accurateSmileTime / totalTime) * 100
    }
    
    func getTrendData() -> [SmileScore] {
        return displayScores
    }
    
    func clear() {
        allScores.removeAll()
        displayScores.removeAll()
        smileTime = 0
        lastScoreTime = 0
    }
    
    func aggressiveCleanup() {
        // Aggressive cleanup: only keep the most recent data
        if allScores.count > 500 {
            allScores.removeFirst(allScores.count - 500)
        }
        if displayScores.count > 300 {
            displayScores.removeFirst(displayScores.count - 300)
        }
    }
}
