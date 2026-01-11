import SwiftUI

struct CancellationAcknowledgmentView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var purchaseManager = SimplePurchaseManager.shared
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("Purchase Status")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            if purchaseManager.isPurchased {
                Text("Thank you for your purchase! You now have unlimited access to all features.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                Text("You're currently on the Free Plan with a 3-minute daily limit. Upgrade to unlock unlimited access.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            VStack(spacing: 12) {
                Button(action: {
                    // Return to main WelcomeView (Screen 2) - dismiss all modal screens
                    NotificationCenter.default.post(name: Notification.Name("ReturnToWelcome"), object: nil)
                }) {
                    Text("Continue Using App")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.green)
                        .cornerRadius(15)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 40)
        .background(Color(.systemBackground))
        .cornerRadius(25)
        .shadow(radius: 20)
        .padding(.horizontal, 20)
    }
}

struct CancellationAcknowledgmentView_Previews: PreviewProvider {
    static var previews: some View {
        CancellationAcknowledgmentView()
    }
}
