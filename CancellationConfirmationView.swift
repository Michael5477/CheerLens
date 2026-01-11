import SwiftUI
import StoreKit

struct CancellationConfirmationView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var purchaseManager = SimplePurchaseManager.shared
    @State private var showingAcknowledgment = false
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("One-Time Purchase")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("One-time purchases cannot be cancelled through the app. If you need assistance with your purchase, please contact support.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(spacing: 12) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Contact Support")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.blue)
                        .cornerRadius(15)
                }
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(15)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 40)
        .background(Color(.systemBackground))
        .cornerRadius(25)
        .shadow(radius: 20)
        .padding(.horizontal, 20)
        .fullScreenCover(isPresented: $showingAcknowledgment) {
            CancellationAcknowledgmentView()
        }
    }
}

struct CancellationConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        CancellationConfirmationView()
    }
}
