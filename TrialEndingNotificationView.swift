import SwiftUI

struct TrialEndingNotificationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingTrialEnded = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "clock.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                
                Text("Trial Ending Soon")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Your free trial will end in 24 hours. After that, you'll have a 3-minute daily limit for smile detection.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("After trial ends:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    FeatureRow(icon: "timer", title: "3-Minute Daily Limit", description: "Combined usage for both Smile Training and Monitoring")
                    FeatureRow(icon: "checkmark.circle", title: "Full Access to All Features", description: "All question sets, analytics, and smile detection remain available")
                    FeatureRow(icon: "infinity", title: "Unlimited Practice Sessions", description: "No restrictions on number of practice sessions per day")
                    FeatureRow(icon: "wifi.slash", title: "No Internet Required", description: "Convenience and privacy - works completely offline")
                }
                .padding()
                .background(Color(.systemBackground).opacity(0.9))
                .cornerRadius(15)
                .padding(.horizontal)
                
                VStack(spacing: 12) {
                    Button(action: {
                        // Resubscribe - show paywall
                        presentationMode.wrappedValue.dismiss()
                        // Post notification to show subscription paywall
                        NotificationCenter.default.post(name: Notification.Name("ShowSubscriptionPaywall"), object: nil)
                    }) {
                        Text("Resubscribe Now")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color.blue)
                            .cornerRadius(15)
                    }
                    
                    Button(action: {
                        // Continue with trial - dismiss popup and return to WelcomeView
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Continue with Trial")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color(.systemGray5))
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 40)
        }
        .background(Color(.systemBackground))
        .cornerRadius(25)
        .shadow(radius: 20)
        .padding(.horizontal, 20)
        .frame(maxWidth: 500) // Limit width for iPad landscape
        .frame(maxHeight: .infinity) // Allow full height
        .fullScreenCover(isPresented: $showingTrialEnded) {
            FreeTrialEndedView()
        }
    }
}

struct TrialEndingNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        TrialEndingNotificationView()
    }
}
