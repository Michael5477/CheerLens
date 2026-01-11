// MARK: - Core Data Models
// Update your Models.swift file

import Foundation
import SwiftUI

// Move QuestionCategory to top level (outside QuestionSet)
enum QuestionCategory: String, Codable, CaseIterable {
    case universal = "Universal"
    case business = "Business & Management"
    case stem = "STEM & Technical"
    case finance = "Finance & Accounting"
    case marketing = "Marketing & Sales"
    case healthcare = "Healthcare & Medical"
}

// Question Set Structure
struct QuestionSet: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let description: String
    let category: QuestionCategory
    let questions: [Question]
    let isPremium: Bool
    let releaseDate: Date?
}

// Individual Question Structure
struct Question: Codable, Identifiable, Hashable {
    let id: Int
    let text: String
    let category: QuestionCategory  // Now this will work!
    let difficulty: Difficulty
    let tips: [String]
    
    enum Difficulty: String, Codable, CaseIterable {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
    }
}

// Practice Session Structure
struct PracticeSession: Codable, Identifiable {
    let id: UUID
    let questionSetId: Int
    let startTime: Date
    let endTime: Date?
    let duration: TimeInterval     // Fixed duration calculated when session is created
    let selectedQuestions: [Question]
    let smileScores: [SmileScore]  // Sampled data for chart display
    let smilePercentage: Double     // Time-based smile ratio percentage (>0.3)
}

// Smile Score Structure for trend chart
struct SmileScore: Codable, Identifiable {
    let id: UUID
    let time: TimeInterval
    let probability: Float
    
    init(time: TimeInterval, probability: Float) {
        self.id = UUID()
        self.time = time
        self.probability = probability
    }
}

// MARK: - Supporting Views
struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
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
