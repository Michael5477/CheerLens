// TermsOfServiceView.swift
import SwiftUI

struct TermsOfServiceView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Terms of Service")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                        
                        Text("Last Updated: \(Date().formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Introduction
                    SectionView(
                        title: "Agreement to Terms",
                        content: "By downloading, installing, or using CheerLens, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the app."
                    )
                    
                    // Use of the App
                    SectionView(
                        title: "Use of the App",
                        content: "CheerLens is designed for interview practice and smile confidence training. You may use the app for personal, non-commercial purposes. You agree not to use the app for any illegal or unauthorized purpose."
                    )
                    
                    // Purchase Terms
                    SectionView(
                        title: "Purchase Terms",
                        content: "CheerLens offers a free plan with limited daily usage (3 minutes per day) and an optional one-time purchase for unlimited access. The free plan provides access to all features with a daily time limit. The one-time purchase removes this daily limit permanently, providing unlimited usage of all features. All purchases are processed through Apple's App Store and are subject to Apple's terms and conditions."
                    )
                    
                    // Free Plan
                    SectionView(
                        title: "Free Plan",
                        content: "The free plan provides 3 minutes of total usage time per day (combined for both Smile Training and Smile Monitor features). All features are available in the free plan, with only the daily time limit restriction. The daily usage limit resets every 24 hours. You can upgrade to unlimited access at any time through a one-time purchase."
                    )
                    
                    // One-Time Purchase
                    SectionView(
                        title: "One-Time Purchase",
                        content: "The one-time purchase provides unlimited access to all features without any daily time limits. This purchase is permanent and does not require renewal. Once purchased, you will have unlimited access to all features for as long as you use the app. The purchase is tied to your Apple ID and can be restored on other devices using the same Apple ID through the 'Restore Purchases' feature."
                    )
                    
                    // Refunds
                    SectionView(
                        title: "Refunds",
                        content: "All purchases are processed through Apple's App Store and are subject to Apple's refund policies. Refund requests for one-time purchases must be submitted through Apple's refund process within 90 days of purchase. We do not process refunds directly. Please contact Apple Support for refund requests."
                    )
                    
                    // Intellectual Property
                    SectionView(
                        title: "Intellectual Property",
                        content: "All content, features, and functionality of CheerLens, including but not limited to text, graphics, logos, and software, are the property of CheerLens and are protected by copyright and other intellectual property laws."
                    )
                    
                    // User Content
                    SectionView(
                        title: "User Content",
                        content: "CheerLens processes your facial expressions locally on your device for real-time analysis. We do not store, collect, or transmit any user content. All processing happens in real-time and data is discarded immediately after analysis."
                    )
                    
                    // Prohibited Uses
                    SectionView(
                        title: "Prohibited Uses",
                        content: "You agree not to: (1) use the app in any way that violates applicable laws or regulations, (2) attempt to reverse engineer, decompile, or disassemble the app, (3) use the app to transmit any harmful or malicious code, (4) interfere with or disrupt the app's functionality."
                    )
                    
                    // Disclaimer
                    SectionView(
                        title: "Disclaimer",
                        content: "CheerLens is provided \"as is\" without warranties of any kind. We do not guarantee that the app will be error-free or uninterrupted. The facial detection and analysis features are provided for practice purposes and should not be considered as professional advice."
                    )
                    
                    // Limitation of Liability
                    SectionView(
                        title: "Limitation of Liability",
                        content: "To the maximum extent permitted by law, CheerLens shall not be liable for any indirect, incidental, special, or consequential damages arising from your use of the app."
                    )
                    
                    // Changes to Terms
                    SectionView(
                        title: "Changes to Terms",
                        content: "We reserve the right to modify these Terms of Service at any time. We will notify you of any changes by posting the new Terms of Service in the app and updating the \"Last Updated\" date. Your continued use of the app after such changes constitutes acceptance of the new terms."
                    )
                    
                    // Termination
                    SectionView(
                        title: "Termination",
                        content: "We reserve the right to terminate or suspend your access to the app at any time, without prior notice, for any reason, including if you breach these Terms of Service."
                    )
                    
                    // Governing Law
                    SectionView(
                        title: "Governing Law",
                        content: "These Terms of Service shall be governed by and construed in accordance with the laws of the jurisdiction in which the app is operated, without regard to its conflict of law provisions."
                    )
                    
                    // Contact
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Contact Us")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("If you have any questions about these Terms of Service, please contact us through the app's Support section (Settings > Support > Send Feedback).")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 10)
                    
                    Spacer(minLength: 30)
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Terms of Service")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// MARK: - Preview
struct TermsOfServiceView_Previews: PreviewProvider {
    static var previews: some View {
        TermsOfServiceView()
    }
}

