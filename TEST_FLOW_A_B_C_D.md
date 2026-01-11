# A/B/C/D Sandbox Testing Guide

## Test Flow Overview

### A: Main Paywall → "Free Trial Active"
**Steps:**
1. Launch app → Main Paywall appears
2. Purchase via Sandbox
3. **Expected Result:** Status = "Free Trial Active"
4. **Verify:** `isSubscribed = true`, `isInTrialPeriod = true`, `userCancelledSubscription = false`

### C: Cancel from A → "Trial Ends then switch to Free Plan"
**Steps:**
1. Start from Test A (Free Trial Active)
2. Go to Settings → "Manage Subscription"
3. Cancel subscription in Sandbox
4. Return to app
5. Tap "Detect Cancellation (After Sandbox Cancel)" button OR "Mark as Cancelled (Testing)" button
6. **Expected Result:** Status = "Trial Ends then switch to Free Plan"
7. **Verify:** `isSubscribed = true`, `isInTrialPeriod = true`, `userCancelledSubscription = true`

### B: Resubscribe from C → "Premium Active"
**Steps:**
1. Start from Test C (Trial Ends then switch to Free Plan)
2. Go to Settings → "Subscribe" or "Resubscribe"
3. Purchase via Sandbox
4. **Expected Result:** Status = "Premium Active" + Congratulations popup
5. **Verify:** `isSubscribed = true`, `isInTrialPeriod = false`, `userCancelledSubscription = false`

### D: Cancel from B → "Premium Active (Cancelled)"
**Steps:**
1. Start from Test B (Premium Active)
2. Go to Settings → "Manage Subscription"
3. Cancel subscription in Sandbox
4. Return to app
5. Tap "Detect Cancellation (After Sandbox Cancel)" button OR "Mark as Cancelled (Testing)" button
6. **Expected Result:** Status = "Premium Active (Cancelled)" + Cancellation confirmation popup
7. **Verify:** `isSubscribed = true`, `isInTrialPeriod = false`, `userCancelledSubscription = true`

## Current Implementation Status

✅ **A**: New purchase → Sets `isInTrialPeriod = true` → "Free Trial Active"
✅ **C**: Cancellation during trial → Sets `userCancelledSubscription = true` → "Trial Ends then switch to Free Plan"
✅ **B**: Re-subscription from cancelled trial → Sets `isInTrialPeriod = false` → "Premium Active"
✅ **D**: Cancellation of premium → Sets `userCancelledSubscription = true` → "Premium Active (Cancelled)"

## Testing Notes

- Sandbox cancellations may require manual "Detect Cancellation" button due to StoreKit delays
- Use "Mark as Cancelled (Testing)" button for immediate testing without waiting for StoreKit
- All flows rely on the centralized `subscriptionState` computed property for consistency

