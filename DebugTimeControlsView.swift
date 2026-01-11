import SwiftUI

struct DebugTimeControlsView: View {
    @StateObject private var debugManager = DebugTimeManager.shared
    @StateObject private var purchaseManager = SimplePurchaseManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Current Time Display
                    VStack(spacing: 12) {
                        Text("Current Debug Time")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(formatTime(debugManager.currentVirtualTime))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                        
                        if debugManager.isTimeAccelerationEnabled {
                            Text("Time Acceleration: \(String(format: "%.1fx", debugManager.timeAccelerationMultiplier))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Divider()
                    
                    // Time Controls
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Time Controls")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        VStack(spacing: 12) {
                            // Quick time advancement buttons
                            HStack(spacing: 12) {
                                Button("+1 Hour") {
                                    debugManager.advanceTime(by: 1 * 3600)
                                }
                                .buttonStyle(TimeControlButtonStyle())
                                
                                Button("+6 Hours") {
                                    debugManager.advanceTime(by: 6 * 3600)
                                }
                                .buttonStyle(TimeControlButtonStyle())
                                
                                Button("+1 Day") {
                                    debugManager.advanceTime(by: 24 * 3600)
                                }
                                .buttonStyle(TimeControlButtonStyle())
                            }
                            
                            // Fine-grained controls
                            HStack(spacing: 12) {
                                Button("+15 Min") {
                                    debugManager.advanceTime(by: 15 * 60)
                                }
                                .buttonStyle(TimeControlButtonStyle())
                                
                                Button("+30 Min") {
                                    debugManager.advanceTime(by: 30 * 60)
                                }
                                .buttonStyle(TimeControlButtonStyle())
                                
                                Button("+2 Hours") {
                                    debugManager.advanceTime(by: 2 * 3600)
                                }
                                .buttonStyle(TimeControlButtonStyle())
                            }
                            
                            // Acceleration controls
                            VStack(spacing: 8) {
                                HStack {
                                    Text("Time Acceleration")
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text("\(String(format: "%.1fx", debugManager.timeAccelerationMultiplier))")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.blue)
                                }
                                
                                HStack(spacing: 12) {
                                    Button("1x") {
                                        debugManager.setTimeAcceleration(1.0)
                                    }
                                    .buttonStyle(TimeControlButtonStyle())
                                    
                                    Button("2x") {
                                        debugManager.setTimeAcceleration(2.0)
                                    }
                                    .buttonStyle(TimeControlButtonStyle())
                                    
                                    Button("5x") {
                                        debugManager.setTimeAcceleration(5.0)
                                    }
                                    .buttonStyle(TimeControlButtonStyle())
                                    
                                    Button("10x") {
                                        debugManager.setTimeAcceleration(10.0)
                                    }
                                    .buttonStyle(TimeControlButtonStyle())
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Test Scenarios
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Test Scenarios")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        VStack(spacing: 12) {
                            TestScenarioButton(
                                title: "Trial Start (0 hours)",
                                subtitle: "Free Trial Active",
                                color: .blue,
                                icon: "gift.fill"
                            ) {
                                debugManager.setTestScenario(.trialStart)
                            }
                            
                            TestScenarioButton(
                                title: "Trial Mid (1.5 days)",
                                subtitle: "Free Trial Active",
                                color: .blue,
                                icon: "clock.fill"
                            ) {
                                debugManager.setTestScenario(.trialMid)
                            }
                            
                            TestScenarioButton(
                                title: "Trial Ending Soon (2 days 23h)",
                                subtitle: "Trial Ends then switch to Free Plan",
                                color: .orange,
                                icon: "clock.badge.exclamationmark"
                            ) {
                                debugManager.setTestScenario(.trialEndingSoon)
                            }
                            
                            TestScenarioButton(
                                title: "Trial Ended (3 days)",
                                subtitle: "Free Plan Member",
                                color: .red,
                                icon: "clock.badge.xmark"
                            ) {
                                debugManager.setTestScenario(.trialEnded)
                            }
                            
                            TestScenarioButton(
                                title: "Premium Active",
                                subtitle: "Premium Active",
                                color: .green,
                                icon: "checkmark.circle.fill"
                            ) {
                                debugManager.setTestScenario(.premiumActive)
                            }
                            
                            TestScenarioButton(
                                title: "Premium Cancelled",
                                subtitle: "Premium Active (Cancelled)",
                                color: .green,
                                icon: "checkmark.circle.fill"
                            ) {
                                debugManager.setTestScenario(.premiumCancelled)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Current Status
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Current Status")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            StatusRow(title: "Purchase Status", value: purchaseManager.getStatusMessage())
                            StatusRow(title: "Daily Usage", value: purchaseManager.getTrialProgress())
                            StatusRow(title: "Debug Mode", value: debugManager.isTimeAccelerationEnabled ? "Enabled" : "Disabled")
                            StatusRow(title: "Virtual Time", value: formatTime(debugManager.currentVirtualTime))
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Debug Time Controls")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        return formatter.string(from: date)
    }
}

struct TimeControlButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.blue)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct TestScenarioButton: View {
    let title: String
    let subtitle: String
    let color: Color
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .background(color.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatusRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
        }
    }
}

#Preview {
    DebugTimeControlsView()
}