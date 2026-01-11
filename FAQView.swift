// FAQView.swift
import SwiftUI

struct FAQView: View {
    @Environment(\.presentationMode) var presentationMode
    
    struct FAQItem: Identifiable {
        let id = UUID()
        let question: String
        let answer: String
    }
    
    let faqItems: [FAQItem] = [
        FAQItem(
            question: "How do I use the Smile Training feature?",
            answer: "On the home screen, select \"Smile Training\", then choose a question set to start practicing. The app will use your camera to detect your smile and provide detailed performance analysis after each practice session."
        ),
        FAQItem(
            question: "How do I use the Smile Monitor feature?",
            answer: "On the home screen, select \"Smile Monitor\". The app will monitor your smile performance in real-time, and you can stop anytime to view the analysis results."
        ),
        FAQItem(
            question: "What is the Smile Detection Sensitivity feature?",
            answer: "The Sensitivity slider allows you to adjust how sensitive the app is at detecting smiles. Lower values (closer to 0.1) make detection more sensitive, meaning it will detect smiles more easily even with subtle expressions. Higher values (closer to 0.9) make detection less sensitive, requiring a more pronounced smile to be detected. Adjust the slider to find the setting that works best for your practice style and facial expressions."
        ),
        FAQItem(
            question: "Why is my smile detection inaccurate?",
            answer: "Please ensure: 1) Adequate lighting 2) Face is directly facing the camera 3) Camera lens is clean 4) Maintain appropriate distance (about 30-60 cm). If the problem persists, try adjusting the Sensitivity slider or restarting the app. Also check your device's camera permission settings."
        ),
        FAQItem(
            question: "What are the limitations of the free plan?",
            answer: "The free plan provides 3 minutes of total usage time per day (combined for both Smile Training and Smile Monitor). After exceeding 3 minutes, you'll need to wait until the next day or purchase unlimited access with a one-time payment of $29.99."
        ),
        FAQItem(
            question: "What's the difference between free plan and unlimited access?",
            answer: "The only difference is usage time. Free plan users have a 3-minute daily limit, while unlimited access removes this limit permanently. All features (question sets, analytics, offline functionality) are exactly the same for both free and paid users."
        ),
        FAQItem(
            question: "Does the app require an internet connection?",
            answer: "No! The app works completely offline and does not require an internet connection at all. All features including smile detection, question sets, and analytics work entirely on your device without any internet connectivity. This ensures your privacy and convenience - you can practice anywhere, anytime, even without Wi-Fi or cellular data."
        ),
        FAQItem(
            question: "How do I restore purchases?",
            answer: "If you've purchased unlimited access on another device or after reinstalling the app, go to \"Settings\" > \"Purchase Status\" and tap the \"Restore Purchases\" button. The system will automatically restore your purchase status from Apple's servers."
        ),
        FAQItem(
            question: "How do I view my practice history?",
            answer: "After each practice or monitoring session ends, you'll see a detailed results screen including smile ratio, duration, and performance analysis. You can take a screenshot of these results to save them for your records. The app does not store practice history automatically."
        ),
        FAQItem(
            question: "Does the app collect my personal data?",
            answer: "No! The app operates completely locally and does not upload your images or personal data to any server. All processing is done on your device, ensuring your privacy and security. Additionally, the app works completely offline, so no data is transmitted over the internet. For more details, please refer to the \"Privacy Policy\"."
        ),
        FAQItem(
            question: "How do I contact support?",
            answer: "You can contact us through \"Settings\" > \"Support\" > \"Send Feedback\". We'll respond to your questions as soon as possible. Before contacting, we recommend checking the FAQ first, as solutions to most questions are listed there."
        )
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                            .padding(.top, 20)
                        
                        Text("FAQ")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Frequently Asked Questions")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 10)
                    
                    // FAQ Items
                    VStack(spacing: 16) {
                        ForEach(faqItems) { item in
                            FAQItemView(item: item)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("FAQ")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// MARK: - FAQ Item View
struct FAQItemView: View {
    let item: FAQView.FAQItem
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(item.question)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding()
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    
                    Text(item.answer)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                .transition(.opacity)
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Preview
struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        FAQView()
    }
}

