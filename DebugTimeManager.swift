import Foundation
import SwiftUI

// MARK: - Test Scenarios Enum
enum TestScenario: String, CaseIterable {
    case trialStart = "Trial Start"
    case trialMid = "Trial Mid"
    case trialEndingSoon = "Trial Ending Soon"
    case trialEnded = "Trial Ended"
    case premiumActive = "Premium Active"
    case premiumCancelled = "Premium Cancelled"
    case freePlan = "Free Plan"
    case normal = "Normal"
    
    var description: String {
        switch self {
        case .trialStart:
            return "Free Trial Active (0 hours elapsed)"
        case .trialMid:
            return "Free Trial Active (1.5 days elapsed)"
        case .trialEndingSoon:
            return "Trial Ends then switch to Free Plan (2 days 23h elapsed)"
        case .trialEnded:
            return "Free Plan Member (3 days elapsed)"
        case .premiumActive:
            return "Premium Active"
        case .premiumCancelled:
            return "Premium Active (Cancelled)"
        case .freePlan:
            return "Free Plan Member"
        case .normal:
            return "Normal (no debug override)"
        }
    }
}

// MARK: - Debug Time Manager
// CRITICAL: This class is only used in DEBUG mode for testing subscription flows
// In production builds, isTimeAccelerationEnabled will always be false
#if DEBUG
@MainActor
class DebugTimeManager: ObservableObject {
    static let shared = DebugTimeManager()
    
    // MARK: - Published Properties
    @Published var isTimeAccelerationEnabled = false
    @Published var currentVirtualTime = Date()
    @Published var virtualStartTime = Date()
    @Published var manualElapsedTime: TimeInterval = 0
    @Published var timeAccelerationMultiplier: Double = 1.0
    @Published var currentTestScenario: TestScenario = .normal
    
    private let purchaseManager = SimplePurchaseManager.shared
    
    private init() {
        loadDebugSettings()
    }
    
