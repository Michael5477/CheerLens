# How to Test Release Build from Xcode

## The Issue
When you use **Product > Run** in Xcode, it builds and runs a **Debug** build by default. This means:
- Debug buttons are visible (wrapped in `#if DEBUG`)
- Not representative of what TestFlight users will see
- StoreKit may behave differently

## Solution: Run Release Build from Xcode

### Method 1: Change Build Configuration (Recommended)

1. **In Xcode, click on the scheme selector** (next to the device selector at the top)
   - It currently shows: "SmileDetectionApp" > "Any iOS Device"
   
2. **Click "Edit Scheme..."**

3. **In the left sidebar, select "Run"**

4. **In the "Info" tab, change "Build Configuration" from "Debug" to "Release"**

5. **Click "Close"**

6. **Now when you click "Product > Run"**, it will build and run a **Release** build
   - Debug buttons will be hidden ✅
   - Matches what TestFlight users will see ✅

### Method 2: Use Archive (For Distribution Testing)

1. **Select "Any iOS Device"** (not a simulator)
2. **Product > Archive**
3. **After archive completes, click "Distribute App"**
4. **Choose "Development"** (for testing on your device)
5. **Select your device**
6. **Install on device**

This installs a Release build directly on your device.

---

## Quick Comparison

| Method | Build Type | Debug Buttons | Use Case |
|--------|-----------|---------------|----------|
| Product > Run (default) | Debug | ✅ Visible | Quick code testing |
| Product > Run (Release scheme) | Release | ❌ Hidden | TestFlight prep testing |
| Product > Archive > Distribute | Release | ❌ Hidden | Final testing before upload |

---

## Recommended Workflow for TestFlight Prep

1. **Change scheme to Release** (Method 1 above)
2. **Product > Run** (now runs Release build)
3. **Test on device** (debug buttons hidden)
4. **When ready, Archive & Upload** to TestFlight

This way you can test the Release build multiple times without archiving each time!

