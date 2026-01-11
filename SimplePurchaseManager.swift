// SimplePurchaseManager.swift
// Simplified one-time purchase manager - no subscription complexity
import SwiftUI
import StoreKit
import Combine

@MainActor
class SimplePurchaseManager: ObservableObject {
    static let shared = SimplePurchaseManager()
    
    // MARK: - Published Properties
    @Published var isPurchased = false  // True if one-time purchase completed
    @Published var availableProducts: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isPurchasing = false
    
    // MARK: - Usage Tracking
    @Published var dailyUsageTime: TimeInterval = 0
    @Published var dailyLimit: TimeInterval = 180 // 3 minutes in seconds
    @Published var lastUsageDate: Date = Date()
    @Published var shouldShowDailyLimitReached = false
    
    // MARK: - Status Message (only shows "Free Plan Member" if not purchased, empty if purchased)
    @Published var currentStatusMessage = "Free Plan Member"
    
    var statusMessage: String {
        if isPurchased {
            return ""  // No status shown after purchase
        } else {
            return "Free Plan Member"
        }
    }
    
    // MARK: - Private Properties
    private let productId = "com.smiledetectionapp.onetime"
    private var updateListenerTask: Task<Void, Error>?
    
    private init() {
        // Start listening for transaction updates
        updateListenerTask = listenForTransactions()
        
        // Load products and check purchase status
        Task {
            await loadProducts()
            loadUsageData()
            
            // Only auto-check on launch if debug flag is not set
            #if DEBUG
            let shouldSkipAutoRestore = UserDefaults.standard.bool(forKey: "debug_skip_auto_restore")
            if !shouldSkipAutoRestore {
                await checkPurchaseStatus()
            } else {
                print("🧪 DEBUG: Auto-restore skipped (for testing Restore Purchases button)")
                // Load local state only
                isPurchased = UserDefaults.standard.bool(forKey: "isPurchased")
                if !isPurchased {
                    currentStatusMessage = "Free Plan Member"
                }
            }
            #else
            await checkPurchaseStatus()
            #endif
        }
        
        // Listen for app foreground
        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self else { return }
                #if DEBUG
                let shouldSkipAutoRestore = UserDefaults.standard.bool(forKey: "debug_skip_auto_restore")
                if !shouldSkipAutoRestore {
                    await self.checkPurchaseStatus()
                }
                #else
                await self.checkPurchaseStatus()
                #endif
            }
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    // MARK: - Load Products
    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        
        print("🔄 Loading products...")
        print("🔄 Product ID: \(productId)")
        
        do {
            let products = try await Product.products(for: [productId])
            availableProducts = products
            print("✅ Loaded products: \(products.count)")
            if products.isEmpty {
                print("⚠️ WARNING: No products found! Possible reasons:")
                print("   1. Product ID mismatch between code and App Store Connect")
                print("   2. Product not yet submitted with an App version (required for first IAP)")
                print("   3. Bundle ID mismatch")
                print("   4. Product not yet available in sandbox (wait a few minutes)")
                print("   5. Using wrong sandbox test account")
            } else {
                for product in products {
                    print("✅ Found product: \(product.id) - \(product.displayName)")
                }
            }
        } catch {
            errorMessage = "Failed to load products: \(error.localizedDescription)"
            print("❌ Failed to load products: \(error)")
            print("❌ Error details: \(error)")
            if let storeKitError = error as? StoreKitError {
                print("❌ StoreKit Error: \(storeKitError)")
            }
        }
        
