// DailyLimitReachedView.swift
// Simple purchase window shown when daily 3-min limit is reached
import SwiftUI

struct DailyLimitReachedView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var purchaseManager = SimplePurchaseManager.shared
    @State private var isPurchasing = false
    
    var body: some View {
        ZStack {
            // Background blur
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            // Content
            VStack(spacing: 24) {
                // Icon
                Image(systemName: "clock.badge.exclamationmark.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                
                // Title
                Text("Daily Limit Reached")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                // Message
                Text("You've used your daily 3-minute limit. Unlock unlimited access with a one-time purchase.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Price
                Text("$29.99")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.primary)
                Text("One-time purchase")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Buttons
                VStack(spacing: 12) {
                    // Buy Now Button
                    Button(action: {
                        Task {
                            await purchasePremium()
                        }
                    }) {
                        HStack {
                            if isPurchasing {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Buy Now - $29.99")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(isPurchasing)
                    
                    // Try Again Tomorrow Button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Try Again Tomorrow")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.primary)
                            .cornerRadius(12)
                    }
                    .disabled(isPurchasing)
                }
                .padding(.horizontal, 24)
            }
            .padding(32)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 20)
            .padding(.horizontal, 40)
        }
    }
    
    private func purchasePremium() async {
        guard !isPurchasing else { return }
        guard !purchaseManager.isPurchasing else { return }
        
        isPurchasing = true
        
        // Use SimplePurchaseManager's purchase method
        await purchaseManager.purchaseProduct()
        
        // Wait a moment for state to update
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Close the view if purchase was successful
        if purchaseManager.isPurchased {
            DispatchQueue.main.async {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        
        isPurchasing = false
    }
}

#Preview {
    DailyLimitReachedView()
}

