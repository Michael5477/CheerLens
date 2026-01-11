# TestFlight Testing Checklist for CheerLens

## Pre-Flight Checks

### Build Configuration
- [ ] Build number incremented (Release: 2, 3, 4, etc.)
- [ ] Version number set (1.0.0)
- [ ] Archive built successfully
- [ ] Uploaded to App Store Connect
- [ ] Build processed in TestFlight (10-30 minutes)
- [ ] Encryption compliance handled (exemption key in Info.plist)

### App Configuration
- [ ] App name: "CheerLens" (not "SmileDetectionApp")
- [ ] App icon set (1024x1024)
- [ ] Debug buttons hidden (wrapped in `#if DEBUG`)
- [ ] Privacy descriptions complete:
  - [ ] Camera usage (ML Kit)
  - [ ] Photo library (screenshot upload)
  - [ ] Microphone removed (not used)

---

## Fresh Install Testing

### Initial Launch
- [ ] App launches successfully
- [ ] Main Paywall appears on first launch
- [ ] Paywall can be dismissed (X button)
- [ ] After dismissing paywall, Home screen shows "Free Plan Member"
- [ ] Settings shows "Free Plan Member" status
- [ ] No debug buttons visible (Release build)

### Home Screen (Free Plan Member)
- [ ] App icon and title display correctly
- [ ] Subscription status card shows:
  - [ ] "Free Plan Member"
  - [ ] "Limited access: 3 minutes/day"
  - [ ] "3:00 remaining today" (or current usage)
- [ ] Countdown bar displays correctly
- [ ] "Smile Training" button available
- [ ] "Smile Monitor" button available
- [ ] Settings button (gear icon) works

---

## Subscription Flow Testing

### Test A: New Subscription (Free Trial Active)
- [ ] From "Free Plan Member", tap "Subscribe" in Settings
- [ ] Paywall appears
- [ ] Complete Sandbox purchase
- [ ] Status changes to "Free Trial Active"
- [ ] Home screen shows "Free Trial Active"
- [ ] Settings shows "Free Trial Active"
- [ ] Countdown bar shows 3-day trial countdown
- [ ] No "Congratulations" popup (only after auto-subscription)

### Test C: Cancel During Trial
- [ ] From "Free Trial Active", go to Settings
- [ ] Tap "Manage Subscription"
- [ ] Cancel subscription in Sandbox
- [ ] Return to app
- [ ] Status changes to "Trial Ends then switch to Free Plan"
- [ ] Home screen shows correct status
- [ ] Settings shows correct status
- [ ] "Trial Ending Soon" popup appears at 24 hours before trial end (if using time controls)

### Test B: Re-subscribe After Cancellation
- [ ] From "Trial Ends then switch to Free Plan", go to Settings
- [ ] Tap "Resubscribe"
- [ ] Complete Sandbox purchase
- [ ] Status changes to "Premium Active" (NOT "Free Trial Active")
- [ ] "Congratulations" popup appears
- [ ] Home screen shows "Premium Active"
- [ ] Settings shows "Premium Active"

### Test D: Cancel Premium Subscription
- [ ] From "Premium Active", go to Settings
- [ ] Tap "Manage Subscription"
- [ ] Cancel subscription in Sandbox
- [ ] Return to app
- [ ] Status changes to "Premium Active (Cancelled)"
- [ ] Home screen shows "Premium Active (Cancelled)"
- [ ] Settings shows "Premium Active (Cancelled)"
- [ ] Subscription remains active until expiry

### Test: Re-subscribe from Free Plan Member
- [ ] From "Free Plan Member", go to Settings
- [ ] Tap "Subscribe"
- [ ] Complete Sandbox purchase
- [ ] Status changes to "Premium Active" (NOT "Free Trial Active")
- [ ] "Congratulations" popup appears
- [ ] Immediately cancel subscription
- [ ] Status changes to "Premium Active (Cancelled)" (NOT "Free Plan Member")

---

## Feature Testing

### Smile Training (Route A)
- [ ] Can start practice session
- [ ] Camera access requested and works
- [ ] Smile detection works in real-time
- [ ] Practice session completes without interruption
- [ ] Results screen displays:
  - [ ] Duration correct
  - [ ] Smile ratio correct
  - [ ] Graph displays correctly (X-axis time scale correct)
  - [ ] Performance analysis shown
- [ ] Can navigate back to Home
- [ ] Usage time tracked correctly

### Smile Monitor (Route B)
- [ ] Can start monitoring session
- [ ] Camera access requested and works
- [ ] Smile detection works in real-time
- [ ] Can stop monitoring manually
- [ ] Results screen displays correctly
- [ ] Usage time tracked correctly

### Daily Usage Limit (Free Plan Member)
- [ ] Usage tracked correctly (Route A + Route B combined)
- [ ] Can initiate practice when under 3 minutes
- [ ] Practice runs uninterrupted once started
- [ ] Cannot initiate NEW practice when over 3 minutes
- [ ] "Daily Limit Reached" popup appears when trying to start new practice
- [ ] Popup shows correct usage (3:00 / 3:00)
- [ ] "Upgrade to Premium" button works
- [ ] "Try Again Tomorrow" button works
- [ ] Daily usage resets correctly (test with time controls if available)

---

## Settings Testing

