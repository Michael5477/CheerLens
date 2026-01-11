// MARK: - Ultimate Resource Cleaner
// UltimateCleaner.swift

import Foundation
import AVFoundation
import UIKit

class UltimateCleaner {
    private static var cleanupCount = 0
    private static let maxCleanupsPerMinute = 1  // 进一步减少清理频率避免UI干扰
    private static var isNavigationInProgress = false
    private static var cleanupInProgress = false
    private static var navigationStartTime: Date?
    private static let navigationProtectionDuration: TimeInterval = 1.0  // 1秒导航保护期
    private static var navigationBlocked = false
    private static var navigationBlockStartTime: Date?
    
    // MARK: - Navigation State Management
    static func setNavigationInProgress(_ inProgress: Bool) {
        isNavigationInProgress = inProgress
        if inProgress {
            navigationStartTime = Date()
            print("🧹 导航状态更新: 进行中 (保护期开始)")
        } else {
            navigationStartTime = nil
            print("🧹 导航状态更新: 完成 (保护期结束)")
        }
    }
    
    private static func isWithinNavigationProtection() -> Bool {
        guard let startTime = navigationStartTime else { return false }
        let elapsed = Date().timeIntervalSince(startTime)
        return elapsed < navigationProtectionDuration
    }
    
    // MARK: - Navigation Blocking
    static func blockNavigation() {
        navigationBlocked = true
        navigationBlockStartTime = Date()
        print("🧹 导航已阻止 - 等待清理完成")
    }
    
    static func unblockNavigation() {
        navigationBlocked = false
        navigationBlockStartTime = nil
        print("🧹 导航已解除阻止")
    }
    
    static func isNavigationBlocked() -> Bool {
        // Check for timeout (max 3 seconds blocking)
        if let blockStartTime = navigationBlockStartTime {
            let elapsed = Date().timeIntervalSince(blockStartTime)
            if elapsed > 3.0 {
                print("🧹 导航阻止超时，自动解除")
                unblockNavigation()
                return false
            }
        }
        
        // Only block if cleanup is actually in progress, not just navigation state
        return navigationBlocked || cleanupInProgress
    }
    
    static func performTotalCleanup() {
        // 检查是否正在导航或清理
        if isNavigationInProgress || isWithinNavigationProtection() {
            print("🧹 导航保护期内，延迟清理...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                performTotalCleanup()
            }
            return
        }
        
        if cleanupInProgress {
            print("🧹 清理进行中，跳过本次清理")
            return
        }
        
        // 确保在主线程执行清理
        if Thread.isMainThread {
            performCleanupOnMainThread()
        } else {
            DispatchQueue.main.async {
                performCleanupOnMainThread()
            }
        }
    }
    
    private static func performCleanupOnMainThread() {
        cleanupInProgress = true
        blockNavigation()  // 立即阻止导航
        cleanupCount += 1
        print("🧹 开始终极清理... (第\(cleanupCount)次)")
        
        // 防止过度清理
        if cleanupCount > maxCleanupsPerMinute {
            print("🧹 清理过于频繁，跳过本次清理")
            cleanupInProgress = false
            unblockNavigation()
            return
        }
        
        // 记录清理前的内存状态
        let beforeMemory = MemoryProfiler.getDetailedMemoryBreakdown()
        MemoryProfiler.logMemoryBreakdown()
        
        // 1. 清理所有定时器
        cleanupTimers()
        
        // 2. 清理音频资源
        cleanupAudio()
        
        // 3. 清理通知中心
        cleanupNotifications()
        
        // 4. 清理缓存
        cleanupCaches()
        
        // 5. 主动清理ML Kit资源
        cleanupMLKitResourcesPassive()
        
        // 6. 清理相机资源
        cleanupCameraResources()
        
        // 7. 主动清理SwiftUI状态
        cleanupSwiftUIResourcesPassive()
        
        // 8. 强制内存回收
        forceGarbageCollection()
        
        // 9. 重置所有单例和共享实例
        resetSharedInstances()
        
        // 10. 核选项：强制系统内存回收
        if cleanupCount >= 1 {
            print("🧹 执行主动核选项：强制系统内存回收")
            performNuclearCleanupPassive()
        }
        
        // 11. 延迟发送系统内存警告（避免在导航期间干扰UI）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // 发送内存警告给系统
            NotificationCenter.default.post(name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        }
        
        // 记录清理后的内存状态
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let afterMemory = MemoryProfiler.getDetailedMemoryBreakdown()
            MemoryProfiler.compareMemoryUsage(before: beforeMemory, after: afterMemory)
        }
        
