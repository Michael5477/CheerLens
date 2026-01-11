// MARK: - Performance Monitor
// PerformanceMonitor.swift

import Foundation

// Performance Monitor
class PerformanceMonitor {
    private var monitoringTimer: Timer?
    private var startTime: Date?
    
    func startMonitoring() {
        startTime = Date()
        monitoringTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            self.logPerformance()
        }
    }
    
    func stopMonitoring() {
        monitoringTimer?.invalidate()
        monitoringTimer = nil
    }
    
    func logEvent(_ event: String) {
        print("📊 \(event)")
    }
    
    func logPerformance() {
        let memoryUsage = getMemoryUsageMB()
        print("📊 Performance - Memory: \(memoryUsage)MB")
    }
    
    private func getMemoryUsageMB() -> String {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        
        let kerr = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            let usedMB = Double(info.resident_size) / 1024.0 / 1024.0
            return String(format: "%.1f", usedMB)
        }
        return "Unknown"
    }
}