        isLoading = false
    }
    
    // MARK: - Check Purchase Status
    func checkPurchaseStatus() async {
        print("🔄 Checking purchase status...")
        print("🔄 Product ID we're looking for: \(productId)")
        
        // Check if running in Sandbox environment
        #if DEBUG
        if let receiptURL = Bundle.main.appStoreReceiptURL,
           let receiptData = try? Data(contentsOf: receiptURL),
           let receiptString = String(data: receiptData, encoding: .utf8) {
            if receiptURL.lastPathComponent == "sandboxReceipt" {
                print("⚠️ SANDBOX ENVIRONMENT DETECTED: This is running in Sandbox mode")
                print("⚠️ Sandbox purchases are linked to your Apple ID and will restore across devices")
            } else {
                print("ℹ️ Receipt found: \(receiptURL.lastPathComponent)")
            }
        } else {
            print("ℹ️ No App Store receipt found (normal for Xcode builds)")
        }
        #endif
        
        var foundPurchase = false
        var transactionDetails: [String] = []
        var foundOtherProducts: [String] = []
        
        // Check if one-time purchase product exists in currentEntitlements
        for await result in StoreKit.Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                print("⚠️ Unverified transaction found")
                continue
            }
            
            // Log transaction details for debugging
            let details = """
            Transaction ID: \(transaction.id)
            Product ID: \(transaction.productID)
            Purchase Date: \(transaction.purchaseDate)
            Revocation Date: \(transaction.revocationDate?.description ?? "nil")
            """
            transactionDetails.append(details)
            print("🔍 Found transaction: \(transaction.productID) (ID: \(transaction.id))")
            print("   Purchase Date: \(transaction.purchaseDate)")
            
            // Check if transaction is revoked
            if let revocationDate = transaction.revocationDate {
                print("⚠️ Transaction revoked on: \(revocationDate) for product: \(transaction.productID)")
                continue
            }
            
            // Check if this is the one-time purchase product
            if transaction.productID == productId {
                foundPurchase = true
                print("✅ One-time purchase found: \(transaction.productID)")
                print("   Transaction ID: \(transaction.id)")
                print("   Purchase Date: \(transaction.purchaseDate)")
                print("⚠️ NOTE: This purchase was restored from Apple's servers (possibly from Sandbox environment)")
                print("⚠️ If this is unexpected, check if this Apple ID was used for Sandbox testing")
                break
            } else {
                foundOtherProducts.append(transaction.productID)
                print("⚠️ Found OTHER product: \(transaction.productID) (not our product)")
            }
        }
        
        // Log summary
        if transactionDetails.isEmpty {
            print("📭 No transactions found in currentEntitlements")
        } else {
            print("📋 Found \(transactionDetails.count) transaction(s) in entitlements:")
            for detail in transactionDetails {
                print("   \(detail)")
            }
        }
        
        // Update purchase status
        await MainActor.run {
            if foundPurchase {
                self.isPurchased = true
                self.currentStatusMessage = ""
                print("✅ User has purchased - unlimited access")
            } else {
                self.isPurchased = false
                self.currentStatusMessage = "Free Plan Member"
                print("📭 User has not purchased - Free Plan Member")
            }
        }
    }
    
    // MARK: - Purchase Product
    func purchaseProduct() async {
        guard let product = availableProducts.first(where: { $0.id == productId }) else {
            errorMessage = "Product not available. Please try again later."
            print("❌ Product not found: \(productId)")
            return
        }
        
        do {
            try await purchase(product)
        } catch {
            // Error is already handled in purchase() method
            print("❌ Purchase product failed: \(error)")
        }
    }
    
    // MARK: - Purchase (compatible with old API)
    func purchase(_ product: Product) async throws {
        isPurchasing = true
        errorMessage = nil
        
        do {
            print("🛒 Starting purchase: \(product.id)")
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    // Purchase successful
                    await transaction.finish()
                    
                    // Refresh status
                    await checkPurchaseStatus()
                    
                    // Close daily limit window after purchase
                    shouldShowDailyLimitReached = false
                    
                    print("✅ Purchase completed - unlimited access granted")
                }
                
            case .userCancelled:
                print("ℹ️ User cancelled purchase")
                throw StoreError.userCancelled
                
            case .pending:
                print("⏳ Purchase pending")
                errorMessage = "Purchase is pending. Please wait."
                throw StoreError.pending
                
            @unknown default:
                print("⚠️ Unknown purchase result")
                errorMessage = "Unknown error occurred. Please try again."
                throw StoreError.unknown
            }
        } catch {
            let errorMsg = "Purchase failed: \(error.localizedDescription)"
            errorMessage = errorMsg
            print("❌ \(errorMsg)")
            throw error
        }
        
        isPurchasing = false
    }
    
    // MARK: - Restore Purchases (compatible with old API)
    func restorePurchases() async {
        print("🔄 Restoring purchases...")
        print("🔄 Checking StoreKit entitlements...")
        
        var foundPurchase = false
        var foundProductId: String? = nil
        
        for await result in StoreKit.Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                print("⚠️ Unverified transaction found")
                continue
            }
            
            print("🔍 Found transaction: \(transaction.productID)")
            
            if transaction.productID == productId {
                foundPurchase = true
                foundProductId = transaction.productID
                print("✅ Found matching purchase: \(transaction.productID)")
                print("   Transaction ID: \(transaction.id)")
                print("   Purchase Date: \(transaction.purchaseDate)")
                break
            }
        }
        
        if foundPurchase {
            print("✅ Purchase restored successfully: \(foundProductId ?? "unknown")")
            await checkPurchaseStatus()
        } else {
            print("❌ No purchase found to restore")
            await checkPurchaseStatus()
        }
    }
    
    // MARK: - Finish All StoreKit Transactions (compatible with old API)
    func finishAllStoreKitTransactions() async {
        print("🔄 Finishing all StoreKit transactions...")
        // For one-time purchases, we don't need to finish transactions manually
        // They are automatically finished after verification
        await checkPurchaseStatus()
    }
    
    // MARK: - Check Subscription Status (compatible with old API - redirects to checkPurchaseStatus)
    func checkSubscriptionStatus() async {
        await checkPurchaseStatus()
    }
    
    // MARK: - Check Subscription Status On App Launch (compatible with old API)
    func checkSubscriptionStatusOnAppLaunch() async {
        await checkPurchaseStatus()
    }
    
    // MARK: - Check Subscription Status On Foreground (compatible with old API)
    func checkSubscriptionStatusOnForeground() async {
        await checkPurchaseStatus()
    }
    
    // MARK: - Usage Tracking
    func trackUsage(_ time: TimeInterval) {
        guard !isPurchased else { return } // Purchased users have unlimited usage
        
        resetDailyUsageIfNeeded()
        dailyUsageTime += time
        saveDailyUsage()
        print("⏱️ Usage: Tracked \(time) seconds. Total daily usage: \(dailyUsageTime)s")
    }
    
    func canUseApp() -> Bool {
        if isPurchased {
            return true  // Purchased - unlimited usage
        }
        resetDailyUsageIfNeeded()
        let canUse = dailyUsageTime < dailyLimit
        // Show purchase window when limit is reached
        if !canUse && !shouldShowDailyLimitReached {
            shouldShowDailyLimitReached = true
            print("⏰ Daily limit reached - showing purchase window")
        }
        return canUse
    }
    
    func remainingTime() -> TimeInterval {
        if isPurchased {
            return .infinity  // Purchased - unlimited
        }
        resetDailyUsageIfNeeded()
        return max(0, dailyLimit - dailyUsageTime)
    }
    
    func usagePercentage() -> Double {
        return min(1.0, dailyUsageTime / dailyLimit)
    }
    
    // MARK: - Compatibility Methods (for old API)
    func getStatusMessage() -> String {
        return statusMessage
    }
    
    func getTrialProgress() -> String {
        if isPurchased {
            return "Unlimited Access"
        }
        let remaining = remainingTime()
        let minutes = Int(remaining / 60)
        let seconds = Int(remaining.truncatingRemainder(dividingBy: 60))
        return "\(minutes)m \(seconds)s remaining today"
    }
    
    // MARK: - Private Methods
    private func listenForTransactions() -> Task<Void, Error> {
        return Task { @MainActor in
            for await result in StoreKit.Transaction.updates {
                do {
                    let transaction = try checkVerified(result)
                    print("🔄 Transaction update: \(transaction.productID)")
                    await checkPurchaseStatus()
                } catch {
                    print("⚠️ Transaction verification failed: \(error)")
                }
            }
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    private func resetDailyUsageIfNeeded() {
        let calendar = Calendar.current
        
        // Use virtual time if Debug Time Manager is enabled (DEBUG only)
        #if DEBUG
        let currentTime: Date
        let debugTimeManager = DebugTimeManager.shared
        if debugTimeManager.isTimeAccelerationEnabled {
            currentTime = debugTimeManager.currentVirtualTime
            print("🧪 DEBUG: Using virtual time: \(currentTime)")
        } else {
            currentTime = Date()
        }
        #else
        let currentTime = Date()
        #endif
        
        if !calendar.isDate(lastUsageDate, inSameDayAs: currentTime) {
            let previousUsageTime = dailyUsageTime
            dailyUsageTime = 0
            lastUsageDate = currentTime
            saveDailyUsage()
            print("🔄 Daily usage reset (was: \(previousUsageTime)s, now: \(dailyUsageTime)s)")
            print("🔄 Last usage date updated to: \(currentTime)")
        }
    }
    
    private func loadUsageData() {
        dailyUsageTime = UserDefaults.standard.double(forKey: "dailyUsageTime")
        if let lastDate = UserDefaults.standard.object(forKey: "lastUsageDate") as? Date {
            lastUsageDate = lastDate
        }
        resetDailyUsageIfNeeded()
    }
    
    private func saveDailyUsage() {
        UserDefaults.standard.set(dailyUsageTime, forKey: "dailyUsageTime")
        UserDefaults.standard.set(lastUsageDate, forKey: "lastUsageDate")
    }
    
    // MARK: - Debug Methods (for testing only)
    #if DEBUG
    /// Force reset purchase status for testing (DEBUG ONLY)
    /// This resets local state AND disables auto-restore so you can test Restore Purchases button
    func debugResetPurchaseStatus() {
        print("🧪 DEBUG: Force resetting purchase status (local only)")
        print("🧪 DEBUG: Also disabling auto-restore for testing Restore Purchases button")
        
        // Disable auto-restore first
        UserDefaults.standard.set(true, forKey: "debug_skip_auto_restore")
        
        // Reset local state
        isPurchased = false
        currentStatusMessage = "Free Plan Member"
        UserDefaults.standard.removeObject(forKey: "isPurchased")
        UserDefaults.standard.synchronize()
        
        print("🧪 DEBUG: Local purchase status reset to 'Free Plan Member'")
        print("🧪 DEBUG: Auto-restore is now DISABLED - StoreKit will NOT auto-restore on next app launch")
        print("🧪 DEBUG: You can now test the 'Restore Purchases' button manually")
        print("🧪 DEBUG: To re-enable auto-restore, use 'Debug: Enable Auto-Restore' button in Settings")
    }
    
    /// Check all entitlements and print details (DEBUG ONLY)
    func debugCheckAllEntitlements() async {
        print("🧪 DEBUG: Checking all entitlements...")
        var count = 0
        for await result in StoreKit.Transaction.currentEntitlements {
            count += 1
            if case .verified(let transaction) = result {
                print("🧪 DEBUG Entitlement \(count):")
                print("   Product ID: \(transaction.productID)")
                print("   Transaction ID: \(transaction.id)")
                print("   Purchase Date: \(transaction.purchaseDate)")
                print("   Revocation Date: \(transaction.revocationDate?.description ?? "nil")")
            }
        }
        print("🧪 DEBUG: Total entitlements found: \(count)")
    }
    
    /// Enable/disable auto-restore for testing Restore Purchases button (DEBUG ONLY)
    func debugSetSkipAutoRestore(_ skip: Bool) {
        UserDefaults.standard.set(skip, forKey: "debug_skip_auto_restore")
        UserDefaults.standard.synchronize()
        if skip {
            print("🧪 DEBUG: Auto-restore DISABLED - Restore Purchases button will work manually")
            print("🧪 DEBUG: Current local state: isPurchased = \(isPurchased)")
            // Reset local state to simulate no purchase
            isPurchased = false
            currentStatusMessage = "Free Plan Member"
            UserDefaults.standard.removeObject(forKey: "isPurchased")
            UserDefaults.standard.synchronize()
            print("🧪 DEBUG: Local state reset to 'Free Plan Member' - now you can test Restore Purchases")
        } else {
            print("🧪 DEBUG: Auto-restore ENABLED - App will check purchase status automatically")
            // Trigger immediate check
            Task {
                await checkPurchaseStatus()
            }
        }
    }
    
    /// Check if auto-restore is currently disabled (DEBUG ONLY)
    func debugIsAutoRestoreDisabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "debug_skip_auto_restore")
    }
    #endif
}

enum StoreError: Error {
    case failedVerification
    case userCancelled
    case pending
    case unknown
}

