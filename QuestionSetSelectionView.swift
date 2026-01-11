// MARK: - Question Set Selection View
// Updated QuestionSetSelectionView.swift

import SwiftUI

struct QuestionSetSelectionView: View {
    @StateObject private var questionSetData = QuestionSetData.shared
    @State private var selectedCategory: QuestionCategory = .universal
    @State private var showingQuestionsList = false
    @State private var selectedQuestionSet: QuestionSet? = nil
    @State private var pendingQuestionSet: QuestionSet? = nil
    @State private var isDataLoaded = false
    @State private var isLoading = true
    @State private var hasInitialized = false
    @State private var dataReady = false
    @State private var questionSets: [QuestionSet] = []
    
    var body: some View {
        GeometryReader { geometry in
        VStack(spacing: 0) {
            // Header
            headerView
            
            // Category Picker
            categoryPickerView
            
            // Question Sets List
            questionSetsListView
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                .clipped()
        }
        }
        .onAppear {
            // Force data loading immediately and ensure proper initialization
            loadQuestionSets()
        }
        .onChange(of: selectedCategory) { newCategory in
            // Reload when category changes
            loadQuestionSets()
        }
        .sheet(isPresented: $showingQuestionsList) {
            if let selectedSet = selectedQuestionSet ?? pendingQuestionSet {
                QuestionsListView(questionSet: selectedSet)
            } else {
                // Fallback content to prevent blank square
                VStack {
                    Text("Loading...")
                        .font(.title2)
                        .foregroundColor(.primary)
                    ProgressView()
                        .scaleEffect(1.5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
            }
        }
        .onChange(of: showingQuestionsList) { isShowing in
            if !isShowing {
                // Reset selectedQuestionSet when modal is dismissed
                selectedQuestionSet = nil
                pendingQuestionSet = nil
            }
        }
    }
    
    // MARK: - Data Loading
    private func loadQuestionSets() {
        // Force immediate data loading
        let sets = questionSetData.getQuestionSets(for: selectedCategory)
        questionSets = sets
        isDataLoaded = true
        isLoading = false
        hasInitialized = true
        dataReady = !sets.isEmpty
        print("DEBUG: Loaded \(sets.count) question sets for \(selectedCategory)")
        
        // Ensure UI updates
        DispatchQueue.main.async {
            self.questionSets = sets
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 16) {
            Text("Remote Interview")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Smile Training")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Select a Question Set to Practice")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }
    
    // MARK: - Category Picker
    private var categoryPickerView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(QuestionCategory.allCases, id: \.self) { category in
                    CategoryButton(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                        // Update question sets when category changes
                        loadQuestionSets()
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
    }
    
    // MARK: - Question Sets List
    private var questionSetsListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if !questionSets.isEmpty {
                    ForEach(questionSets) { questionSet in
                        QuestionSetCard(
                            questionSet: questionSet
                        ) {
                            // Check if navigation is blocked
                            if UltimateCleaner.isNavigationBlocked() {
                                print("🧹 导航被阻止，等待清理完成...")
                                return
                            }
                            
                            UltimateCleaner.setNavigationInProgress(true)
                            pendingQuestionSet = questionSet
                            selectedQuestionSet = questionSet
                            
                            // Wait for cleanup to complete before navigation
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                if !UltimateCleaner.isNavigationBlocked() {
                                    showingQuestionsList = true
                                    UltimateCleaner.setNavigationInProgress(false)
                                }
                            }
                        }
                    }
                } else if isLoading {
                    // Loading state to prevent blank square
                    VStack(spacing: 16) {
                        ForEach(0..<5) { _ in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                                )
                                .overlay(
                                    Text("Loading...")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                )
                        }
                    }
                } else {
                    // No data state
                    VStack(spacing: 16) {
                        Text("No question sets available")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Category Button
struct CategoryButton: View {
    let category: QuestionCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(category.rawValue)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.1))
                )
        }
    }
}

// MARK: - Question Set Card
struct QuestionSetCard: View {
    let questionSet: QuestionSet
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(questionSet.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text(questionSet.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(questionSet.questions.count)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        
                        Text("Questions")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    Text(questionSet.category.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue.opacity(0.1))
                        )
                        .foregroundColor(.blue)
                    
                    Spacer()
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
