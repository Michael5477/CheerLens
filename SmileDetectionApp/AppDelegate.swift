//
//  AppDelegate.swift
//  SmileDetectionApp
//
//  Created by 林家康 on 2025/8/24.
//

import UIKit


class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // TIMING 1: App Cold Start - Check purchase status
        // User might have purchased while app was closed
        Task {
            await SimplePurchaseManager.shared.checkSubscriptionStatusOnAppLaunch()
        }
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // TIMING 2: App Returns from Background - Check purchase status
        // Most likely to catch real-time status changes
        // User might have purchased while app was in background
        Task {
            await SimplePurchaseManager.shared.checkSubscriptionStatusOnForeground()
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

