// MARK: - App.swift
// Clean App.swift file (no ContentView, no SmileDetectionView)

import SwiftUI

@main
struct SmileDetectionApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
