// CancellationFlowView.swift
import SwiftUI

struct CancellationFlowView: View {
    @StateObject private var purchaseManager = SimplePurchaseManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showingCancelConfirmation = false
    @State private var showingCancellationConfirmed = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                    
                    Text("Purchase Status")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                // Current Status
                VStack(spacing: 8) {
                    Text("Current Status")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    if purchaseManager.isPurchased {
                        Text("Premium Active")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                        
                        Text("Unlimited access to all features")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        Text("Free Plan Member")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                        
                        Text("3-minute daily limit")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Actions
                VStack(spacing: 16) {
                    if !purchaseManager.isPurchased {
                        Button("Purchase Unlimited Access") {
                            NotificationCenter.default.post(name: Notification.Name("ShowSubscriptionPaywall"), object: nil)
                            dismiss()
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    
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
                
                Spacer()
            }
            .padding(24)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        // Removed cancellation sheets - not needed for one-time purchase
    }
}

// MARK: - Cancel Subscription Confirmation View
struct CancelSubscriptionConfirmationView: View {
    @StateObject private var purchaseManager = SimplePurchaseManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Warning Icon
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
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("If you need assistance with your purchase, please contact support.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                // Buttons
                VStack(spacing: 12) {
                    Button("Contact Support") {
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

// MARK: - Cancellation Confirmed View
struct CancellationConfirmedView: View {
    @StateObject private var purchaseManager = SimplePurchaseManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                // Success Icon
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                // Title
                Text("Cancellation Confirmed")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                // Message for one-time purchase
                VStack(spacing: 16) {
                    if purchaseManager.isPurchased {
                        VStack(spacing: 8) {
                            Text("Thank you for your purchase!")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text("You now have unlimited access to all features.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, 16)
                        }
                    } else {
                        VStack(spacing: 8) {
                            Text("You're currently on the Free Plan.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text("Upgrade to unlock unlimited access to all features.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, 16)
                        }
                    }
                }
                
                // Continue Button
                Button("Continue Using App") {
                    dismiss()
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(12)
                }
                .padding(24)
            }
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
struct CancellationFlowView_Previews: PreviewProvider {
    static var previews: some View {
        CancellationFlowView()
    }
}