### Subscription Status Display
- [ ] Status matches Home screen
- [ ] Correct actions available for each state:
  - [ ] Free Plan Member: "Subscribe", "Restore Purchases"
  - [ ] Free Trial Active: "Manage Subscription", "Restore Purchases"
  - [ ] Trial Ends then Free Plan: "Resubscribe", "Restore Purchases"
  - [ ] Premium Active: "Manage Subscription", "Restore Purchases"
  - [ ] Premium Active (Cancelled): "Manage Subscription", "Restore Purchases"

### Support Section
- [ ] "Support" section visible
- [ ] "FAQ" opens correctly
- [ ] All 12 FAQ questions expand/collapse correctly
- [ ] "Send Feedback" opens correctly
- [ ] Feedback form works:
  - [ ] Can enter feedback text
  - [ ] Can enter email (optional)
  - [ ] Can upload screenshot
  - [ ] "Submit" button opens Mail app
  - [ ] Email pre-filled with support@michaellin5477@gmail.com

### Legal Pages
- [ ] "Privacy Policy" opens in-app
- [ ] Privacy Policy scrollable
- [ ] "Data is Secure" section highlighted
- [ ] "Terms of Service" opens in-app
- [ ] Terms of Service scrollable
- [ ] "About" section removed (not visible)

### Version Display
- [ ] Version shows "1.0.0"

---

## Popup Testing

### Congratulations Popup
- [ ] Appears after auto-subscription (trial → premium)
- [ ] Appears after re-subscription from Free Plan
- [ ] Appears after re-subscription from cancelled trial
- [ ] Does NOT appear on new trial purchase
- [ ] Does NOT appear repeatedly
- [ ] Scrollable on iPhone 8 (smaller screens)
- [ ] "Continue" button works

### Trial Ending Soon Popup
- [ ] Appears 24 hours before trial end (for cancelled users only)
- [ ] Does NOT appear for active trial users
- [ ] Scrollable on iPhone 8

### Trial Ended Popup
- [ ] Appears when trial expires (for cancelled users)
- [ ] After dismissal, transitions to "Free Plan Member"
- [ ] Scrollable on iPhone 8

### Cancellation Confirmation Popup
- [ ] Appears after cancelling premium subscription
- [ ] Scrollable on iPhone 8

### Daily Limit Reached Popup
- [ ] Appears when trying to start new practice after 3-minute limit
- [ ] Shows correct usage (3:00 / 3:00)
- [ ] Scrollable on iPhone 8
- [ ] "Upgrade to Premium" button works
- [ ] "Try Again Tomorrow" button works

---

## UI/UX Testing

### Responsiveness
- [ ] All screens scrollable on iPhone 8 (smaller screens)
- [ ] No text truncation issues
- [ ] All buttons accessible
- [ ] No layout issues on different screen sizes

### Navigation
- [ ] Home button works from Results screen
- [ ] Back buttons work correctly
- [ ] Settings accessible from Home
- [ ] Can navigate between all screens

### Visual Elements
- [ ] App icon displays correctly
- [ ] All icons display correctly
- [ ] Colors consistent
- [ ] Text readable
- [ ] Charts/graphs display correctly

---

## Edge Cases

### Restore Purchases
- [ ] From "Free Plan Member" → Restore works correctly
- [ ] From "Free Trial Active" → Restore preserves trial state
- [ ] From "Premium Active" → Restore preserves premium state
- [ ] From "Premium Active (Cancelled)" → Restore preserves cancelled state

### Time Controls (If Debug Mode Available)
- [ ] Time controls advance virtual time correctly
- [ ] Countdown bar updates in real-time
- [ ] Daily usage resets with "+1 Day"
- [ ] Auto-subscription triggers after 3 days
- [ ] Popups appear at correct times

### State Transitions
- [ ] All state transitions work correctly
- [ ] No unexpected state changes
- [ ] Status consistent between Home and Settings
- [ ] No crashes during state changes

---

## Performance Testing

### App Performance
- [ ] App launches quickly (< 3 seconds)
- [ ] No memory leaks
- [ ] Smooth animations
- [ ] No lag during smile detection
- [ ] Camera preview smooth

### Battery Usage
- [ ] Reasonable battery usage during practice
- [ ] Camera stops when app backgrounded

---

## Final Checks Before TestFlight

### App Store Connect
- [ ] Build uploaded successfully
- [ ] Build processed (no errors)
- [ ] Test information added (if required)
- [ ] Export compliance answered
- [ ] Testers added (if using external testing)

### Code Quality
- [ ] No console errors
- [ ] No warnings (or acceptable warnings)
- [ ] All features working
- [ ] No crashes during testing

### Documentation
- [ ] Privacy Policy complete
- [ ] Terms of Service complete
- [ ] Support email configured
- [ ] FAQ complete

---

## TestFlight-Specific Testing

### After TestFlight Installation
- [ ] App installs from TestFlight
- [ ] App launches correctly
- [ ] All features work as expected
- [ ] Subscription flow works with Sandbox
- [ ] Feedback system works
- [ ] No debug elements visible

### Beta Testing Notes
- [ ] Document any issues found
- [ ] Test with real Sandbox accounts
- [ ] Verify all subscription states
- [ ] Test on multiple devices (if available)

---

## Sign-off

- [ ] All critical tests passed
- [ ] No blocking issues
- [ ] Ready for TestFlight distribution
- [ ] Ready for external testers (if applicable)

**Tested by:** _________________  
**Date:** _________________  
**Build Number:** _________________  
**Version:** _________________

---

## Notes Section

_Use this space to document any issues, observations, or notes during testing:_




