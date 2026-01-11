// MARK: - Route B: Smile Monitoring View (Simplified Independent Implementation)
// RouteB_SmileMonitoringView.swift

import SwiftUI
import Charts

struct RouteB_SmileMonitoringView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isMonitoringActive = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var finalDuration: TimeInterval = 0  // Fixed duration when monitoring stops
    @State private var showingResults = false
    @State private var timer: Timer?
    @StateObject private var purchaseManager = SimplePurchaseManager.shared
    @State private var showingUsageLimit = false
    // REMOVED: showingDailyLimitWarning - no 30-second warning needed
    
    // ML Kit smile detection data
    @State private var currentSmileProbability: Float = 0.0
    @State private var smileScores: [SmileScore] = []
    @State private var isFaceDetected = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Status display area (similar to Route A's question area)
                VStack(spacing: 12) {
                    Text("Live Smile Monitoring")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text("Monitor your smile in real-time without questions")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color(.systemBackground))
                
                // ML Kit Camera Preview (same as Route A)
                SmileDetectionView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // REMOVED: Daily limit warning banner (30-second reminder)
                // User wants uninterrupted practice until limit is reached
                
                // Timer and Control buttons (similar to Route A's bottom area)
                VStack(spacing: 8) {
                    Text(formatTime(elapsedTime))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(4)
                    
                    if !isMonitoringActive {
                        Button(action: startMonitoring) {
                            Text("Start Monitoring")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                    } else {
                        Button(action: stopMonitoring) {
                            Text("Stop & Analyze")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.7))
            }
            .navigationTitle("Smile Monitoring")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Home") {
                // Post notification to dismiss all the way back to Welcome Screen
                NotificationCenter.default.post(name: NSNotification.Name("ReturnToWelcome"), object: nil)
            })
        }
        .fullScreenCover(isPresented: $showingResults) {
            NavigationView {
                RouteB_ResultsView(
                    duration: finalDuration,  // Use fixed duration instead of elapsedTime
                    smileScores: smileScores,
                    onBack: {
                        showingResults = false
                    },
                    onStartAgain: {
                        showingResults = false
                        startMonitoring()
                    },
                    onReturnHome: {
                        showingResults = false
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .sheet(isPresented: $showingUsageLimit) {
            UsageLimitView()
        }
        .onAppear {
            // Listen for ReturnToWelcome notification
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name("ReturnToWelcome"),
                object: nil,
                queue: .main
            ) { _ in
                presentationMode.wrappedValue.dismiss()
            }
            
            // Listen for smile detection updates
            NotificationCenter.default.addObserver(
                forName: .smileProbabilityUpdated,
                object: nil,
                queue: .main
            ) { notification in
                print("🎯 DEBUG: Route B - Received smile detection notification")
                if let userInfo = notification.userInfo,
                   let probability = userInfo["probability"] as? Float,
                   let faceDetected = userInfo["faceDetected"] as? Bool {
                    
                    print("🎯 DEBUG: Route B - Probability: \(probability), Face detected: \(faceDetected), Monitoring active: \(isMonitoringActive)")
                    
                    currentSmileProbability = probability
                    isFaceDetected = faceDetected
                    
                    // Add smile score to collection if monitoring is active
                    if isMonitoringActive {
                        let smileScore = SmileScore(
                            time: elapsedTime,
                            probability: probability
                        )
                        smileScores.append(smileScore)
                        print("🎯 DEBUG: Route B - Added smile score: time=\(elapsedTime), probability=\(probability), total scores=\(smileScores.count)")
                    }
                } else {
                    print("🎯 DEBUG: Route B - Failed to parse notification userInfo: \(notification.userInfo ?? [:])")
                }
            }
        }
        .onDisappear {
            // Remove notification observers
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ReturnToWelcome"), object: nil)
            NotificationCenter.default.removeObserver(self, name: .smileProbabilityUpdated, object: nil)
        }
    }
    
    // MARK: - Simple Methods
    private func startMonitoring() {
        print("🎯 DEBUG: Route B - Starting monitoring")
        
        // CRITICAL: Check daily usage BEFORE starting (not including current session)
        // User can start practice as long as dailyUsageTime < 3 minutes
        // Once started, practice can run as long as user wants (even 30+ minutes)
        let dailyUsage = purchaseManager.dailyUsageTime
        
        if !purchaseManager.isPurchased && dailyUsage >= purchaseManager.dailyLimit {
            // Daily limit already reached - can't start new practice
            print("DEBUG: Route B - Daily limit already reached (\(dailyUsage)s >= \(purchaseManager.dailyLimit)s). Can't start new practice.")
            showingUsageLimit = true
            return
        }
        
        // User can start - daily usage is under 3 minutes
        isMonitoringActive = true
        elapsedTime = 0
        finalDuration = 0  // Reset fixed duration
        smileScores = [] // Reset smile data collection
        print("🎯 DEBUG: Route B - Reset smile scores, count: \(smileScores.count)")
        print("🎯 DEBUG: Route B - Starting practice with dailyUsage: \(dailyUsage)s (under 3min limit)")
        
        // Timer for elapsed time - NO automatic stopping, practice runs naturally
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if self.isMonitoringActive {
                self.elapsedTime += 0.1
                // Practice runs uninterrupted - user can practice as long as they want
                // No automatic stopping, no warnings, no forced result screen
            }
        }
    }
    
    private func stopMonitoring() {
        print("🎯 DEBUG: Route B - Stopping monitoring")
        print("🎯 DEBUG: Route B - Final smile scores count: \(smileScores.count)")
        print("🎯 DEBUG: Route B - Final elapsed time: \(elapsedTime)")
        
        // Save fixed duration at the moment monitoring stops
        // This ensures duration never changes, even if the view is recreated
        finalDuration = elapsedTime
        
        // Track usage time for subscription limits
        purchaseManager.trackUsage(finalDuration)
        
        isMonitoringActive = false
        timer?.invalidate()
        timer = nil
        
        // User naturally gets result screen when they manually stop
        // This is NOT forced - user clicked "Stop & Analyze" button
        showingResults = true
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Route B Results View (Full Screen)
struct RouteB_ResultsView: View {
    let duration: TimeInterval
    let smileScores: [SmileScore]
    let onBack: () -> Void
    let onStartAgain: () -> Void
    let onReturnHome: () -> Void
    
    // Calculate smile ratio (time-based calculation)
    // This calculates the percentage based on time, not data point count
    // to avoid sampling bias when sampling is uneven
    private var smileRatioPercentage: Double {
        guard !smileScores.isEmpty, duration > 0 else {
            return 0
        }
        
        // Use the actual duration parameter instead of smileScores.last?.time
        // This ensures accuracy when the last data point time doesn't match the total duration
        let totalTime = duration
        
        // Calculate smile time based on time intervals between data points
        var smileTime: TimeInterval = 0
        
        for i in 0..<smileScores.count {
            let currentScore = smileScores[i]
            
            if i == 0 {
                // First data point: calculate time from start (0) to first data point
                // If probability > 0.3, count the time from start to first point as smile time
                if currentScore.probability > 0.3 && currentScore.time > 0 {
                    smileTime += currentScore.time
                }
            } else {
                // Calculate time interval between previous and current point
                let previousScore = smileScores[i - 1]
                let timeInterval = currentScore.time - previousScore.time
                
                // If current point has probability > 0.3, the time since last point counts as smile time
                if currentScore.probability > 0.3 {
                    smileTime += timeInterval
                }
            }
        }
        
        // Handle time after last data point: if last point is > 0.3, count remaining time
        if let lastScore = smileScores.last, lastScore.probability > 0.3 {
            let timeAfterLastPoint = totalTime - lastScore.time
            if timeAfterLastPoint > 0 {
                smileTime += timeAfterLastPoint
            }
        }
        
        // Ensure percentage doesn't exceed 100%
        let percentage = (smileTime / totalTime) * 100
        return min(percentage, 100.0)
    }
    
    // Chart data for trend
    private var chartData: [ChartDataPoint] {
        return smileScores.map { score in
            ChartDataPoint(time: score.time, ratio: Double(score.probability))
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                headerView
                
                // Summary Cards
                summaryCardsView
                
                // Smile Performance Chart (if data available)
                if !smileScores.isEmpty {
                    smilePerformanceChartView
                }
                
                // Performance Analysis
                performanceAnalysisView
                
                // Action Buttons
                actionButtonsView
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Monitoring Results")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            leading: Button("Back") {
                onBack()
            }
        )
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Monitoring Complete!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Smile Monitoring Session")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Summary Cards
    private var summaryCardsView: some View {
        HStack(spacing: 16) {
            // Duration Card
            VStack(spacing: 8) {
                Image(systemName: "clock.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text(formatDuration(duration))
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Duration")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            // Smile Ratio Card
            VStack(spacing: 8) {
                Image(systemName: "face.smiling.fill")
                    .font(.title2)
                    .foregroundColor(smileRatioColor)
                
                Text("\(String(format: "%.1f", smileRatioPercentage))%")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Smile Ratio >0.3")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
    
    // MARK: - Smile Performance Chart
    private var smilePerformanceChartView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Smile Performance")
                .font(.headline)
                .fontWeight(.semibold)
            
            if #available(iOS 16.0, *) {
                Chart(chartData, id: \.time) { dataPoint in
                    LineMark(
                        x: .value("Time", dataPoint.time),
                        y: .value("Probability", dataPoint.ratio)
                    )
                    .foregroundStyle(.blue)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                    
                    // Threshold line
                    RuleMark(y: .value("Threshold", 0.3))
                        .foregroundStyle(.red)
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisValueLabel {
                            if let time = value.as(Double.self) {
                                Text(formatTimeForChart(time))
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                        }
                        AxisGridLine()
                            .foregroundStyle(Color.primary.opacity(0.3))
                    }
                }
                .chartYAxis {
                    AxisMarks(values: [0, 0.2, 0.4, 0.6, 0.8, 1.0]) { value in
                        AxisValueLabel {
                            if let ratio = value.as(Double.self) {
                                Text(String(format: "%.1f", ratio))
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                        }
                        AxisGridLine()
                            .foregroundStyle(Color.primary.opacity(0.3))
                    }
                }
                .chartBackground { chartProxy in
                    Rectangle()
                        .fill(Color(.systemBackground))
                }
            } else {
                // Fallback for iOS < 16
                Text("Chart requires iOS 16+")
                    .foregroundColor(.secondary)
                    .frame(height: 200)
            }
            
            Text(performanceLevel)
                .font(.subheadline)
                .foregroundColor(performanceColor)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Performance Analysis
    private var performanceAnalysisView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Performance Analysis")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(performanceComment)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Action Buttons
    private var actionButtonsView: some View {
        VStack(spacing: 12) {
            Button(action: onStartAgain) {
                Text("Start Monitoring Again")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            
            Button(action: onReturnHome) {
                Text("Go Back")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
            }
        }
    }
    
    // MARK: - Helper Properties
    private var smileRatioColor: Color {
        if smileRatioPercentage >= 80 {
            return .green
        } else if smileRatioPercentage >= 60 {
            return .orange
        } else {
            return .red
        }
    }
    
    private var performanceLevel: String {
        if smileRatioPercentage >= 80 {
            return "Excellent! Keep up the great work!"
        } else if smileRatioPercentage >= 60 {
            return "Good! Keep practicing to improve."
        } else if smileRatioPercentage > 0 {
            return "Keep practicing to improve your smile."
        } else {
            return "Monitoring completed successfully"
        }
    }
    
    private var performanceColor: Color {
        if smileRatioPercentage >= 80 {
            return .green
        } else if smileRatioPercentage >= 60 {
            return .orange
        } else {
            return .blue
        }
    }
    
    private var performanceComment: String {
        if smileRatioPercentage >= 80 {
            return "Outstanding performance! You maintained a natural smile for \(String(format: "%.1f", smileRatioPercentage))% of the session. Your facial expressions show great confidence and engagement. This level of consistency will make a strong positive impression in interviews."
        } else if smileRatioPercentage >= 60 {
            return "Good performance! You smiled naturally for \(String(format: "%.1f", smileRatioPercentage))% of the session. You're showing good interview presence, but there's room to improve consistency. Focus on maintaining your smile throughout longer responses."
        } else if smileRatioPercentage > 0 {
            return "Room for improvement. You smiled naturally for \(String(format: "%.1f", smileRatioPercentage))% of the session. Practice maintaining a warm, natural smile during conversations. Remember, a genuine smile helps build rapport with interviewers."
        } else {
            return "Practice completed successfully! While no smile data was detected during this session, completing the practice is a great start. Focus on maintaining natural facial expressions and eye contact during your next practice session."
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Chart Time Formatting
    private func formatTimeForChart(_ time: Double) -> String {
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        
        // For sessions less than 1 minute, show total seconds only
        if duration < 60 {
            return "\(totalSeconds)s"
        }
        // For sessions 1 minute or longer, always show minutes and seconds
        else if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        }
        // Fallback to total seconds (shouldn't happen if session >= 1 minute)
        else {
            return "\(totalSeconds)s"
        }
    }
}

// MARK: - Chart Data Structure
struct ChartDataPoint {
    let time: Double
    let ratio: Double
}

// MARK: - Preview
struct RouteB_SmileMonitoringView_Previews: PreviewProvider {
    static var previews: some View {
        RouteB_SmileMonitoringView()
    }
}