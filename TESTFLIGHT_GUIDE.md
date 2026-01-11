# TestFlight Upload Guide for CheerLens

## Part 1: App Icon Setup

### Option A: Using Xcode Asset Catalog (Recommended)

1. **Open Xcode** → Open your project
2. **Navigate to**: `SmileDetectionApp/Assets.xcassets/AppIcon.appiconset`
3. **Create your app icon**:
   - You need a **1024x1024 pixel** PNG image
   - No transparency (use solid background)
   - Design should be clear and recognizable at small sizes
   - For "CheerLens", consider a smile/lens/camera theme

4. **In Xcode Asset Catalog**:
   - Click on `AppIcon` in the asset catalog
   - Drag your 1024x1024 image to the "App Store" slot (1024x1024)
   - Xcode will automatically generate all required sizes

### Option B: Using Online Icon Generator

1. Create a 1024x1024 PNG icon
2. Use tools like:
   - [AppIcon.co](https://www.appicon.co) - Upload one image, get all sizes
   - [IconKitchen](https://icon.kitchen) - Google's icon generator
3. Download the generated `AppIcon.appiconset` folder
4. Replace the existing folder in your project

### Icon Requirements:
- **Size**: 1024x1024 pixels
- **Format**: PNG (no transparency)
- **Content**: Should represent your app (smile/camera/lens theme for CheerLens)

---

## Part 2: Build and Upload to TestFlight

### Step 1: Prepare in Xcode

1. **Open your project** in Xcode
2. **Select your target**: Click on "SmileDetectionApp" in the project navigator
3. **Go to "Signing & Capabilities" tab**:
   - Ensure "Automatically manage signing" is checked
   - Select your Team (Apple Developer account)
   - Verify Bundle Identifier: `com.mikelin.SmileDetectionApp` (or your custom one)

### Step 2: Update Version and Build Number

1. **Select your target** → "General" tab
2. **Version**: `1.0.0` (or increment if updating)
3. **Build**: Increment this number (e.g., `1`, `2`, `3` for each upload)
   - First upload: Build `1`
   - Updates: Build `2`, `3`, etc.

### Step 3: Archive the Build

1. **Select "Any iOS Device"** (or a connected device) in the device selector (top toolbar)
   - ⚠️ **Important**: Do NOT select a simulator
2. **Product menu** → **Archive**
   - Or press: `Cmd + Shift + B` then click "Archive"
3. **Wait for build to complete** (may take 5-10 minutes)

### Step 4: Upload to App Store Connect

1. **Organizer window opens** automatically after archive completes
2. **Select your archive** (latest one)
3. **Click "Distribute App"**
4. **Select distribution method**:
   - Choose **"App Store Connect"**
   - Click **"Next"**
5. **Distribution options**:
   - Choose **"Upload"** (not "Export")
   - Click **"Next"**
6. **App Store Connect options**:
   - ✅ Check "Upload your app's symbols" (for crash reports)
   - ✅ Check "Manage Version and Build Number" (if you want Xcode to manage it)
   - Click **"Next"**
7. **Review and upload**:
   - Review the summary
   - Click **"Upload"**
   - Wait for upload to complete (may take 10-20 minutes)

---

## Part 3: Configure in App Store Connect

### Step 1: Access App Store Connect

1. Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
2. Sign in with your Apple Developer account
3. Click **"My Apps"**

### Step 2: Create App (First Time Only)

If this is your first upload:
1. Click **"+"** button → **"New App"**
2. Fill in:
   - **Platform**: iOS
   - **Name**: CheerLens
   - **Primary Language**: English (or your preference)
   - **Bundle ID**: Select `com.mikelin.SmileDetectionApp`
   - **SKU**: Unique identifier (e.g., `cheerlens-001`)
   - **User Access**: Full Access (or Limited if you have a team)
3. Click **"Create"**

### Step 3: Wait for Processing

1. After upload, go to **"TestFlight"** tab in App Store Connect
2. Your build will show as **"Processing"** (takes 10-30 minutes)
3. Once processed, status changes to **"Ready to Submit"**

### Step 4: Add Test Information (Required for TestFlight)

1. In **TestFlight** tab, select your build
2. Click **"Add Test Information"** or **"Provide Export Compliance"**
3. **Export Compliance**:
   - Answer: "Does your app use encryption?"
   - For CheerLens: Likely **"No"** (unless you use HTTPS, which is standard)
   - If unsure, answer **"Yes"** and select "Uses encryption but exempt"
4. **Beta App Information** (optional but recommended):
   - Add "What to Test" notes
   - Add feedback email: `michaellin5477@gmail.com`

### Step 5: Add Internal Testers (Optional)

1. Go to **"Internal Testing"** section
2. Click **"+"** to add testers
3. Add your Apple ID email addresses
4. They'll receive an email invitation

### Step 6: Add External Testers (For Beta Testing)

1. Go to **"External Testing"** section
2. Click **"+"** to create a new group
3. **Add testers**:
   - Enter email addresses (up to 10,000)
   - Or create a public link (after App Review)
4. **Submit for Beta App Review** (required for external testers):
   - Fill in required information
   - Submit for review (takes 24-48 hours)

---

## Part 4: TestFlight App Review (For External Testers)

If you want external testers (beyond 100 internal testers), you need:

1. **App Information**:
   - Privacy Policy URL (or in-app)
   - Contact information
   - Demo account (if needed)

2. **Beta App Review Information**:
   - What to test
   - Notes for reviewers
   - App description

3. **Submit for Review**:
   - Apple reviews TestFlight builds (usually 24-48 hours)
   - Once approved, external testers can download

---

## Quick Checklist Before Upload

- [ ] App icon (1024x1024) added to Asset Catalog
- [ ] Version and Build number updated
- [ ] Debug buttons wrapped in `#if DEBUG` (already done)
- [ ] App name set to "CheerLens" in Info.plist
- [ ] Privacy descriptions complete
- [ ] Support email configured (`michaellin5477@gmail.com`)
- [ ] Tested in Release configuration
- [ ] Archive built successfully
- [ ] Uploaded to App Store Connect

---

## Troubleshooting

### "No accounts with App Store Connect access"
- Go to Xcode → Preferences → Accounts
- Add your Apple ID
- Select your team

### "Bundle identifier already exists"
- Use a unique Bundle ID
- Or use existing app if updating

### "Invalid Bundle"
- Check signing & capabilities
- Ensure "Any iOS Device" is selected (not simulator)
- Clean build folder: Product → Clean Build Folder

### Build takes too long
- Normal for first build (5-10 minutes)
- Check internet connection
- Close other apps

---

## Next Steps After TestFlight

1. **Test thoroughly** with internal testers
2. **Gather feedback** through TestFlight
3. **Fix any issues** found
4. **Upload new build** (increment Build number)
5. **Submit for App Store Review** when ready

Good luck with your TestFlight submission! 🚀

