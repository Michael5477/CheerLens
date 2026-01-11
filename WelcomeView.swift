// MARK: - Welcome View with Route Selection
// WelcomeView.swift

import SwiftUI

struct WelcomeView: View {
    @State private var showingRouteA = false
    @State private var showingRouteB = false
    @State private var showingSettings = false
    @State private var showingSubscription = false
    // Removed: showingPaywall - no Main Paywall in simplified flow
    @State private var showingCongratulation = false
    @State private var showingTrialEndingSoon = false
    @State private var showingFreeTrialEnded = false
    @State private var showingCancellationConfirmation = false
    @StateObject private var purchaseManager = SimplePurchaseManager.shared
    @State private var countdownTimer: Timer?
    @State private var countdownUpdateTrigger = false
    @State private var titleFadeTimer: Timer?
    @State private var showTitle = false
    @State private var titleOpacity: Double = 1.0
    @State private var statusUpdateTrigger = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: geometry.size.height < 700 ? 12 : 20) {
                    // Header
                    headerView
                    
                    // App Icon/Logo
                    Image(systemName: "face.smiling.fill")
                        .font(.system(size: geometry.size.height < 700 ? 60 : 80))
                        .foregroundColor(.blue)
                    
                    VStack(spacing: 12) {
                        Text("Remote Interview")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text("Smiley Interview Coach")
                            .font(geometry.size.height < 700 ? .title : .largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.8)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Text("Choose your practice mode")
                        .font(geometry.size.height < 700 ? .caption : .subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Subscription Status
                    subscriptionStatusView
                    
                    // Route Selection
                    routeSelectionView(geometry: geometry)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity)
                .frame(minHeight: geometry.size.height)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingRouteA) {
            RouteA_SmileTrainingView()
        }
        .fullScreenCover(isPresented: $showingRouteB) {
            RouteB_SmileMonitoringView()
        }
        .sheet(isPresented: $showingSubscription) {
            SubscriptionView()
        }
        // Removed: Main Paywall - no longer needed in simplified flow
        // Purchase only available from "Daily Limit Reached" window
        .sheet(isPresented: $showingCongratulation) {
            CongratulationView()
        }
        .sheet(isPresented: $showingTrialEndingSoon) {
            TrialEndingNotificationView()
        }
        .sheet(isPresented: $showingFreeTrialEnded) {
            FreeTrialEndedView()
        }
        .sheet(isPresented: $showingCancellationConfirmation) {
            SmartCancellationConfirmationView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        // Removed: All subscription-related popups (cancellation, congratulation, trial ending, etc.)
        // Simplified model only needs Daily Limit Reached popup
        .sheet(isPresented: $purchaseManager.shouldShowDailyLimitReached) {
            DailyLimitReachedView()
        }
        .onAppear {
            // Simplified: No paywall on app launch - user directly enters Free Plan Member
            // Purchase only available from "Daily Limit Reached" popup
            
            // Check purchase status when app becomes active
            Task {
                await purchaseManager.checkPurchaseStatus()
            }
            
            // Start countdown timer for Scenario 1 and 3
            startCountdownTimer()
            
            // Check if we should show title fade-out for current status
            checkAndShowTitleFadeOut()
            
            // Refresh subscription status when app becomes active
            // Note: Purchase status is automatically managed by SimplePurchaseManager
            
            // Listen for return to welcome notification
            NotificationCenter.default.addObserver(
                forName: Notification.Name("ReturnToWelcome"),
                object: nil,
                queue: .main
            ) { _ in
                // Dismiss any modal screens
                showingCancellationConfirmation = false
            }
            
            // Listen for transition to free plan notification
            NotificationCenter.default.addObserver(
                forName: Notification.Name("TransitionToFreePlan"),
                object: nil,
                queue: .main
            ) { _ in
                // Transition to Free Plan status (handled by StoreKit)
                print("📱 Transition to Free Plan - handled by StoreKit")
            }
            
            // Listen for show subscription paywall notification
            NotificationCenter.default.addObserver(
                forName: Notification.Name("ShowSubscriptionPaywall"),
                object: nil,
                queue: .main
            ) { _ in
                // Show subscription paywall
                showingSubscription = true
            }
            
            // Removed: ShowInitialPaywall notification - no Main Paywall in simplified flow
            // Purchase only available from "Daily Limit Reached" window
            
            // Listen for debug scenario changes
            NotificationCenter.default.addObserver(
                forName: Notification.Name("DebugScenarioChanged"),
                object: nil,
                queue: .main
            ) { _ in
                // Force UI refresh when debug scenario changes
                countdownUpdateTrigger.toggle()
            }
            
            // Listen for subscription status changes
            NotificationCenter.default.addObserver(
                forName: Notification.Name("SubscriptionStatusChanged"),
                object: nil,
                queue: .main
            ) { _ in
                // Force UI refresh when subscription status changes
                countdownUpdateTrigger.toggle()
            }
        }
        .onDisappear {
            stopCountdownTimer()
            titleFadeTimer?.invalidate()
            titleFadeTimer = nil
            
            // Remove notification observers
            NotificationCenter.default.removeObserver(self, name: Notification.Name("ReturnToWelcome"), object: nil)
            NotificationCenter.default.removeObserver(self, name: Notification.Name("TransitionToFreePlan"), object: nil)
            NotificationCenter.default.removeObserver(self, name: Notification.Name("ShowSubscriptionPaywall"), object: nil)
            // Removed: ShowInitialPaywall observer - no Main Paywall in simplified flow
            NotificationCenter.default.removeObserver(self, name: Notification.Name("DebugScenarioChanged"), object: nil)
            NotificationCenter.default.removeObserver(self, name: Notification.Name("SubscriptionStatusChanged"), object: nil)
        }
        // Removed: All subscription-related observers (congratulation, trial ending, cancellation, etc.)
        // Simplified model doesn't need these
        .onReceive(purchaseManager.$isPurchased) { _ in
            // Force UI refresh when purchase status changes
            countdownUpdateTrigger.toggle()
            statusUpdateTrigger.toggle()
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 20) {
            // Top Row with Settings Icon
            HStack {
                Spacer()
                
                Button(action: {
                    showingSettings = true
                }) {
                    Image(systemName: "gearshape")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Subscription Status View (Simplified - only shows Free Plan Member or empty)
    private var subscriptionStatusView: some View {
        VStack(spacing: 8) {
            // Simplified: Only show "Free Plan Member" if not purchased, empty if purchased
            if !purchaseManager.isPurchased {
                // Free Plan Member
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.gray)
                        Text("Free Plan Member")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                    }
                    
                    Text("Limited access: 3 minutes/day")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    // Daily Usage Countdown Bar
                    VStack(spacing: 4) {
                        let remainingTime = purchaseManager.remainingTime()
                        let remainingMinutes = remainingTime.isFinite ? Int(remainingTime) / 60 : 0
                        let remainingSeconds = remainingTime.isFinite ? Int(remainingTime) % 60 : 0
                        
                        ProgressView(value: purchaseManager.usagePercentage())
                            .progressViewStyle(LinearProgressViewStyle())
                            .frame(width: 150)
                            .tint(.gray)
                        
                        Text("\(remainingMinutes):\(String(format: "%02d", remainingSeconds)) remaining today")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .id(countdownUpdateTrigger)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(20)
            }
            // If purchased, show nothing (no status displayed)
        }
        .id(statusUpdateTrigger)
    }
    
    // MARK: - Route Selection View
    private func routeSelectionView(geometry: GeometryProxy) -> some View {
        VStack(spacing: geometry.size.height < 700 ? 12 : 20) {
            // Route A - Smile Training
            Button(action: {
                showingRouteA = true
            }) {
                VStack(spacing: geometry.size.height < 700 ? 8 : 12) {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.system(size: geometry.size.height < 700 ? 40 : 50))
                        .foregroundColor(.blue)
                    
                    Text("Smile Training")
                        .font(geometry.size.height < 700 ? .title3 : .title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Practice with interview questions")
                        .font(geometry.size.height < 700 ? .caption : .subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, geometry.size.height < 700 ? 20 : 30)
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Monitoring - Smile Monitoring
            Button(action: {
                showingRouteB = true
            }) {
                VStack(spacing: geometry.size.height < 700 ? 8 : 12) {
                    Image(systemName: "eye.fill")
                        .font(.system(size: geometry.size.height < 700 ? 40 : 50))
                        .foregroundColor(.purple)
                    
                    Text("Smile Monitor")
                        .font(geometry.size.height < 700 ? .title3 : .title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Monitor your smile in real-time")
                        .font(geometry.size.height < 700 ? .caption : .subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, geometry.size.height < 700 ? 20 : 30)
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    // MARK: - Timer Management
    private func startCountdownTimer() {
        // Start timer for trial countdown, daily usage, or Free Plan users
        // Simplified: No timer needed for one-time purchase model
        let shouldStartTimer = false
        
        print("🕐 Timer check: Simplified model - no timer needed")
        
        if shouldStartTimer {
            print("🕐 Starting countdown timer...")
            countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                print("🕐 Timer tick - updating UI")
                countdownUpdateTrigger.toggle()
            }
        } else {
            print("🕐 Timer NOT started - conditions not met")
        }
    }
    
    private func stopCountdownTimer() {
        countdownTimer?.invalidate()
        countdownTimer = nil
    }
    
    // MARK: - Title Fade Out Management
    private func showTitleWithFadeOut(duration: Double) {
        // Show title immediately
        showTitle = true
        titleOpacity = 1.0
        
        // Start fade timer
        titleFadeTimer?.invalidate()
        titleFadeTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            // Start fade out animation
            withAnimation(.easeOut(duration: 2.0)) {
                titleOpacity = 0.0
            }
            
            // Hide title after fade animation completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                showTitle = false
                titleOpacity = 1.0 // Reset for next time
            }
        }
    }
    
    // MARK: - Check Title Fade Out
    private func checkAndShowTitleFadeOut() {
        // Simplified: No title fade-out needed for one-time purchase model
        // Just show title normally
    }
}

// MARK: - Smart Cancellation Confirmation View
struct SmartCancellationConfirmationView: View {
    @StateObject private var purchaseManager = SimplePurchaseManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Icon
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                
                // Title
                Text("Cancel Subscription?")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                // Message for one-time purchase
                VStack(spacing: 12) {
                    Text("One-time purchases cannot be cancelled through the app.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Text("If you need assistance, please contact support.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                // Buttons
                VStack(spacing: 12) {
                    Button("Contact Support") {
                        // Open support or dismiss
                        dismiss()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    
                    Button("Close") {
                        dismiss()
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .padding(24)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
