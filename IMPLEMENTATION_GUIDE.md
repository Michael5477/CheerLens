# Implementation Guide: StoreKit as Single Source of Truth

## 🎯 Goal
Fix unstable subscription status by making StoreKit the **single source of truth**, removing UserDefaults state storage, and ensuring continuous transaction monitoring.

## 📋 Step-by-Step Implementation

### Step 1: Replace `checkSubscriptionStatus()` with StoreKit-based method

**Location**: `SubscriptionManager.swift` - Replace the existing `checkSubscriptionStatus()` method

**Action**: 
1. Open `SubscriptionManager.swift`
2. Find the method `func checkSubscriptionStatus(isRestoreOperation: Bool = false) async`
3. Replace its implementation with a call to `updateUserStatusFromStoreKit()`

**Code**:
```swift
func checkSubscriptionStatus(isRestoreOperation: Bool = false) async {
    // CRITICAL FIX: Use StoreKit as single source of truth
    // Following 3rd party advice: "廢除 UserDefaults 儲存狀態，直接向 StoreKit 查詢"
    await updateUserStatusFromStoreKit()
}
```

### Step 2: Add the core method to SubscriptionManager

**Location**: Add to `SubscriptionManager.swift` (or use the extension file `StoreKitBasedStatusFix.swift`)

**Action**: 
1. Copy the content from `StoreKitBasedStatusFix.swift`
2. Add it as an extension to `SubscriptionManager` class
3. OR: Simply add the methods directly to the `SubscriptionManager` class

### Step 3: Update `init()` to use StoreKit-based check

**Location**: `SubscriptionManager.swift` - `private init()`

**Current code** (around line 177):
```swift
await checkSubscriptionStatus()
```

**Should remain the same** - it will now call the new StoreKit-based method.

### Step 4: Update App Lifecycle handlers

**Location**: `AppDelegate.swift` and `WelcomeView.swift`

**Action**: Ensure they call `updateUserStatusFromStoreKit()` when app:
- Launches
- Returns to foreground

**Code in AppDelegate.swift**:
```swift
func applicationWillEnterForeground(_ application: UIApplication) {
    Task {
        await SubscriptionManager.shared.updateUserStatusFromStoreKit()
    }
}
```

**Code in WelcomeView.swift** (in `.onAppear`):
```swift
Task {
    await subscriptionManager.updateUserStatusFromStoreKit()
}
```

### Step 5: Remove UserDefaults state storage

**Location**: Throughout `SubscriptionManager.swift`

**Action**: Find and remove/comment out all lines that save subscription state to UserDefaults:

**Remove these patterns**:
```swift
UserDefaults.standard.set(true, forKey: "isSubscribed")
UserDefaults.standard.set(false, forKey: "isInTrialPeriod")
UserDefaults.standard.set(true, forKey: "userCancelledSubscription")
```

**Keep these** (they're for other purposes):
```swift
UserDefaults.standard.set(autoSubscriptionDate, forKey: "autoSubscriptionDate") // Keep - needed for trial calculations
UserDefaults.standard.set(hasShownCongratulation, forKey: "hasShownCongratulation") // Keep - UI state
```

### Step 6: Update Transaction Listener

**Location**: `SubscriptionManager.swift` - `listenForTransactions()`

**Action**: Ensure it calls `updateUserStatusFromStoreKit()` when transactions update:

**Code**:
```swift
private func listenForTransactions() -> Task<Void, Error> {
    return Task.detached { [weak self] in
        for await result in StoreKit.Transaction.updates {
            do {
                let transaction = try self?.checkVerified(result)
                // CRITICAL: Update status from StoreKit when transaction changes
                await self?.updateUserStatusFromStoreKit()
                await transaction?.finish()
            } catch {
                print("❌ Transaction verification failed: \(error)")
            }
        }
    }
}
```

## ✅ Verification Steps

### 1. Build the Project
- Open Xcode
- Build (⌘B)
- Fix any compilation errors

### 2. Test in Sandbox
1. Launch app
2. Subscribe to a product
3. Use debug time controls to advance time
4. **Expected**: State should update based on StoreKit, not UserDefaults
5. **Check**: State transitions should be consistent with Sandbox time acceleration

### 3. Monitor State Changes
- Add print statements in `updateUserStatusFromStoreKit()` to see when it's called
- Watch console for state transitions
- Verify state matches StoreKit's `Transaction.currentEntitlements`

## 🎯 Key Principles (From 3rd Party Advice)

1. **StoreKit is the Source of Truth**
   - Never store `isSubscribed`, `isInTrialPeriod`, `userCancelledSubscription` in UserDefaults
   - Always query `Transaction.currentEntitlements` to determine state

2. **Sandbox Time Acceleration is Normal**
   - 1 week = 3 minutes in Sandbox
   - 1 month = 5 minutes in Sandbox
   - 1 year = 1 hour in Sandbox
   - Subscriptions auto-renew up to 5 times, then expire
   - This is **expected behavior**, not a bug

3. **Continuous Monitoring**
   - Transaction listener must be active from app launch
   - Update status when app returns to foreground
   - Update status when transactions change

4. **State Calculation**
   - Calculate trial vs premium based on `transaction.purchaseDate`
   - Trial = purchase date < 3 days ago
   - Premium = purchase date >= 3 days ago

## 🚨 Important Notes

- **Don't remove `autoSubscriptionDate` from UserDefaults** - it's needed for trial period calculations
- **Keep UI state flags** (like `hasShownCongratulation`) in UserDefaults - they're not subscription state
- **Test thoroughly in Sandbox** - the time acceleration will make state changes happen quickly
- **Monitor console logs** - they'll show when StoreKit state changes

## 📝 Testing Checklist

- [ ] App builds without errors
- [ ] Subscription purchase works
- [ ] State updates correctly when subscription expires (in Sandbox, this happens quickly)
- [ ] State updates when app returns to foreground
- [ ] No UserDefaults storage of `isSubscribed`, `isInTrialPeriod`, `userCancelledSubscription`
- [ ] Transaction listener is active
- [ ] State matches StoreKit's `Transaction.currentEntitlements`

## 🔧 Troubleshooting

**Issue**: State still unstable
- **Check**: Is `updateUserStatusFromStoreKit()` being called on app launch and foreground?
- **Check**: Is transaction listener active?
- **Check**: Are there any remaining UserDefaults reads of subscription state?

**Issue**: State doesn't update when subscription expires
- **Check**: Is `checkCancellationStatus()` being called?
- **Check**: Is expiration date being checked correctly?

**Issue**: Trial period calculation wrong
- **Check**: Is `autoSubscriptionDate` being set correctly?
- **Check**: Is the 3-day calculation correct?

