// AboutView.swift
import SwiftUI

struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // App Header
                    VStack(spacing: 16) {
                        Image(systemName: "face.smiling.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text("Smile Detection App")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Version 1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // App Description
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About This App")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("Practice your smile confidence with AI-powered face detection. Perfect for interview preparation and general confidence building.")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Features
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Features")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            FeatureRow(icon: "questionmark.circle.fill", title: "Interview Question Practice", description: "Practice with real interview questions")
                            FeatureRow(icon: "eye.fill", title: "Live Smile Monitoring", description: "Monitor your smile in real-time")
                            FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Performance Analytics", description: "Detailed performance insights")
                            FeatureRow(icon: "brain.head.profile", title: "AI-Powered Detection", description: "Advanced ML Kit integration")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Legal Links
                    VStack(spacing: 16) {
                        Text("Legal")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 12) {
                            LinkButton(
                                title: "Privacy Policy",
                                subtitle: "How we handle your data",
                                url: "https://yourwebsite.com/privacy-policy"
                            )
                            
                            LinkButton(
                                title: "Terms of Service",
                                subtitle: "App usage terms",
                                url: "https://yourwebsite.com/terms-of-service"
                            )
                            
                            LinkButton(
                                title: "Support",
                                subtitle: "Get help and contact us",
                                url: "https://yourwebsite.com/support"
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Developer Info
                    VStack(spacing: 12) {
                        Text("Developer")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("Developed with ❤️ for interview preparation and smile confidence building.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}


// MARK: - Link Button Component
struct LinkButton: View {
    let title: String
    let subtitle: String
    let url: String
    
    var body: some View {
        Button(action: {
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "arrow.up.right.square")
                    .font(.title3)
                    .foregroundColor(.blue)
            }
            .padding(.vertical, 8)
        }
    }
}

// MARK: - Preview
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
