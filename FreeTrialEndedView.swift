import SwiftUI

struct FreeTrialEndedView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "hourglass.bottomhalf.filled")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                
                Text("Free Trial Ended")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Your free trial has ended. You now have a 3-minute daily limit for smile detection.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your new limits:")
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
                        // Continue with free plan - transition to Scenario 4 Free Plan status
                        NotificationCenter.default.post(name: Notification.Name("TransitionToFreePlan"), object: nil)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Continue with Free Plan")
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
    }
}

struct FreeTrialEndedView_Previews: PreviewProvider {
    static var previews: some View {
        FreeTrialEndedView()
    }
}
