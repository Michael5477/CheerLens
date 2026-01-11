// MARK: - Audio Resource Manager
// AudioResourceManager.swift

import Foundation
import AVFoundation
import UIKit

// Audio Resource Manager
class AudioResourceManager {
    private var typingPlayer: AVAudioPlayer?
    private var fallbackSoundID: SystemSoundID = 0
    private var isPreloaded = false
    
    func preloadResources() {
        print("DEBUG: AudioResourceManager - preloadResources called")
        guard !isPreloaded else { 
            print("DEBUG: AudioResourceManager - Already preloaded, returning")
            return 
        }
        
        print("DEBUG: AudioResourceManager - Configuring audio session")
        configureAudioSession()
        print("DEBUG: AudioResourceManager - Loading typing sound")
        loadTypingSound()
        isPreloaded = true
        print("DEBUG: AudioResourceManager - Preload completed")
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }
    }
    
    private func loadTypingSound() {
        print("DEBUG: AudioResourceManager - Searching for audio files...")
        
        // Try to load custom audio files first
        if let url = Bundle.main.url(forResource: "typing", withExtension: "caf") ??
                      Bundle.main.url(forResource: "typing", withExtension: "wav") {
            print("DEBUG: AudioResourceManager - Found audio file at: \(url)")
            do {
                typingPlayer = try AVAudioPlayer(contentsOf: url)
                typingPlayer?.prepareToPlay()
                print("DEBUG: AudioResourceManager - Custom audio file loaded successfully")
            } catch {
                print("DEBUG: AudioResourceManager - Failed to load custom audio: \(error)")
            }
        } else {
            print("DEBUG: AudioResourceManager - No custom audio files found, using system sound")
        }
        
        // Always set up fallback system sound
        fallbackSoundID = 1104 // System typing sound
        print("DEBUG: AudioResourceManager - Fallback system sound ID: \(fallbackSoundID)")
    }
    
    func playTypingSound() {
        print("DEBUG: AudioResourceManager - playTypingSound called")
        print("DEBUG: AudioResourceManager - typingPlayer exists: \(typingPlayer != nil)")
        print("DEBUG: AudioResourceManager - isPreloaded: \(isPreloaded)")
        print("DEBUG: AudioResourceManager - fallbackSoundID: \(fallbackSoundID)")
        
        // Try custom audio first
        if let player = typingPlayer, !player.isPlaying {
            print("DEBUG: AudioResourceManager - Playing with AVAudioPlayer")
            player.currentTime = 0
            player.play()
        } else {
            // Always use system sound as fallback
            print("DEBUG: AudioResourceManager - Playing with SystemSound")
            AudioServicesPlaySystemSound(fallbackSoundID)
        }
        
        // Haptic feedback
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        print("DEBUG: AudioResourceManager - Haptic feedback triggered")
    }
    
    func cleanup() {
        typingPlayer?.stop()
        typingPlayer = nil
        
        if fallbackSoundID != 0 {
            AudioServicesDisposeSystemSoundID(fallbackSoundID)
            fallbackSoundID = 0
        }
        
        isPreloaded = false
    }
}
