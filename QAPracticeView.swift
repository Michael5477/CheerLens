// MARK: - Q&A Practice View
// QAPracticeView.swift
import SwiftUI
import UIKit
import AVFoundation
import Combine

struct QAPracticeView: View {
    let questionSet: QuestionSet
    let selectedQuestions: [Question]?
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var purchaseManager = SimplePurchaseManager.shared
    @State private var showingUsageLimit = false
    
    // MARK: - State Management
    @State private var isPracticeActive = false
    @State private var practiceStartTime: Date?
    @State private var elapsedTime: TimeInterval = 0
    @State private var currentQuestion: Question?
    @State private var displayedQuestionText = ""
    @State private var fullQuestionText = ""
    @State private var currentIndex = 0
    @State private var isTyping = false
    @State private var showingResults = false
    @State private var completedSession: PracticeSession?  // Fixed session created when practice stops
    
    // Use Combine to manage timers
    @State private var timerCancellable: AnyCancellable?
    @State private var typewriterCancellable: AnyCancellable?
    
    // Optimize data management
    @State private var dataManager = PracticeDataManager()
    @State private var audioManager = AudioResourceManager()
    
    // Performance monitoring
    @State private var performanceMonitor = PerformanceMonitor()
    @State private var memoryWarningCount = 0
    
    // Typewriter effect data
    @State private var precomputedStrings: [String] = []
    
    init(questionSet: QuestionSet, selectedQuestions: [Question]? = nil) {
        self.questionSet = questionSet
        self.selectedQuestions = selectedQuestions
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            if !isPracticeActive {
                prePracticeView
            } else {
                activePracticeView
            }
            
            Spacer()
        }
        .background(Color(.systemBackground))
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingResults) {
            if let session = completedSession {
                NavigationView {
                    ResultsView(
                        questionSet: questionSet,
                        practiceSession: session,
                        smileScores: session.smileScores  // Use saved smileScores from session
                    )
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
        .sheet(isPresented: $showingUsageLimit) {
            UsageLimitView()
        }
        .onAppear {
            print("DEBUG: QAPracticeView - onAppear called")
            performanceMonitor.startMonitoring()
            setupSmileDetectionCallback()
            print("DEBUG: QAPracticeView - About to preload audio resources")
            audioManager.preloadResources()
            print("DEBUG: QAPracticeView - Audio resources preloaded")
            
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
            print("🔍 DEBUG: QAPracticeView - onDisappear called")
            performanceMonitor.stopMonitoring()
            if !showingResults {
                cleanupAllResources()
            }
            
            // Remove notification observer
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ReturnToWelcome"), object: nil)
            
            // Trigger Point 3: Finalize cleanup when QAPracticeView disappears
            print("🔍 DEBUG: QAPracticeView - About to call UltimateCleaner")
            UltimateCleaner.performTotalCleanup()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)) { _ in
            handleMemoryWarning()
        }
    }
}

