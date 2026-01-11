# Sandbox vs Production: Subscription Persistence Issue

## The Problem

**Current Behavior**: After rebuilding the app, StoreKit Sandbox still shows "Premium Active" even if you dismissed the paywall.

## Root Cause Analysis

### Sandbox Testing Limitations
1. **StoreKit Sandbox Persistence**: 
   - StoreKit Sandbox keeps subscriptions across app rebuilds
   - `transaction.finish()` marks transactions as processed, but **does NOT cancel subscriptions**
   - Subscriptions persist until they expire or are manually cancelled via Apple's subscription management UI

2. **Why This Happens**:
   - When you test "Premium Active" → rebuild → dismiss paywall
   - StoreKit Sandbox still has the subscription from previous test
   - Our code correctly detects it and shows "Premium Active"
   - This is **correct behavior** from StoreKit's perspective

### Production Impact

**✅ GOOD NEWS: This is NOT a production issue!**

In production:
- **Real users who purchase** → StoreKit subscription exists → App shows "Premium Active" ✅ **CORRECT**
- **Real users who dismiss paywall** → No StoreKit subscription → App shows "Free Plan Member" ✅ **CORRECT**
- **App updates** → StoreKit subscriptions persist → Users keep their subscriptions ✅ **CORRECT** (this is expected behavior)

The only potential production concern is **stale UserDefaults**, which we already handle:
- We check StoreKit FIRST before loading UserDefaults
- We clear stale flags if StoreKit says no subscription
- StoreKit is the source of truth

## Solution: Sandbox Testing vs Production

### Current Code Logic (Production-Ready)
```swift
// 1. Check StoreKit FIRST (source of truth)
await checkSubscriptionStatus()

// 2. If StoreKit says no subscription, clear stale UserDefaults
if !isSubscribed {
    // Clear all stale flags
}

// 3. Only load UserDefaults if StoreKit confirms subscription
if isSubscribed {
    loadAutoSubscriptionData()
}
```

**This logic is CORRECT for production.**

### Sandbox Testing Issue

The problem is **Sandbox limitations**, not production code:

1. **Sandbox keeps subscriptions** even after app rebuild
2. **We can't "cancel" subscriptions programmatically** - only via Apple's UI
3. **Testing "first launch" scenarios** is difficult because Sandbox remembers previous tests

### Recommended Solutions

#### ✅ Option 1: DEBUG-Only Testing Flag (IMPLEMENTED)
- Added `#if DEBUG` toggle in Settings: "Sandbox: Ignore StoreKit on First Launch"
- When enabled: App ignores StoreKit subscriptions on first launch (simulates fresh install)
- When disabled: App uses normal StoreKit behavior (production-like)
- **This is ONLY in DEBUG builds - never affects production**

**How to use:**
1. Enable the toggle in Settings → Testing section
2. Tap "Reset to Fresh Install" 
3. Rebuild app → First launch will ignore StoreKit subscriptions
4. Disable toggle to test normal StoreKit behavior

#### Option 2: Manual Sandbox Reset
- Use Apple's subscription management UI to cancel subscriptions
- Or use TestFlight's "Reset Subscription" feature
- Or manually finish transactions and accept limitations

#### Option 3: Accept Sandbox Limitations
- Understand that Sandbox testing has limitations
- Test core flows manually
- Trust that production logic is correct (StoreKit is source of truth)

## Conclusion

**Production Impact**: ✅ **NONE** - The code correctly handles production scenarios

**Sandbox Testing**: ⚠️ **Limitation** - Sandbox persists subscriptions, making "first launch" testing difficult

**Recommendation**: 
- Keep current production logic (it's correct)
- Add a debug-only reset button for easier Sandbox testing
- Document that Sandbox testing has limitations
- Test production flows manually via TestFlight

