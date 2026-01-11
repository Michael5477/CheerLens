// PaywallView.swift
import SwiftUI

struct PaywallView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var purchaseManager = SimplePurchaseManager.shared
    @State private var isLoading = false
    @State private var selectedProductId = "com.smiledetectionapp.onetime"
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Header with Close Button
                    headerView
                    
                    // Hero Section
                    heroSection
                    
                    // Features Section
                    featuresSection
                    
                    // Pricing Section
                    pricingSection
                    
                    // Call to Action
                    callToActionSection
                    
                    // Footer
                    footerSection
                }
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.1),
                    Color.purple.opacity(0.1),
                    Color(.systemBackground)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .onAppear {
            // Load products when view appears
            Task {
                await purchaseManager.loadProducts()
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            Spacer()
            Button(action: {
                // Check if this is first time seeing paywall (testing fresh install)
                let hasSeenPaywall = UserDefaults.standard.bool(forKey: "hasSeenPaywall")
                
                if !hasSeenPaywall {
                    // First time dismissing paywall - finish any StoreKit transactions from previous tests
                    // This simulates a fresh install where user dismisses paywall without purchasing
                    print("🔍 DEBUG: First time dismissing paywall - finishing StoreKit transactions")
                    Task {
                        await purchaseManager.finishAllStoreKitTransactions()
                    }
                }
                
                // Mark that user has seen the paywall
                UserDefaults.standard.set(true, forKey: "hasSeenPaywall")
                
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    // MARK: - Hero Section
    private var heroSection: some View {
        VStack(spacing: 20) {
            // App Icon
            Image(systemName: "face.smiling.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            VStack(spacing: 12) {
                Text("Master Your Interview Smile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text("Transform your confidence with AI-powered smile training")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // One-time Purchase Badge
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                    Text("ONE-TIME PURCHASE")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
                
                Text("$29.99 • Unlimited access forever")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
    }
    
    // MARK: - Features Section
    private var featuresSection: some View {
        VStack(spacing: 20) {
            Text("Unlock Unlimited Practice Time")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text("Everything stays the same, just remove the daily time limit")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(spacing: 16) {
                FeatureRow(
                    icon: "infinity",
                    title: "Unlimited Practice Time",
                    description: "No daily time limits - practice as much as you want"
                )
                
                FeatureRow(
                    icon: "questionmark.circle.fill",
                    title: "All Question Sets",
                    description: "Same access to all question categories you already have"
                )
                
                FeatureRow(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Performance Tracking",
                    description: "Same analytics and insights you already have"
                )
                
                FeatureRow(
                    icon: "wifi.slash",
                    title: "Completely Offline",
                    description: "Same offline functionality you already have"
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
    
    // MARK: - Pricing Section
    private var pricingSection: some View {
        VStack(spacing: 16) {
            Text("Choose Your Plan")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                // One-time Purchase Plan
                Button(action: {
                    selectedProductId = "com.smiledetectionapp.onetime"
                    Task {
                        await purchaseProduct("com.smiledetectionapp.onetime")
                    }
                }) {
                    PricingCard(
                        title: "One-Time Purchase",
                        price: "$29.99",
                        period: "unlimited access",
                        isPopular: true,
                        savings: nil
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(isLoading)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
    
    // MARK: - Call to Action Section
    private var callToActionSection: some View {
        VStack(spacing: 16) {
                        Button(action: {
                            // Mark that user has seen the paywall
                            UserDefaults.standard.set(true, forKey: "hasSeenPaywall")
                            // Purchase the one-time product
                            Task {
                                await purchaseProduct("com.smiledetectionapp.onetime")
                            }
                        }) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Buy Now - $29.99")
                }
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }
            .disabled(isLoading)
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
            
            Text("One-time payment • Unlimited access • Secure payment")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Skip for now") {
                // Check if this is first time seeing paywall (testing fresh install)
                let hasSeenPaywall = UserDefaults.standard.bool(forKey: "hasSeenPaywall")
                
                if !hasSeenPaywall {
                    // First time dismissing paywall - finish any StoreKit transactions from previous tests
                    // This simulates a fresh install where user dismisses paywall without purchasing
                    print("🔍 DEBUG: First time dismissing paywall - finishing StoreKit transactions")
                    Task {
                        await purchaseManager.finishAllStoreKitTransactions()
                    }
                }
                
                // Mark that user has seen the paywall
                UserDefaults.standard.set(true, forKey: "hasSeenPaywall")
                presentationMode.wrappedValue.dismiss()
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
    
    // MARK: - Purchase Function
    private func purchaseProduct(_ productId: String) async {
        print("🛒 DEBUG: Purchase button tapped for product: \(productId)")
        isLoading = true
        
        // Temporarily disable debug time for StoreKit transaction
        let debugManager = DebugTimeManager.shared
        let wasDebugEnabled = debugManager.isTimeAccelerationEnabled
        debugManager.temporarilyDisableForPurchase()
        
        // Ensure products are loaded
        if purchaseManager.availableProducts.isEmpty {
            print("⏳ Products not loaded yet, loading now...")
            await purchaseManager.loadProducts()
        }
        
        // Find the actual product from available products
        guard let product = purchaseManager.availableProducts.first(where: { $0.id == productId }) else {
            print("❌ Product not found: \(productId)")
            print("❌ Available products: \(purchaseManager.availableProducts.map { $0.id })")
            print("❌ Product count: \(purchaseManager.availableProducts.count)")
            purchaseManager.errorMessage = "Product not available. Please check your internet connection and try again."
            isLoading = false
            if wasDebugEnabled {
                debugManager.reEnableAfterPurchase()
            }
            return
        }
        
        print("🛒 DEBUG: Found product: \(product.displayName)")
        
        do {
            // Use real StoreKit purchase
            print("🛒 DEBUG: Starting StoreKit purchase...")
            try await purchaseManager.purchase(product)
            print("✅ DEBUG: Purchase successful!")
            DispatchQueue.main.async {
                self.presentationMode.wrappedValue.dismiss()
            }
        } catch {
            print("❌ Purchase failed: \(error)")
            // Handle error - could show alert to user
        }
        
        // Re-enable debug time after purchase
        if wasDebugEnabled {
            debugManager.reEnableAfterPurchase()
        }
        isLoading = false
    }
    
    // MARK: - Footer Section
    private var footerSection: some View {
        VStack(spacing: 12) {
            // Empty footer - clean and minimal
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
}


// MARK: - Preview
struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView()
    }
}
