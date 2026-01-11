// MARK: - Questions List View
// Updated QuestionsListView.swift

import SwiftUI

struct QuestionsListView: View {
    let questionSet: QuestionSet
    @Environment(\.presentationMode) var presentationMode
    @State private var showingQAPractice = false
    @State private var showingTips = false
    @State private var selectedQuestionForTips: Question? = nil
    @State private var pendingQuestionForTips: Question? = nil
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Questions List
                List(questionSet.questions) { question in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(question.text)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack {
                            Text(question.difficulty.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(difficultyColor(for: question.difficulty))
                                )
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: {
                                pendingQuestionForTips = question
                                selectedQuestionForTips = question
                                showingTips = true
                            }) {
                                Text("Tips: \(question.tips.count)")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                    .underline()
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                // Next Button
                VStack(spacing: 12) {
                    Text("Ready to practice?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        showingQAPractice = true
                    }) {
                        Text("Next")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 16)
                .background(Color(.systemBackground))
            }
            .navigationTitle(questionSet.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Text("Preview \(questionSet.questions.count) Questions")
                .font(.subheadline)
                .foregroundColor(.secondary))
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
            .fullScreenCover(isPresented: $showingQAPractice) {
                QAPracticeView(questionSet: questionSet)
            }
                    .sheet(isPresented: $showingTips) {
            if let question = selectedQuestionForTips ?? pendingQuestionForTips {
                TipsDetailView(question: question)
            } else {
                // Fallback content to prevent blank square
                VStack {
                    Text("Loading Tips...")
                        .font(.title2)
                        .foregroundColor(.primary)
                    ProgressView()
                        .scaleEffect(1.5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
            }
        }
        .onChange(of: showingTips) { isShowing in
            if !isShowing {
                // Reset selectedQuestionForTips when modal is dismissed
                selectedQuestionForTips = nil
                pendingQuestionForTips = nil
            }
        }
        }
    }
    
    private func difficultyColor(for difficulty: Question.Difficulty) -> Color {
        switch difficulty {
        case .beginner:
            return .green
        case .intermediate:
            return .orange
        case .advanced:
            return .red
        default:
            return .gray
        }
    }
}

// MARK: - Tips Detail View
struct TipsDetailView: View {
    let question: Question
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Question
                VStack(alignment: .leading, spacing: 12) {
                    Text("Question")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(question.text)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                
                // Difficulty
                HStack {
                    Text("Difficulty:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(question.difficulty.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(difficultyColor(for: question.difficulty))
                        )
                        .foregroundColor(.white)
                }
                
                // Tips
                VStack(alignment: .leading, spacing: 12) {
                    Text("Tips")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(question.tips.enumerated()), id: \.offset) { index, tip in
                            HStack(alignment: .top, spacing: 12) {
                                Text("\(index + 1)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                                    .background(Circle().fill(Color.blue))
                                
                                Text(tip)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Tips")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func difficultyColor(for difficulty: Question.Difficulty) -> Color {
        switch difficulty {
        case .beginner:
            return .green
        case .intermediate:
            return .orange
        case .advanced:
            return .red
        default:
            return .gray
        }
    }
}
