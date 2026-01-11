// MARK: - Route A: Smile Training View
// RouteA_SmileTrainingView.swift

import SwiftUI

struct RouteA_SmileTrainingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingQuestionSets = true
    @State private var showingRouteB = false
    
    var body: some View {
        NavigationView {
            Group {
                if showingQuestionSets {
                    QuestionSetSelectionView()
                        .onAppear {
                            print("🎯 DEBUG: Route A - QuestionSetSelectionView appeared")
                        }
                } else {
                    SmileDetectionView()
                        .onAppear {
                            print("🎯 DEBUG: Route A - SmileDetectionView appeared")
                        }
                }
            }
            .navigationTitle("Smile Training")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Home") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Monitoring") {
                    showingRouteB = true
                }
            )
        }
        .onAppear {
            print("🎯 DEBUG: Route A - Smile Training started")
            
            // Listen for ReturnToWelcome notification
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name("ReturnToWelcome"),
                object: nil,
                queue: .main
            ) { _ in
                presentationMode.wrappedValue.dismiss()
            }
        }
        .onDisappear {
            // Remove notification observer
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ReturnToWelcome"), object: nil)
        }
        .fullScreenCover(isPresented: $showingRouteB) {
            RouteB_SmileMonitoringView()
        }
    }
}
