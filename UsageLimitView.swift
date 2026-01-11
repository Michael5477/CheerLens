// UsageLimitView.swift
import SwiftUI

struct UsageLimitView: View {
    @StateObject private var purchaseManager = SimplePurchaseManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var showingSubscription = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Icon and Title
                VStack(spacing: 16) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                        .padding(.top, 20)
                    
                    Text("Daily Limit Reached")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("You've used your free 3 minutes for today")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal)
                }
                
                // Usage Info
                VStack(spacing: 12) {
                    Text("Usage Today")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Text("3:00")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                        
                        Text("/ 3:00")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    
                    // Progress Bar
                    ProgressView(value: purchaseManager.usagePercentage())
                        .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                // Benefits
                VStack(alignment: .leading, spacing: 12) {
                    Text("Upgrade to Premium")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        BenefitRow(text: "Unlimited practice time")
                        BenefitRow(text: "Same access to all question sets")
                        BenefitRow(text: "Same analytics and tracking")
                        BenefitRow(text: "Same offline functionality")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        // Direct purchase - no paywall needed
                        Task {
                            await purchaseManager.purchaseProduct()
                        }
                    }) {
                        Text("Buy Now - $29.99")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .disabled(purchaseManager.isPurchasing)
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Try Again Tomorrow")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Benefit Row Component
struct BenefitRow: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.title3)
            
            Text(text)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

// MARK: - Preview
struct UsageLimitView_Previews: PreviewProvider {
    static var previews: some View {
        UsageLimitView()
    }
}
