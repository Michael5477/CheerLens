// MARK: - Memory Profiler
// MemoryProfiler.swift

import Foundation
import UIKit
import AVFoundation

class MemoryProfiler {
    static func getDetailedMemoryBreakdown() -> [String: String] {
        var breakdown: [String: String] = [:]
        
        // 1. Basic memory info
        let basicInfo = getBasicMemoryInfo()
        breakdown.merge(basicInfo) { (_, new) in new }
        
        // 2. Audio resources
        let audioInfo = getAudioResourceInfo()
        breakdown.merge(audioInfo) { (_, new) in new }
        
        // 3. Image resources
        let imageInfo = getImageResourceInfo()
        breakdown.merge(imageInfo) { (_, new) in new }
        
        // 4. Timer resources
        let timerInfo = getTimerResourceInfo()
        breakdown.merge(timerInfo) { (_, new) in new }
        
        // 5. Notification resources
        let notificationInfo = getNotificationResourceInfo()
        breakdown.merge(notificationInfo) { (_, new) in new }
        
        return breakdown
    }
    
    private static func getBasicMemoryInfo() -> [String: String] {
        var result: [String: String] = [:]
        
        // Get memory usage
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            let memoryMB = Double(info.resident_size) / 1024.0 / 1024.0
            result["Total Memory"] = String(format: "%.1f MB", memoryMB)
            result["Virtual Memory"] = String(format: "%.1f MB", Double(info.virtual_size) / 1024.0 / 1024.0)
        }
        
        return result
    }
    
    private static func getAudioResourceInfo() -> [String: String] {
        var info: [String: String] = [:]
        
        // Check audio session state
        let session = AVAudioSession.sharedInstance()
        info["Audio Session Active"] = session.isOtherAudioPlaying ? "Yes" : "No"
        info["Audio Category"] = session.category.rawValue
        
        // Check for active audio players (approximate)
        info["Audio Players"] = "Unknown (no direct access)"
        
        return info
    }
    
    private static func getImageResourceInfo() -> [String: String] {
        var info: [String: String] = [:]
        
        // Check image cache
        let imageCache = URLCache.shared
        info["Image Cache Size"] = String(format: "%.1f MB", Double(imageCache.currentMemoryUsage) / 1024.0 / 1024.0)
        info["Image Cache Count"] = "\(imageCache.currentDiskUsage)"
        
        return info
    }
    
    private static func getTimerResourceInfo() -> [String: String] {
        var info: [String: String] = [:]
        
        // Check RunLoop sources (approximate)
        let runLoop = RunLoop.main
        info["RunLoop Modes"] = "\(runLoop.currentMode?.rawValue ?? "Unknown")"
        
        return info
    }
    
    private static func getNotificationResourceInfo() -> [String: String] {
        var info: [String: String] = [:]
        
        // We can't directly count observers, but we can log what we know
        info["Known Observers"] = "smileProbabilityUpdated, memoryWarning, etc."
        
        return info
    }
    
    static func logMemoryBreakdown() {
        print("🔍 === MEMORY BREAKDOWN ===")
        let breakdown = getDetailedMemoryBreakdown()
        for (key, value) in breakdown.sorted(by: { $0.key < $1.key }) {
            print("🔍 \(key): \(value)")
        }
        print("🔍 === END BREAKDOWN ===")
    }
    
    static func compareMemoryUsage(before: [String: String], after: [String: String]) {
        print("🔍 === MEMORY COMPARISON ===")
        for key in before.keys {
            if let beforeValue = before[key], let afterValue = after[key] {
                if beforeValue != afterValue {
                    print("🔍 \(key): \(beforeValue) → \(afterValue)")
                }
            }
        }
        print("🔍 === END COMPARISON ===")
    }
}
