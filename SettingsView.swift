// SettingsView.swift
import SwiftUI

struct SettingsView: View {
    @StateObject private var purchaseManager = SimplePurchaseManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showingCancellationFlow = false
    @State private var showingSubscriptionPaywall = false
    @State private var showingDebugTimeControls = false
    @State private var showingSupport = false
    @State private var showingPrivacyPolicy = false
    @State private var showingTermsOfService = false
    
    var body: some View {
        NavigationView {
            List {
                // Purchase Status Section - One-time purchase status
                Section("PURCHASE STATUS") {
                    purchaseStatusView
                }
                
                // Support Section
                Section("SUPPORT") {
                        Button(action: {
                        showingSupport = true
                        }) {
                            HStack {
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title3)
                            
                            Text("Support")
                                    .foregroundColor(.primary)
                            
                                Spacer()
                            
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                }
                
                // App Information Section
                Section {
                    Button(action: {
                        showingPrivacyPolicy = true
                    }) {
                        HStack {
                            Text("Privacy Policy")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        showingTermsOfService = true
                    }) {
                        HStack {
                            Text("Terms of Service")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    HStack {
                        Text("Version")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
                
                // Debug Time Controls Section
                #if DEBUG
                Section("DEBUG TIME CONTROLS") {
                    Button(action: {
                        showingDebugTimeControls = true
                    }) {
                        HStack {
                            Text("Show Debug Time Controls")
                                .foregroundColor(.blue)
                            Spacer()
                            Image(systemName: "clock")
                                .foregroundColor(.blue)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Reset Paywall for Testing
                    Button(action: {
                        UserDefaults.standard.set(false, forKey: "hasSeenPaywall")
                        print("🔍 DEBUG: Reset hasSeenPaywall flag - paywall will show on next app launch")
                    }) {
                        HStack {
                            Text("Reset Paywall (Show on Next Launch)")
                                .foregroundColor(.orange)
                            Spacer()
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.orange)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Reset All Debug Settings
                    Button(action: {
                        UserDefaults.standard.set(false, forKey: "hasSeenPaywall")
                        UserDefaults.standard.set(false, forKey: "debug_time_acceleration_enabled")
                        UserDefaults.standard.removeObject(forKey: "debug_current_virtual_time")
                        UserDefaults.standard.removeObject(forKey: "debug_virtual_start_time")
                        UserDefaults.standard.set(1.0, forKey: "debug_time_acceleration_multiplier")
                        print("🔍 DEBUG: Reset all debug settings - app will behave naturally")
                    }) {
                        HStack {
                            Text("Reset All Debug Settings")
                                .foregroundColor(.red)
                            Spacer()
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Time Controls (6 buttons as per screenshot)
                    VStack(spacing: 8) {
                        HStack {
                            Text("Time Controls (ProvideTimer)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            // Show debug mode status
                            let debugManager = DebugTimeManager.shared
                            if debugManager.isTimeAccelerationEnabled {
                                Text("ON")
                                    .font(.caption2)
                                    .foregroundColor(.green)
                                    .fontWeight(.bold)
                            } else {
                                Text("OFF")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Text("⚠️ Debug mode auto-enables when you tap time buttons. Start from Test A (Free Trial Active) for best results.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 4)
                        
                        // Reset Time Controls button
                        Button(action: {
                            let debugManager = DebugTimeManager.shared
                            let now = Date()
                            debugManager.virtualStartTime = now
                            debugManager.currentVirtualTime = now
                            debugManager.manualElapsedTime = 0
                            debugManager.saveDebugSettings()
                            print("⏰ DEBUG: Reset time controls")
                        }) {
                            Text("Reset Time Controls")
                                .font(.caption2)
                                .foregroundColor(.orange)
                        }
                        .padding(.bottom, 4)
                        
                        // Top row: +15 Min, +30 Min, +1 Hour
                        HStack(spacing: 8) {
                            Button("+15 Min") {
                                let debugManager = DebugTimeManager.shared
                                debugManager.advanceTime(by: 15 * 60) // 15 minutes
                            }
                            .buttonStyle(PlainButtonStyle())
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue)
                            .cornerRadius(6)
                            
                            Button("+30 Min") {
                                let debugManager = DebugTimeManager.shared
                                debugManager.advanceTime(by: 30 * 60) // 30 minutes
                            }
                            .buttonStyle(PlainButtonStyle())
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue)
                            .cornerRadius(6)
                            
                            Button("+1 Hour") {
                                let debugManager = DebugTimeManager.shared
                                debugManager.advanceTime(by: 60 * 60) // 1 hour
                            }
                            .buttonStyle(PlainButtonStyle())
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue)
                            .cornerRadius(6)
                        }
                        
                        // Bottom row: +2 Hours, +6 Hours, +1 Day
                        HStack(spacing: 8) {
                            Button("+2 Hours") {
                                let debugManager = DebugTimeManager.shared
                                debugManager.advanceTime(by: 2 * 60 * 60) // 2 hours
                            }
                            .buttonStyle(PlainButtonStyle())
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue)
                            .cornerRadius(6)
                            
                            Button("+6 Hours") {
                                let debugManager = DebugTimeManager.shared
                                debugManager.advanceTime(by: 6 * 60 * 60) // 6 hours
                            }
                            .buttonStyle(PlainButtonStyle())
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue)
                            .cornerRadius(6)
                            
                            Button("+1 Day") {
                                let debugManager = DebugTimeManager.shared
                                debugManager.advanceTime(by: 24 * 60 * 60) // 1 day
                            }
                            .buttonStyle(PlainButtonStyle())
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue)
                            .cornerRadius(6)
                        }
                    }
                    .padding(.vertical, 4)
                    
                    // Debug Status and Control Buttons
                    Button(action: {
                        // Simple test button
                        print("🔍 SIMPLE TEST: Button works!")
                    }) {
                        HStack {
                            Text("Simple Test Button")
                                .foregroundColor(.red)
                            Spacer()
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.red)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        // Check current debug mode status
                        print("🔍 DEBUG STATUS: Starting check...")
                        let debugManager = DebugTimeManager.shared
                        print("🔍 DEBUG STATUS: isTimeAccelerationEnabled = \(debugManager.isTimeAccelerationEnabled)")
                        print("🔍 DEBUG STATUS: currentTestScenario = \(debugManager.currentTestScenario.rawValue)")
                    }) {
                        HStack {
                            Text("Check Debug Status")
                                .foregroundColor(.blue)
                            Spacer()
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        // Disable debug mode for natural Sandbox testing
                        print("🔄 DEBUG: Button tapped - disabling debug mode")
                        DebugTimeManager.shared.disableDebugModeForNaturalTesting()
                        print("🔄 DEBUG: Debug mode disabled for natural testing")
                    }) {
                        HStack {
                            Text("Disable Debug Mode (Natural Testing)")
                                .foregroundColor(.green)
                            Spacer()
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            #endif
            
            // Testing Section (simplified for one-time purchase)
            #if DEBUG
            Section("TESTING") {
                    Button(action: {
                        // Reset purchase status and paywall flag
                        UserDefaults.standard.set(false, forKey: "hasSeenPaywall")
                        UserDefaults.standard.removeObject(forKey: "dailyUsageTime")
                        UserDefaults.standard.removeObject(forKey: "lastUsageDate")
                        Task {
                            await purchaseManager.checkPurchaseStatus()
                        }
                        dismiss()
                    }) {
                        HStack {
                            Text("Reset to Fresh Install")
                                .foregroundColor(.orange)
                            Spacer()
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.orange)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        // Manually set as purchased for testing
                        purchaseManager.isPurchased = true
                        purchaseManager.currentStatusMessage = ""
                        print("🧪 Testing: Manually set as purchased")
                    }) {
                        HStack {
                            Text("Set as Purchased (Testing)")
                                .foregroundColor(.green)
                            Spacer()
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        // Manually set as free plan for testing
                        purchaseManager.isPurchased = false
                        purchaseManager.currentStatusMessage = "Free Plan Member"
                        print("🧪 Testing: Manually set as free plan")
                    }) {
                        HStack {
                            Text("Set as Free Plan (Testing)")
                                .foregroundColor(.blue)
                            Spacer()
                            Image(systemName: "clock")
                                .foregroundColor(.blue)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                    
                    Button(action: {
                        // Manual check for purchase status
                        Task {
                            await purchaseManager.checkPurchaseStatus()
                        }
                    }) {
                        HStack {
                            Text("Check Purchase Status")
                                .foregroundColor(.blue)
                            Spacer()
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.blue)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                    
                    Button(action: {
                        // Debug: Check all entitlements
                        Task {
                            #if DEBUG
                            await purchaseManager.debugCheckAllEntitlements()
                            #endif
                        }
                    }) {
                        HStack {
                            Text("Debug: Check All Entitlements")
                                .foregroundColor(.purple)
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.purple)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        // Debug: Force reset local purchase status and disable auto-restore
                        #if DEBUG
                        purchaseManager.debugResetPurchaseStatus()
                        #endif
                    }) {
                        HStack {
                            Text("Debug: Reset to Free Plan (Disable Auto-Restore)")
                                .foregroundColor(.orange)
                            Spacer()
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .foregroundColor(.orange)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    #if DEBUG
                    Button(action: {
                        // Debug: Toggle auto-restore on/off
                        let isDisabled = purchaseManager.debugIsAutoRestoreDisabled()
                        purchaseManager.debugSetSkipAutoRestore(!isDisabled)
                    }) {
                        HStack {
                            if purchaseManager.debugIsAutoRestoreDisabled() {
                                Text("Debug: Enable Auto-Restore")
                                    .foregroundColor(.green)
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Text("Debug: Disable Auto-Restore")
                                    .foregroundColor(.orange)
                                Spacer()
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if purchaseManager.debugIsAutoRestoreDisabled() {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("🧪 Testing Mode Active")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.orange)
                            Text("Auto-restore is DISABLED. App restart will NOT restore purchase automatically. Click 'Restore Purchases' button in Purchase Status section to test manual restore.")
                                .font(.caption2)
                                .foregroundColor(.orange.opacity(0.8))
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                    #endif
                }
            #endif
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingCancellationFlow) {
            CancellationFlowView()
        }
        .sheet(isPresented: $showingSubscriptionPaywall) {
            SubscriptionView()
        }
        .sheet(isPresented: $showingSupport) {
            SupportView()
        }
        .sheet(isPresented: $showingPrivacyPolicy) {
            PrivacyPolicyView()
        }
        .sheet(isPresented: $showingTermsOfService) {
            TermsOfServiceView()
        }
        .sheet(isPresented: $showingDebugTimeControls) {
            DebugTimeControlsView()
        }
    }
    
    // MARK: - Purchase Status View (One-time purchase)
    @ViewBuilder
    private var purchaseStatusView: some View {
        if purchaseManager.isPurchased {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Premium Active")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                    Spacer()
                }
                Text("Unlimited access to all features")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
            
            Button(action: {
                Task {
                    await purchaseManager.restorePurchases()
                }
            }) {
                HStack {
                    Text("Restore Purchases")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            .buttonStyle(PlainButtonStyle())
        } else {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Free Plan Member")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Spacer()
                }
                Text("3-minute daily limit")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
            
            Button(action: {
                dismiss()
                NotificationCenter.default.post(name: Notification.Name("ShowSubscriptionPaywall"), object: nil)
            }) {
                HStack {
                    Text("Purchase Unlimited Access")
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                        .font(.caption)
                }
            }
            
            Button(action: {
                Task {
                    await purchaseManager.restorePurchases()
                }
            }) {
                HStack {
                    Text("Restore Purchases")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

// MARK: - Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}







