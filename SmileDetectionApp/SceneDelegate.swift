// MARK: - SceneDelegate.swift
// Updated SceneDelegate.swift

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("🎯 DEBUG: SceneDelegate - scene function called!")
        
        // Explicitly create window without storyboard
        guard let windowScene = (scene as? UIWindowScene) else {
            print("🎯 DEBUG: SceneDelegate - Failed to get windowScene")
            return
        }
        
        print("🎯 DEBUG: SceneDelegate - Creating window and ContentView")
        let window = UIWindow(windowScene: windowScene)
        
        // Create ContentView directly
        let contentView = ContentView()
        let hostingController = UIHostingController(rootView: contentView)
        
        // Disable navigation bar and toolbar
        hostingController.navigationController?.setNavigationBarHidden(true, animated: false)
        hostingController.navigationController?.setToolbarHidden(true, animated: false)
        
        // Set root view controller
        window.rootViewController = hostingController
        self.window = window
        window.makeKeyAndVisible()
        
        print("🎯 DEBUG: SceneDelegate - ContentView loaded and window made visible")
    }

    // ... rest of the SceneDelegate methods remain the same
}

// MARK: - ContentView Definition
struct ContentView: View {
    var body: some View {
        WelcomeView()
            .onAppear {
                print("🎯 DEBUG: ContentView appeared - WelcomeView loaded")
            }
    }
}

// MARK: - Wrapper for your existing ViewController
struct SmileDetectionView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        print("🎯 DEBUG: SmileDetectionView - Creating ViewController")
        let viewController = ViewController()
        print("🎯 DEBUG: SmileDetectionView - ViewController created successfully")
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        print("🎯 DEBUG: SmileDetectionView - updateUIViewController called")
        // No updates needed
    }
}