// MARK: - Subviews
extension QAPracticeView {
    private var headerView: some View {
        HStack {
            Button(action: {
                cleanupAllResources()
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.blue)
                .font(.headline)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var prePracticeView: some View {
        VStack(spacing: 30) {
            // Instructions
            VStack(spacing: 16) {
                Text("Practice Instructions")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("• Look at the camera and maintain eye contact")
                    Text("• Answer the question naturally while smiling")
                    Text("• The app will track your smile throughout")
                    Text("• Practice for at least 30 seconds")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            
            // Question count
            VStack(spacing: 8) {
                Text("Questions Available")
                    .font(.headline)
                Text("\(getQuestionCount())")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            
            // Start button
            Button(action: startPractice) {
                Text("Start Practice")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var activePracticeView: some View {
        VStack(spacing: 0) {
            // Question display
            if let _ = currentQuestion {
                VStack(spacing: 12) {
                    if !displayedQuestionText.isEmpty {
                        Text(displayedQuestionText)
                            .font(.footnote)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    if isTyping {
                        typingIndicator
                    }
                }
                .padding()
                .background(Color(.systemBackground))
            }
            
            // Smile detection
            SmileDetectionView()
            
            // Timer and Stop button
            VStack(spacing: 8) {
                Text(formatTime(elapsedTime))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(4)
                
            Button(action: stopAndAnalyze) {
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
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.7))
        }
    }
    
    private var typingIndicator: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.blue)
                    .frame(width: 6, height: 6)
                    .scaleEffect(1.0)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: isTyping
                    )
            }
        }
        .padding(.top, 8)
    }
}

// MARK: - Core Functions
extension QAPracticeView {
    private func startPractice() {
        print("DEBUG: QAPracticeView - startPractice called")
        performanceMonitor.logEvent("Practice started")
        
        // Check subscription and usage limits
        if !purchaseManager.canUseApp() {
            showingUsageLimit = true
            return
        }
        
        // Track usage time at the start of practice
        practiceStartTime = Date()
        
        // Thoroughly clean up resources
        cleanupAllResources()
        
        // Select question
        if let selectedQuestions = selectedQuestions, !selectedQuestions.isEmpty {
            currentQuestion = selectedQuestions.randomElement()
        } else {
            currentQuestion = questionSet.questions.randomElement()
        }
        
        guard currentQuestion != nil else {
            print("DEBUG: QAPracticeView - No question selected, returning")
            return
        }
        
        print("DEBUG: QAPracticeView - Question selected: \(currentQuestion!.text.prefix(50))...")
        
        // Start the session
        isPracticeActive = true
        practiceStartTime = Date()
        elapsedTime = 0
        completedSession = nil  // Clear any previous session
        
        // Start the timer
        startElapsedTimeTimer()
        
        // Ensure audio is preloaded before starting typewriter
        print("DEBUG: QAPracticeView - Ensuring audio is preloaded")
        audioManager.preloadResources()
        
        // Start the typewriter effect
        print("DEBUG: QAPracticeView - Scheduling typewriter effect in 0.3 seconds")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            print("DEBUG: QAPracticeView - About to call startTypewriterEffect")
            self.startTypewriterEffect()
        }
    }
    
    private func stopAndAnalyze() {
        performanceMonitor.logEvent("Practice stopped")
        
        // Track usage time for subscription limits
        if let startTime = practiceStartTime {
            let sessionDuration = Date().timeIntervalSince(startTime)
            purchaseManager.trackUsage(sessionDuration)
        }
        
        // Create and save the session IMMEDIATELY when practice stops
        // This ensures duration is fixed and won't change when view is recreated
        completedSession = createPracticeSession()
        
        isPracticeActive = false
        stopAllTimers()
        showingResults = true
    }
    
    private func startElapsedTimeTimer() {
        timerCancellable = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                guard let startTime = practiceStartTime else { return }
                elapsedTime = Date().timeIntervalSince(startTime)
            }
    }
    
    private func startTypewriterEffect() {
        guard let question = currentQuestion else { 
            print("DEBUG: startTypewriterEffect - No current question")
            return 
        }
        
        print("DEBUG: startTypewriterEffect - Starting for question: \(question.text.prefix(50))...")
        
        let questionText = question.text
        fullQuestionText = questionText
        displayedQuestionText = ""
        currentIndex = 0
        isTyping = true
        
        // Precompute all substrings
        precomputedStrings = (1...questionText.count).map { count in
            String(questionText.prefix(count))
        }
        
        print("DEBUG: startTypewriterEffect - Precomputed \(precomputedStrings.count) strings")
        
        // Play audio
        audioManager.playTypingSound()
        print("DEBUG: startTypewriterEffect - Audio call completed")
        
        typewriterCancellable = Timer.publish(every: 0.06, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                guard isTyping else { return }
                
                if currentIndex < precomputedStrings.count {
                    displayedQuestionText = precomputedStrings[currentIndex]
                    currentIndex += 1
                    
                    // Play a sound every 3 characters
                    if currentIndex % 3 == 0 {
                        audioManager.playTypingSound()
                    }
                } else {
                    stopTypewriterEffect()
                }
            }
    }
    
    private func stopTypewriterEffect() {
        typewriterCancellable?.cancel()
        typewriterCancellable = nil
        isTyping = false
        displayedQuestionText = fullQuestionText
    }
    
    private func stopAllTimers() {
        timerCancellable?.cancel()
        typewriterCancellable?.cancel()
        timerCancellable = nil
        typewriterCancellable = nil
    }
}

// MARK: - Data Management
extension QAPracticeView {
    private func recordSmileScore(_ probability: Float) {
        let smileScore = SmileScore(time: elapsedTime, probability: probability)
        dataManager.addScore(smileScore)
    }
    
    private func createPracticeSession() -> PracticeSession? {
        let trendData = dataManager.getTrendData()
        let smilePercentage = dataManager.getSmilePercentage()  // Time-based calculation
        
        // Calculate fixed duration at the moment of session creation
        let endTime = Date()
        let startTime = practiceStartTime ?? endTime
        let fixedDuration = endTime.timeIntervalSince(startTime)
        
        performanceMonitor.logEvent("Session created: \(trendData.count) points, \(String(format: "%.1f", smilePercentage))% (time-based), duration: \(String(format: "%.1f", fixedDuration))s")
        
        return PracticeSession(
            id: UUID(),
            questionSetId: questionSet.id,
            startTime: startTime,
            endTime: endTime,
            duration: fixedDuration,  // Fixed duration calculated when session is created
            selectedQuestions: currentQuestion != nil ? [currentQuestion!] : [],
            smileScores: trendData,  // Sampled data for chart display
            smilePercentage: smilePercentage  // Time-based percentage from PracticeDataManager
        )
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func getQuestionCount() -> Int {
        selectedQuestions?.count ?? questionSet.questions.count
    }
}

// MARK: - Resource Management
extension QAPracticeView {
    private func cleanupAllResources() {
        performanceMonitor.logEvent("Full cleanup initiated")
        
        // Stop all timers
        stopAllTimers()
        
        // Clean up audio resources
        audioManager.cleanup()
        
        // Clean up the data
        dataManager.clear()
        
        // Reset all states
        resetAllStates()
        
        // Force memory cleanup
        forceMemoryCleanup()
        
        performanceMonitor.logEvent("Full cleanup completed")
    }
    
    private func cleanupResourcesExceptSmileData() {
        performanceMonitor.logEvent("Partial cleanup initiated")
        
        stopAllTimers()
        audioManager.cleanup()
        
        // Only clean up non-data states
        isTyping = false
        displayedQuestionText = ""
        fullQuestionText = ""
        currentIndex = 0
        isPracticeActive = false
    }
    
    private func resetAllStates() {
        isTyping = false
        displayedQuestionText = ""
        fullQuestionText = ""
        currentIndex = 0
        isPracticeActive = false
        practiceStartTime = nil
        elapsedTime = 0
        showingResults = false
        completedSession = nil  // Clear completed session
        currentQuestion = nil
    }
    
    private func forceMemoryCleanup() {
        // Clear various caches
        URLCache.shared.removeAllCachedResponses()
        
        // Create an autorelease pool to force cleanup
        autoreleasepool {
            // Force release of memory
            let _ = [Int](repeating: 0, count: 1)
        }
    }
    
    private func handleMemoryWarning() {
        memoryWarningCount += 1
        performanceMonitor.logEvent("Memory warning #\(memoryWarningCount)")
        
        // Take different actions based on the number of warnings
        switch memoryWarningCount {
        case 1:
            // First warning: light cleanup
            audioManager.cleanup()
            forceMemoryCleanup()
        case 2:
            // Second warning: aggressive cleanup
            dataManager.aggressiveCleanup()
            forceMemoryCleanup()
        default:
            // Multiple warnings: Complete restart function
            cleanupAllResources()
            memoryWarningCount = 0
        }
    }
}

// MARK: - Smile Detection Callback
extension QAPracticeView {
    private func setupSmileDetectionCallback() {
        NotificationCenter.default.addObserver(
            forName: .smileProbabilityUpdated,
            object: nil,
            queue: .main
        ) { notification in
            guard isPracticeActive else { return }
            
            if let probability = notification.extractProbability() {
                recordSmileScore(probability)
            }
        }
    }
}