        print("🧹 终极清理完成 (第\(cleanupCount)次)")
        cleanupInProgress = false
        unblockNavigation()  // 解除导航阻止
        
        // 每分钟重置计数器
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            cleanupCount = 0
        }
    }
    
    private static func performNuclearCleanup() {
        print("🧹 核选项：强制系统内存回收...")
        
        // 1. 强制清理所有可能的缓存
        URLCache.shared.removeAllCachedResponses()
        
        // 2. 强制系统内存回收（更保守的方法）
        for _ in 0..<5 {
            autoreleasepool {
                // 创建适量对象然后立即释放
                let _ = Array(repeating: "核清理", count: 10000)
                let _ = Array(repeating: Data(count: 1000), count: 10)
            }
        }
        
        // 3. 强制主线程清理（异步，避免阻塞）
        DispatchQueue.main.async {
            autoreleasepool {
                let _ = Array(repeating: "主线程核清理", count: 1000)
            }
        }
        
        print("🧹 核选项完成")
    }
    
    private static func performNuclearCleanupPassive() {
        print("🧹 主动核选项：强制系统内存回收...")
        
        // 1. 强制清理所有可能的缓存（不创建对象）
        URLCache.shared.removeAllCachedResponses()
        
        // 2. 发送所有清理通知
        NotificationCenter.default.post(name: Notification.Name("NuclearCleanup"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("MLKitCleanupRequested"), object: nil)
        NotificationCenter.default.post(name: .cleanupRequested, object: nil)
        
        // 3. 强制系统内存压力（创建适量对象然后立即释放）
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                // 创建适量对象强制GC
                for _ in 0..<20 {
                    let _ = Array(repeating: "核清理", count: 5000)
                    let _ = Array(repeating: Data(count: 500), count: 50)
                }
            }
        }
        
        // 4. 强制主线程内存压力
        DispatchQueue.main.async {
            autoreleasepool {
                let _ = Array(repeating: "主线程核清理", count: 10000)
            }
        }
        
        // 5. 跳过系统内存警告（避免崩溃）
        // NotificationCenter.default.post(name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        
        // 6. 强制系统回收内存（异步执行，避免线程死锁）
        DispatchQueue.main.async {
            autoreleasepool {
                // 在主线程异步创建适量对象
                for _ in 0..<30 {
                    let _ = Array(repeating: "异步核清理", count: 10000)
                    let _ = Array(repeating: Data(count: 2000), count: 20)
                }
            }
        }
        
        // 7. 温和的系统内存压力（减少对象创建避免UI干扰）
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                // 创建适量对象强制系统释放内存，避免过度压力
                for _ in 0..<20 {
                    let _ = Array(repeating: "温和系统释放", count: 10000)
                    let _ = Array(repeating: Data(count: 2000), count: 20)
                }
            }
        }
        
        print("🧹 主动核选项完成")
    }
    
    private static func cleanupTimers() {
        print("🧹 清理定时器...")
        // 通过RunLoop清理所有已知的定时器源
        let runLoop = RunLoop.main
        let modes: [RunLoop.Mode] = [.default, .common, .tracking]
        
        for mode in modes {
            // 清理所有定时器源（尽可能）
            // 使用更安全的方法来清理RunLoop
            runLoop.run(mode: mode, before: Date(timeIntervalSinceNow: 0.001))
        }
    }
    
    private static func cleanupAudio() {
        print("🧹 清理音频资源...")
        // 彻底清理音频会话
        do {
            let session = AVAudioSession.sharedInstance()
            // 先停止所有音频播放
            try session.setCategory(.ambient, mode: .default)
            try session.setActive(false, options: [])
        } catch {
            print("Audio session cleanup error: \(error)")
            // 强制清理，即使出错
            do {
                try AVAudioSession.sharedInstance().setActive(false, options: [])
            } catch {
                print("Force audio cleanup failed: \(error)")
            }
        }
        
        // 清理系统声音 (更保守的方法)
        for soundID in 1100...1110 { // 只清理常用系统声音
            AudioServicesDisposeSystemSoundID(SystemSoundID(soundID))
        }
    }
    
    private static func cleanupNotifications() {
        print("🧹 清理通知中心...")
        // 移除所有通知观察者
        NotificationCenter.default.removeObserver(self)
        
        // 尝试清理其他可能的通知
        let notificationNames: [String] = [
            "smileProbabilityUpdated",
            UIApplication.didReceiveMemoryWarningNotification.rawValue,
            UIApplication.willResignActiveNotification.rawValue,
            UIApplication.didEnterBackgroundNotification.rawValue
        ]
        
        for name in notificationNames {
            let notificationName = Notification.Name(rawValue: name)
            NotificationCenter.default.removeObserver(
                self,
                name: notificationName,
                object: nil
            )
        }
    }
    
    private static func cleanupCaches() {
        print("🧹 清理缓存...")
        // 清理所有缓存
        URLCache.shared.removeAllCachedResponses()
        
        // 清理图片缓存 (移除AlamofireImage依赖)
        // UIImageView.af.sharedImageDownloader.imageCache?.removeAllImages()
        
        // 清理临时文件
        cleanupTempFiles()
    }
    
    private static func cleanupTempFiles() {
        let fileManager = FileManager.default
        let tempDir = NSTemporaryDirectory()
        
        do {
            let tempFiles = try fileManager.contentsOfDirectory(atPath: tempDir)
            for file in tempFiles {
                let filePath = (tempDir as NSString).appendingPathComponent(file)
                try fileManager.removeItem(atPath: filePath)
            }
        } catch {
            print("Temp files cleanup error: \(error)")
        }
    }
    
    private static func forceGarbageCollection() {
        print("🧹 强制内存回收...")
        
        // 1. 完全被动清理（不创建任何对象）
        cleanupImageCachesPassive()
        
        // 2. 只发送通知，让系统自己清理
        NotificationCenter.default.post(name: Notification.Name("ForceGarbageCollection"), object: nil)
        
        // 3. 强制内存压力（创建对象然后立即释放）
        autoreleasepool {
            // 创建适量对象强制GC
            for _ in 0..<10 {
                let _ = Array(repeating: "强制清理", count: 2000)
                let _ = Array(repeating: Data(count: 500), count: 20)
            }
        }
        
        // 4. 跳过系统内存警告（避免崩溃）
        // NotificationCenter.default.post(name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        
        // 5. 异步强制内存回收（避免线程死锁）
        DispatchQueue.main.async {
            autoreleasepool {
                // 在主线程异步创建适量对象
                for _ in 0..<20 {
                    let _ = Array(repeating: "异步强制清理", count: 5000)
                    let _ = Array(repeating: Data(count: 1000), count: 10)
                }
            }
        }
        
        // 6. 温和的系统内存压力（减少对象创建避免UI干扰）
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                // 创建适量对象强制系统释放内存，避免过度压力
                for _ in 0..<10 {
                    let _ = Array(repeating: "温和系统释放", count: 5000)
                    let _ = Array(repeating: Data(count: 1000), count: 10)
                }
            }
        }
        
        // Objective-C的GC提示（如果可用）
        #if objc_gc
        objc_collect(OBJC_COLLECT_IF_NEEDED)
        #endif
    }
    
    private static func cleanupImageCaches() {
        print("🧹 清理图像缓存...")
        // 清理UIImage缓存
        autoreleasepool {
            // 创建适量小图像然后立即释放，避免过度压力
            for _ in 0..<20 {
                let image = UIImage()
                _ = image.size
            }
        }
        
        // 清理Core Graphics缓存
        autoreleasepool {
            for _ in 0..<10 {
                let context = CGContext(data: nil, width: 100, height: 100, bitsPerComponent: 8, bytesPerRow: 400, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
                _ = context?.makeImage()
            }
        }
    }
    
    private static func cleanupImageCachesPassive() {
        print("🧹 主动清理图像缓存...")
        // 只清理缓存，不创建新对象
        URLCache.shared.removeAllCachedResponses()
        
        // 发送通知让其他组件自己清理
        NotificationCenter.default.post(name: Notification.Name("ImageCacheCleanup"), object: nil)
    }
    
    private static func cleanupMLKitResources() {
        print("🧹 清理ML Kit资源...")
        
        // 1. 轻量级图像处理缓存清理
        autoreleasepool {
            // 只清理少量图像缓冲区，避免内存压力
            for _ in 0..<10 {
                let _ = Data(count: 1000) // 1KB each
            }
            
            // 清理少量Core Graphics资源
            for _ in 0..<5 {
                let context = CGContext(data: nil, width: 10, height: 10, bitsPerComponent: 8, bytesPerRow: 40, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
                _ = context?.makeImage()
            }
        }
        
        // 2. 发送ML Kit清理通知
        NotificationCenter.default.post(name: Notification.Name("MLKitCleanupRequested"), object: nil)
        
        // 3. 不等待，避免阻塞
    }
    
    private static func cleanupMLKitResourcesPassive() {
        print("🧹 主动清理ML Kit资源...")
        
        // 1. 发送通知
        NotificationCenter.default.post(name: Notification.Name("MLKitCleanupRequested"), object: nil)
        
        // 2. 强制清理ML Kit相关内存
        autoreleasepool {
            // 创建大量图像缓冲区强制GC
            for _ in 0..<30 {
                let _ = Data(count: 10000) // 10KB each
            }
            
            // 创建Core Graphics资源强制GC
            for _ in 0..<20 {
                let context = CGContext(data: nil, width: 100, height: 100, bitsPerComponent: 8, bytesPerRow: 400, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
                _ = context?.makeImage()
            }
        }
    }
    
    private static func cleanupCameraResources() {
        print("🧹 清理相机资源...")
        // 发送清理请求给ViewController
        NotificationCenter.default.post(name: .cleanupRequested, object: nil)
        
        // 不等待，避免阻塞
    }
    
    private static func cleanupSwiftUIResources() {
        print("🧹 清理SwiftUI资源...")
        // SwiftUI状态清理
        autoreleasepool {
            // 强制释放SwiftUI内部缓存
            let _ = Array(repeating: "SwiftUI清理", count: 1000)
        }
        
        // 清理可能的视图层次结构缓存
        DispatchQueue.main.async {
            autoreleasepool {
                // 在主线程清理UI相关资源
                let _ = Array(repeating: "UI清理", count: 500)
            }
        }
    }
    
    private static func cleanupSwiftUIResourcesPassive() {
        print("🧹 主动清理SwiftUI资源...")
        
        // 1. 发送通知
        NotificationCenter.default.post(name: Notification.Name("SwiftUICleanup"), object: nil)
        
        // 2. 强制清理SwiftUI相关内存
        autoreleasepool {
            // 创建大量字符串强制GC
            for _ in 0..<50 {
                let _ = Array(repeating: "SwiftUI清理", count: 2000)
            }
        }
        
        // 3. 主线程清理
        DispatchQueue.main.async {
            autoreleasepool {
                let _ = Array(repeating: "主线程SwiftUI清理", count: 10000)
            }
        }
    }
    
    private static func resetSharedInstances() {
        print("🧹 重置共享实例...")
        // 重置可能持有的单例状态
        URLSession.shared.reset {}
        
        // 重置UserDefaults的临时状态（如果需要）
        UserDefaults.standard.removeObject(forKey: "tempPracticeState")
    }
}
