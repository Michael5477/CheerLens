import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @StateObject private var purchaseManager = SimplePurchaseManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedProductId: String?
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerView
                    
                    // Features
                    featuresView
                    
                    // Subscription Plans
                    subscriptionPlansView
                    
                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Purchase Unlimited Access")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .onAppear {
            Task {
                await purchaseManager.loadProducts()
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(purchaseManager.errorMessage ?? "An error occurred")
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 16) {
            Image(systemName: "crown.fill")
                .font(.system(size: 50))
                .foregroundColor(.yellow)
            
            Text("Unlock Unlimited Usage")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("Remove daily time limits and practice as much as you want")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
    
    // MARK: - Features View
    private var featuresView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What You Get")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                FeatureRow(
                    icon: "infinity",
                    title: "Unlimited Practice Time",
                    description: "No daily time limits - practice as much as you want"
                )
                
                FeatureRow(
                    icon: "questionmark.circle.fill",
                    title: "All Question Sets",
                    description: "Same access to all question categories as before"
                )
                
                FeatureRow(
                    icon: "chart.bar.fill",
                    title: "Performance Tracking",
                    description: "Same analytics and insights as before"
                )
                
                FeatureRow(
                    icon: "wifi.slash",
                    title: "Completely Offline",
                    description: "Same offline functionality as before"
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Subscription Plans View (Updated for one-time purchase)
    private var subscriptionPlansView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("One-Time Purchase")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                MockSubscriptionPlanCard(
                    title: "One-Time Purchase",
                    price: "$29.99",
                    period: "unlimited access",
                    description: "Unlimited access to all features forever",
                    isSelected: selectedProductId == "com.smiledetectionapp.onetime",
                    onSelect: {
                        selectedProductId = "com.smiledetectionapp.onetime"
                    },
                    onPurchase: {
                        await purchaseMockProduct("com.smiledetectionapp.onetime")
                    }
                )
            }
        }
    }
    
    // MARK: - Real StoreKit Purchase Function
    private func purchaseMockProduct(_ productId: String) async {
        // Find the actual product from available products
        guard let product = purchaseManager.availableProducts.first(where: { $0.id == productId }) else {
            print("❌ Product not found: \(productId)")
            return
        }
        
        do {
            // Use real StoreKit purchase
            try await purchaseManager.purchase(product)
            DispatchQueue.main.async {
                self.presentationMode.wrappedValue.dismiss()
            }
        } catch {
            print("❌ Purchase failed: \(error)")
            // Handle error - could show alert to user
        }
    }
}

// MARK: - Preview
struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView()
    }
}