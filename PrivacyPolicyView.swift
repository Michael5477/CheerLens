// PrivacyPolicyView.swift
import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Privacy Policy")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                        
                        Text("Last Updated: \(Date().formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Data Security Section (Highlighted)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "lock.shield.fill")
                                .foregroundColor(.green)
                                .font(.title2)
                            
                            Text("Your Data is Secure")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        
                        Text("CheerLens is designed with your privacy as our top priority. All processing happens locally on your device - we never collect, store, or transmit your personal data.")
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding(.leading, 32)
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Local Processing
                    SectionView(
                        title: "Local Processing",
                        content: "All facial detection and smile analysis is performed entirely on your device using Google ML Kit Face Detection. No video frames, images, or facial data ever leave your device. All processing happens in real-time and data is discarded immediately after analysis."
                    )
                    
                    // No Data Collection
                    SectionView(
                        title: "No Data Collection",
                        content: "We do not collect, store, or transmit any personal information, facial data, images, or video recordings. Your practice sessions remain completely private and are not tracked or monitored."
                    )
                    
                    // Camera Access
                    SectionView(
                        title: "Camera Access",
                        content: "Camera access is required solely for real-time facial expression analysis during practice sessions. The camera feed is processed locally and is never recorded or stored. You can revoke camera access at any time through your device settings."
                    )
                    
                    // Photo Library Access
                    SectionView(
                        title: "Photo Library Access",
                        content: "Photo library access is optional and only used if you choose to attach a screenshot when submitting feedback. Selected images are only used to compose your feedback email and are not stored or analyzed by the app."
                    )
                    
                    // Subscription Information
                    SectionView(
                        title: "Subscription Information",
                        content: "Subscription management is handled through Apple's App Store. We do not have access to your payment information. Subscription status is verified locally using StoreKit, and no personal subscription data is transmitted to our servers."
                    )
                    
                    // Usage Analytics
                    SectionView(
                        title: "Usage Analytics",
                        content: "We do not use any third-party analytics services. Your app usage, practice sessions, and preferences remain completely private and are not tracked or analyzed."
                    )
                    
                    // Children's Privacy
                    SectionView(
                        title: "Children's Privacy",
                        content: "CheerLens does not knowingly collect information from children under 13. Since we do not collect any personal information, this app is safe for users of all ages."
                    )
                    
                    // Changes to Privacy Policy
                    SectionView(
                        title: "Changes to This Privacy Policy",
                        content: "We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy in the app and updating the \"Last Updated\" date."
                    )
                    
                    // Contact
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Contact Us")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("If you have any questions about this Privacy Policy, please contact us through the app's Support section (Settings > Support > Send Feedback).")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 10)
                    
                    Spacer(minLength: 30)
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// MARK: - Section View Component
struct SectionView: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: - Preview
struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyView()
    }
}

