// AppDelegate.swift
import UIKit
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("🚀 App launched - checking subscription status from StoreKit")
        
        // Simplified: Use SimplePurchaseManager for one-time purchase
        Task {
            await SimplePurchaseManager.shared.checkPurchaseStatus()
        }
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("📱 App entering foreground - checking subscription status from StoreKit")
        
        // Simplified: Use SimplePurchaseManager for one-time purchase
        Task {
            await SimplePurchaseManager.shared.checkPurchaseStatus()
        }
    }
}

// MARK: - App Delegate for SwiftUI
extension AppDelegate {
    static func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}