    // MARK: - Time Controls
    func advanceTime(by timeInterval: TimeInterval) {
        // Ensure debug mode is enabled
        isTimeAccelerationEnabled = true
        
        // Initialize virtualStartTime if needed (simplified for one-time purchase)
        // Reset if elapsed time is invalid
        let elapsedTime = manualElapsedTime
        if elapsedTime < 0 {
            // Behind start time - reset to start
            manualElapsedTime = 0
            print("⏰ DEBUG: Reset manual elapsed time (was behind start time)")
        }
        
        print("⏰ DEBUG: virtualStartTime = \(virtualStartTime)")
        print("⏰ DEBUG: manualElapsedTime = \(manualElapsedTime/3600)h (before increment)")
        
        // Advance virtual time
        manualElapsedTime += timeInterval
        currentVirtualTime = virtualStartTime.addingTimeInterval(manualElapsedTime)
        saveDebugSettings()
        
        print("⏰ DEBUG: Time advanced by \(timeInterval/3600) hours to \(currentVirtualTime)")
        print("⏰ DEBUG: Virtual start time: \(virtualStartTime)")
        print("⏰ DEBUG: Elapsed time: \(manualElapsedTime/3600) hours")
        
        // Trigger UI update
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name("DebugTimeChanged"), object: nil)
        }
    }
    
    // MARK: - Check for Popup Events (simplified for one-time purchase)
    private func checkForPopupEvents() {
        // Removed - not needed for one-time purchase
    }
    
    func setTimeAcceleration(_ multiplier: Double) {
        timeAccelerationMultiplier = multiplier
        saveDebugSettings()
        
        print("⏰ DEBUG: Time acceleration set to \(multiplier)x")
    }
    
    // MARK: - Test Scenarios (simplified for one-time purchase)
    func setTestScenario(_ scenario: TestScenario) {
        currentTestScenario = scenario
        
        switch scenario {
        case .premiumActive:
            // Set as purchased
            purchaseManager.isPurchased = true
            purchaseManager.currentStatusMessage = ""
            
        case .freePlan:
            // Set as free plan
            purchaseManager.isPurchased = false
            purchaseManager.currentStatusMessage = "Free Plan Member"
            
        case .normal:
            // Reset to actual purchase status
            Task {
                await purchaseManager.checkPurchaseStatus()
            }
            
        default:
            // Other scenarios not applicable for one-time purchase
            break
        }
        
        saveDebugSettings()
        print("🧪 DEBUG: Test scenario set to \(scenario.rawValue)")
        
        NotificationCenter.default.post(name: Notification.Name("DebugScenarioChanged"), object: nil)
    }
    
    // MARK: - Automatic Transitions (removed for one-time purchase)
    private func checkForAutomaticTransitions() {
        // Removed - not needed for one-time purchase
    }
    
    // MARK: - Temporary Disable for Purchase
    func temporarilyDisableForPurchase() {
        isTimeAccelerationEnabled = false
        saveDebugSettings()
        print("⏸️ DEBUG: Time acceleration temporarily disabled for purchase")
    }
    
    func reEnableAfterPurchase() {
        // DISABLED: Don't auto-enable debug mode after purchase
        // This interferes with natural Sandbox testing
        // isTimeAccelerationEnabled = true
        // saveDebugSettings()
        print("▶️ DEBUG: Time acceleration NOT re-enabled after purchase (natural flow)")
    }
    
    // MARK: - Natural Flow Testing
    func disableDebugModeForNaturalTesting() {
        isTimeAccelerationEnabled = false
        currentTestScenario = .normal
        manualElapsedTime = 0
        currentVirtualTime = virtualStartTime
        saveDebugSettings()
        print("🔄 DEBUG: Debug mode disabled for natural Sandbox testing")
    }
    
    // MARK: - Persistence
    func saveDebugSettings() {
        UserDefaults.standard.set(isTimeAccelerationEnabled, forKey: "debug_time_acceleration_enabled")
        UserDefaults.standard.set(currentVirtualTime.timeIntervalSince1970, forKey: "debug_current_virtual_time")
        UserDefaults.standard.set(virtualStartTime.timeIntervalSince1970, forKey: "debug_virtual_start_time")
        UserDefaults.standard.set(manualElapsedTime, forKey: "debug_manual_elapsed_time")
        UserDefaults.standard.set(timeAccelerationMultiplier, forKey: "debug_time_acceleration_multiplier")
        UserDefaults.standard.set(currentTestScenario.rawValue, forKey: "debug_current_test_scenario")
    }
    
    private func loadDebugSettings() {
        isTimeAccelerationEnabled = UserDefaults.standard.bool(forKey: "debug_time_acceleration_enabled")
        
        if let virtualTimeInterval = UserDefaults.standard.object(forKey: "debug_current_virtual_time") as? TimeInterval {
            currentVirtualTime = Date(timeIntervalSince1970: virtualTimeInterval)
        }
        
        if let startTimeInterval = UserDefaults.standard.object(forKey: "debug_virtual_start_time") as? TimeInterval {
            virtualStartTime = Date(timeIntervalSince1970: startTimeInterval)
        }
        
        manualElapsedTime = UserDefaults.standard.double(forKey: "debug_manual_elapsed_time")
        currentVirtualTime = virtualStartTime.addingTimeInterval(manualElapsedTime)
        
        timeAccelerationMultiplier = UserDefaults.standard.double(forKey: "debug_time_acceleration_multiplier")
        if timeAccelerationMultiplier == 0 {
            timeAccelerationMultiplier = 1.0
        }
        
        if let scenarioString = UserDefaults.standard.string(forKey: "debug_current_test_scenario"),
           let scenario = TestScenario(rawValue: scenarioString) {
            currentTestScenario = scenario
        }
    }
}
#else
// MARK: - Debug Time Manager (Production Stub)
// In production builds, provide a minimal stub to prevent compilation errors
@MainActor
class DebugTimeManager: ObservableObject {
    static let shared = DebugTimeManager()
    @Published var isTimeAccelerationEnabled = false
    @Published var currentVirtualTime = Date()
    @Published var virtualStartTime = Date()
    @Published var manualElapsedTime: TimeInterval = 0
    @Published var timeAccelerationMultiplier: Double = 1.0
    @Published var currentTestScenario: TestScenario = .normal
    
    private init() {}
    
    func advanceTime(by timeInterval: TimeInterval) {
        // No-op in production
    }
    
    func setTimeAcceleration(_ multiplier: Double) {
        // No-op in production
    }
    
    func setTestScenario(_ scenario: TestScenario) {
        // No-op in production
    }
    
    func temporarilyDisableForPurchase() {
        // No-op in production
    }
    
    func reEnableAfterPurchase() {
        // No-op in production
    }
    
    func disableDebugModeForNaturalTesting() {
        // No-op in production
    }
    
    func saveDebugSettings() {
        // No-op in production
    }
}
#endif