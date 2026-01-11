// FeedbackView.swift
import SwiftUI
import MessageUI
import PhotosUI

struct FeedbackView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var feedbackText: String = ""
    @State private var emailText: String = ""
    @State private var showingMailComposer = false
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    // Support email address
    private let supportEmail = "michaellin5477@gmail.com"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // FAQ Banner
                    HStack(spacing: 12) {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.pink)
                            .font(.title3)
                        
                        Text("Before contacting support, please check our FAQ. Solutions to most questions are listed there.")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Button(action: {
                            // Dismiss feedback and show FAQ
                            presentationMode.wrappedValue.dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                NotificationCenter.default.post(name: NSNotification.Name("ShowFAQ"), object: nil)
                            }
                        }) {
                            Text("FAQ")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.pink)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color.pink.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Feedback Input Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Send Feedback")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        ZStack(alignment: .topLeading) {
                            if feedbackText.isEmpty {
                                Text("Please help us improve this app. Whether it's new ideas or reporting issues, your feedback helps make this app better.")
                                    .foregroundColor(.secondary)
                                    .font(.body)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 16)
                            }
                            TextEditor(text: $feedbackText)
                                .frame(minHeight: 150)
                                .padding(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.pink.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Email Input Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Email")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        TextField("Email address", text: $emailText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    .padding(.horizontal)
                    
                    // Screenshot Upload Section
                    VStack(alignment: .leading, spacing: 12) {
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            HStack {
                                Image(systemName: "photo.badge.arrow.up")
                                    .foregroundColor(.blue)
                                    .font(.title3)
                                
                                Text("Upload Screenshot")
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if selectedImage != nil {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 200)
                                .cornerRadius(8)
                                .padding(.top, 8)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Send Feedback")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                },
                trailing: Button(action: {
                    submitFeedback()
                }) {
                    Text("Submit")
                        .fontWeight(.semibold)
                        .foregroundColor(.pink)
                }
            )
            .sheet(isPresented: $showingImagePicker) {
                if #available(iOS 14.0, *) {
                    PHPickerView(image: $selectedImage)
                } else {
                    ImagePicker(image: $selectedImage)
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Notice"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func submitFeedback() {
        guard !feedbackText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Please enter your feedback"
            showingAlert = true
            return
        }
        
        // Create mailto URL with feedback
        var mailtoComponents = URLComponents()
        mailtoComponents.scheme = "mailto"
        mailtoComponents.path = supportEmail
        mailtoComponents.queryItems = [
            URLQueryItem(name: "subject", value: "App Feedback - Smile Detection App"),
            URLQueryItem(name: "body", value: "Feedback:\n\(feedbackText)\n\nEmail: \(emailText.isEmpty ? "Not provided" : emailText)")
        ]
        
        if let mailtoURL = mailtoComponents.url {
            if UIApplication.shared.canOpenURL(mailtoURL) {
                UIApplication.shared.open(mailtoURL)
                alertMessage = "Mail app opened. Please send your feedback."
                showingAlert = true
                
                // Clear form after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    feedbackText = ""
                    emailText = ""
                    selectedImage = nil
                }
            } else {
                // Fallback: Copy to clipboard
                let feedbackContent = """
                Feedback: \(feedbackText)
                Email: \(emailText.isEmpty ? "Not provided" : emailText)
                
                Please send this to: \(supportEmail)
                """
                
                UIPasteboard.general.string = feedbackContent
                alertMessage = "Feedback copied to clipboard. Please send email to \(supportEmail)"
                showingAlert = true
            }
        }
    }
}

// MARK: - PHPicker View (iOS 14+)
// Uses PHPickerViewController which doesn't require photo library permission
// User selects specific photos without granting full library access
@available(iOS 14.0, *)
struct PHPickerView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        configuration.preferredAssetRepresentationMode = .current
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PHPickerView
        
        init(_ parent: PHPickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else {
                return
            }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            self?.parent.image = image
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Fallback Image Picker (for iOS < 14)
// This version requires NSPhotoLibraryUsageDescription in Info.plist
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.image = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.image = originalImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - Preview
struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
    }
}

