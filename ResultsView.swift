// MARK: - Results Analysis View
// ResultsView.swift

import SwiftUI
import Charts

struct ResultsView: View {
    let questionSet: QuestionSet
    let practiceSession: PracticeSession
    let smileScores: [SmileScore] // Session smile data
    @Environment(\.presentationMode) var presentationMode
    @State private var showingQAPractice = false
    @State private var showingQuestionSelection = false
    @State private var showingRouteB = false

    // Chart data structure for session data
    struct ChartDataPoint {
        let time: Double
        let ratio: Double
    }
    
    // Calculate session metrics (use fixed duration from PracticeSession)
    // This ensures duration never changes, even if the view is recreated
    private var sessionDuration: TimeInterval {
        return practiceSession.duration
    }
    
    private var sessionDurationString: String {
        let minutes = Int(sessionDuration) / 60
        let seconds = Int(sessionDuration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // Calculate smile metrics from session data
    private var averageSmilePercentage: Double {
        guard !smileScores.isEmpty else { return 0 }
        let total = smileScores.reduce(0.0) { $0 + Double($1.probability) }
        return (total / Double(smileScores.count)) * 100
    }
    
    // Smile Ratio >0.3 percentage (time-based, calculated from PracticeDataManager)
    // This uses the pre-calculated time-based percentage instead of counting data points
    // to avoid sampling bias (when sampling is uneven, count-based calculation becomes inaccurate)
    private var smileRatioPercentage: Double {
        return practiceSession.smilePercentage
    }
    
    // Session summary
    private var sessionSummary: String {
        if sessionDuration > 0 {
            return "Practice completed in \(sessionDurationString)"
        } else {
            return "Practice completed"
        }
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
                
                // Smile Performance Chart
                smilePerformanceChartView
                
                // Performance Comments
                performanceCommentsView
                
                // Tips Section
                tipsView
                
                // Action Buttons
                actionButtonsView
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            leading: Button("Home") {
                // Trigger Point 2: Complete immediate cleanup when clicking ResultsView button
                UltimateCleaner.setNavigationInProgress(true)
                UltimateCleaner.performTotalCleanup()
                
                // Brief delay to allow cleanup, then proceed regardless
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    // Dismiss multiple levels by posting a notification
                    NotificationCenter.default.post(name: NSNotification.Name("ReturnToWelcome"), object: nil)
                    UltimateCleaner.setNavigationInProgress(false)
                }
            },
            trailing: Button("Monitoring") {
                showingRouteB = true
            }
        )
        .onAppear {
            print("🔍 DEBUG: ResultsView - onAppear called")
            // Trigger Point 1: Start async cleanup when entering ResultsView (only once)
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) {
                print("🔍 DEBUG: ResultsView - About to call UltimateCleaner")
                UltimateCleaner.performTotalCleanup()
            }
        }
        .fullScreenCover(isPresented: $showingQAPractice) {
            // Practice the same questions again
            QAPracticeView(
                questionSet: questionSet,
                selectedQuestions: practiceSession.selectedQuestions
            )
        }
        .fullScreenCover(isPresented: $showingQuestionSelection) {
            // Go back to question set selection
            QuestionSetSelectionView()
        }
        .fullScreenCover(isPresented: $showingRouteB) {
            // Go to Monitoring (Smile Monitoring)
            RouteB_SmileMonitoringView()
                .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Practice Complete!")
                .font(.title)
                .fontWeight(.bold)
            
            Text(questionSet.title)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Summary Cards (Duration + Smile Ratio >0.3%)
    private var summaryCardsView: some View {
        HStack(spacing: 20) {
            SummaryCard(
                title: "Duration",
                value: sessionDurationString,
                icon: "clock.fill",
                color: .blue
            )
            
            SummaryCard(
                title: "Smile Ratio >0.3",
                value: String(format: "%.1f%%", smileRatioPercentage),
                icon: "face.smiling.fill",
                color: smileRatioColor
            )
        }
    }
    
    // MARK: - Smile Performance Chart
    private var smilePerformanceChartView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Smile Performance")
                .font(.headline)
                .fontWeight(.semibold)
            
            if #available(iOS 16.0, *) {
                if !smileScores.isEmpty {
                    // Show actual trend chart with session data
                    Chart(chartData, id: \.time) { dataPoint in
                        LineMark(
                            x: .value("Time", dataPoint.time),
                            y: .value("Smile", dataPoint.ratio)
                        )
                        .foregroundStyle(Color.blue)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                        
                        AreaMark(
                            x: .value("Time", dataPoint.time),
                            y: .value("Smile", dataPoint.ratio)
                        )
                        .foregroundStyle(Color.blue.opacity(0.1))
                        
                        // Red dashed line at 0.3 threshold
                        RuleMark(y: .value("Threshold", 0.3))
                            .foregroundStyle(Color.red)
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                    }
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
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                } else {
                    // No data available
                    VStack(spacing: 8) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.title)
                            .foregroundColor(.gray)
                        
                        Text("No Data Available")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("No smile data was collected during this session")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            } else {
                // Fallback for iOS 15 and below
                VStack(spacing: 8) {
                    Text("Smile Ratio Trend")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if !smileScores.isEmpty {
                        Text("Average: \(String(format: "%.1f%%", averageSmilePercentage))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        Text("Chart requires iOS 16+")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(height: 200)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            
            // Performance level
            Text(performanceLevel)
                .font(.caption)
                .foregroundColor(performanceColor)
                .fontWeight(.medium)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Performance Comments View
    private var performanceCommentsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Performance Analysis")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(performanceComment)
                .font(.subheadline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Tips View
    private var tipsView: some View {
        // Tips section
        VStack(alignment: .leading, spacing: 12) {
            Text("Tips for Improvement")
                .font(.headline)
                .fontWeight(.semibold)
            
            ForEach(performanceTips, id: \.self) { tip in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    
                    Text(tip)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Action Buttons
    private var actionButtonsView: some View {
        VStack(spacing: 12) {
            Button(action: {
                // Set navigation state and complete cleanup before starting new practice
                UltimateCleaner.setNavigationInProgress(true)
                UltimateCleaner.performTotalCleanup()
                
                // Brief delay to allow cleanup, then proceed regardless
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    showingQAPractice = true
                    UltimateCleaner.setNavigationInProgress(false)
                }
            }) {
                Text("Practice the same Question Again")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            
            Button(action: {
                // Set navigation state and complete cleanup before going to question selection
                UltimateCleaner.setNavigationInProgress(true)
                UltimateCleaner.performTotalCleanup()
                
                // Brief delay to allow cleanup, then proceed regardless
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    showingQuestionSelection = true
                    UltimateCleaner.setNavigationInProgress(false)
                }
            }) {
                Text("Choose Different Questions")
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
            return "Practice completed successfully"
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
    
    private var performanceTips: [String] {
        var tips: [String] = []
        
        if smileRatioPercentage >= 80 {
            tips.append("Excellent smile performance! You're ready for interviews.")
            tips.append("Maintain this level of confidence and positivity.")
            tips.append("Your natural smile is your best asset.")
        } else if smileRatioPercentage >= 60 {
            tips.append("Good progress! Practice smiling more naturally.")
            tips.append("Try to relax your facial muscles before practicing.")
            tips.append("Remember to smile with your eyes, not just your mouth.")
        } else if smileRatioPercentage > 0 {
            tips.append("Keep practicing to improve your smile confidence.")
            tips.append("Try practicing in front of a mirror to see your smile.")
            tips.append("Focus on positive thoughts while practicing.")
        } else {
            tips.append("Great job completing your practice session!")
            tips.append("Keep practicing to improve your interview skills.")
            tips.append("Remember to smile naturally during interviews.")
        }
        
        return tips
    }
    
    // MARK: - Chart Time Formatting
    private func formatTimeForChart(_ time: Double) -> String {
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        
        // For sessions less than 1 minute, show total seconds only
        if sessionDuration < 60 {
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