// MARK: - Question Set Data Manager
// Complete QuestionSetData.swift file

import Foundation

class QuestionSetData: ObservableObject {
    static let shared = QuestionSetData()
    
    @Published var allQuestionSets: [QuestionSet] = []
    
    init() {
        loadAllQuestionSets()
    }
    
    private func loadAllQuestionSets() {
        allQuestionSets = [
            // Universal Question Sets (IDs 1-5)
            createUniversalSet1(),    // ID: 1
            createBehavioralSet2(),   // ID: 2
            createCommunicationSet3(), // ID: 3
            createProblemSolvingSet4(), // ID: 4
            createLeadershipSet5(),   // ID: 5
            
            // Business & Management Question Sets (IDs 6-10)
            createBusinessGeneralSet6(),     // ID: 6
            createBusinessProjectSet7(),      // ID: 7
            createBusinessPeopleSet8(),       // ID: 8
            createBusinessStrategicSet9(),   // ID: 9
            createBusinessConsultingSet10(), // ID: 10
            
            // STEM & Technical Question Sets (IDs 11-15)
            createSTEMGeneralSet11(),     // ID: 11
            createSTEMSoftwareSet12(),    // ID: 12
            createSTEMDataSet13(),        // ID: 13
            createSTEMEngineeringSet14(), // ID: 14
            createSTEMResearchSet15(),     // ID: 15
            
            // Finance & Accounting Question Sets (IDs 16-20)
            createFinanceGeneralSet16(),     // ID: 16
            createFinanceAccountingSet17(),  // ID: 17
            createFinanceInvestmentSet18(),   // ID: 18
            createFinanceCorporateSet19(),   // ID: 19
            createFinanceRiskSet20(),        // ID: 20
            
            // Marketing & Sales Question Sets (IDs 21-25)
            createMarketingStrategySet21(),     // ID: 21
            createMarketingDigitalSet22(),     // ID: 22
            createMarketingSalesSet23(),        // ID: 23
            createMarketingProductSet24(),      // ID: 24
            createMarketingCustomerSet25(),     // ID: 25
            
            // Healthcare & Medical Question Sets (IDs 26-30)
            createHealthcareGeneralSet26(),     // ID: 26
            createHealthcareNursingSet27(),     // ID: 27
            createHealthcareResearchSet28(),    // ID: 28
            createHealthcarePublicHealthSet29(), // ID: 29
            createHealthcareAdminSet30()        // ID: 30
        ]
    }
    
    // MARK: - Universal Question Sets
    
    private func createUniversalSet1() -> QuestionSet {
        return QuestionSet(
            id: 1,
            title: "The Most Frequently Asked Questions in an Interview",
            description: "Essential questions that appear in almost every job interview",
            category: .universal,
            questions: [
                Question(id: 1, text: "Tell me about yourself.", category: .universal, difficulty: .beginner, tips: ["Keep it professional", "Focus on relevant experience"]),
                Question(id: 2, text: "Why do you want to work here?", category: .universal, difficulty: .beginner, tips: ["Research the company", "Connect to your goals"]),
                Question(id: 3, text: "What are your strengths?", category: .universal, difficulty: .beginner, tips: ["Be specific", "Give examples"]),
                Question(id: 4, text: "What are your weaknesses?", category: .universal, difficulty: .intermediate, tips: ["Be honest", "Show growth"]),
                Question(id: 5, text: "Can you describe a challenging situation you faced and how you handled it?", category: .universal, difficulty: .intermediate, tips: ["Use STAR method", "Focus on solution"]),
                Question(id: 6, text: "Where do you see yourself in five years?", category: .universal, difficulty: .beginner, tips: ["Be realistic", "Show ambition"]),
                Question(id: 7, text: "Why should we hire you over other candidates?", category: .universal, difficulty: .intermediate, tips: ["Highlight unique value", "Be confident"]),
                Question(id: 8, text: "How do you handle stress and pressure?", category: .universal, difficulty: .intermediate, tips: ["Give examples", "Show resilience"]),
                Question(id: 9, text: "Describe a time when you worked in a team.", category: .universal, difficulty: .intermediate, tips: ["Use specific example", "Show collaboration"]),
                Question(id: 10, text: "Do you have any questions for us?", category: .universal, difficulty: .beginner, tips: ["Ask thoughtful questions", "Show interest"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createBehavioralSet2() -> QuestionSet {
        return QuestionSet(
            id: 2,
            title: "Behavioral Interview Questions",
            description: "Questions that assess your past behavior and experiences",
            category: .universal,
            questions: [
                Question(id: 11, text: "Tell me about a time you took initiative.", category: .universal, difficulty: .intermediate, tips: ["Use STAR method", "Show leadership"]),
                Question(id: 12, text: "Describe a project you are most proud of.", category: .universal, difficulty: .intermediate, tips: ["Be specific", "Show impact"]),
                Question(id: 13, text: "Give an example of how you dealt with conflict at work.", category: .universal, difficulty: .intermediate, tips: ["Stay professional", "Focus on resolution"]),
                Question(id: 14, text: "Tell me about a time you failed and what you learned.", category: .universal, difficulty: .intermediate, tips: ["Be honest", "Show growth mindset"]),
                Question(id: 15, text: "Describe a situation where you had to adapt quickly.", category: .universal, difficulty: .intermediate, tips: ["Show flexibility", "Give example"]),
                Question(id: 16, text: "Give an example of how you prioritized multiple tasks.", category: .universal, difficulty: .intermediate, tips: ["Show organization", "Explain process"]),
                Question(id: 17, text: "Share a time you went above and beyond your responsibilities.", category: .universal, difficulty: .intermediate, tips: ["Show dedication", "Give specific example"]),
                Question(id: 18, text: "How do you handle feedback or criticism?", category: .universal, difficulty: .intermediate, tips: ["Show openness", "Give example"]),
                Question(id: 19, text: "Describe a situation where you had to persuade others.", category: .universal, difficulty: .intermediate, tips: ["Show communication", "Explain approach"]),
                Question(id: 20, text: "Tell me about a time you delivered results under a tight deadline.", category: .universal, difficulty: .intermediate, tips: ["Show time management", "Give example"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createCommunicationSet3() -> QuestionSet {
        return QuestionSet(
            id: 3,
            title: "Communication & Teamwork",
            description: "Questions about your communication and collaboration skills",
            category: .universal,
            questions: [
                Question(id: 21, text: "How do you usually communicate with your colleagues?", category: .universal, difficulty: .beginner, tips: ["Be specific", "Show adaptability"]),
                Question(id: 22, text: "Tell me about a time you had to present complex information clearly.", category: .universal, difficulty: .intermediate, tips: ["Use STAR method", "Show clarity"]),
                Question(id: 23, text: "How do you resolve misunderstandings in a team?", category: .universal, difficulty: .intermediate, tips: ["Show problem-solving", "Give example"]),
                Question(id: 24, text: "Have you ever disagreed with your manager? How did you handle it?", category: .universal, difficulty: .intermediate, tips: ["Stay professional", "Show diplomacy"]),
                Question(id: 25, text: "Describe your role in a successful team project.", category: .universal, difficulty: .intermediate, tips: ["Be specific", "Show contribution"]),
                Question(id: 26, text: "How do you deal with uncooperative team members?", category: .universal, difficulty: .intermediate, tips: ["Show conflict resolution", "Give example"]),
                Question(id: 27, text: "Tell me about a time you had to deliver bad news to someone.", category: .universal, difficulty: .intermediate, tips: ["Show empathy", "Explain approach"]),
                Question(id: 28, text: "How do you ensure everyone is on the same page in a group project?", category: .universal, difficulty: .intermediate, tips: ["Show organization", "Give example"]),
                Question(id: 29, text: "How do you approach working with cross-functional teams?", category: .universal, difficulty: .intermediate, tips: ["Show adaptability", "Explain process"]),
                Question(id: 30, text: "How do you motivate others in a team?", category: .universal, difficulty: .intermediate, tips: ["Show leadership", "Give example"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createProblemSolvingSet4() -> QuestionSet {
        return QuestionSet(
            id: 4,
            title: "Problem-Solving & Critical Thinking",
            description: "Questions that test your analytical and problem-solving abilities",
            category: .universal,
            questions: [
                Question(id: 31, text: "Describe a time you solved a difficult problem.", category: .universal, difficulty: .intermediate, tips: ["Use STAR method", "Show process"]),
                Question(id: 32, text: "How do you approach decision-making when information is incomplete?", category: .universal, difficulty: .intermediate, tips: ["Show analytical thinking", "Give example"]),
                Question(id: 33, text: "Tell me about a time you had to analyze data to make a recommendation.", category: .universal, difficulty: .intermediate, tips: ["Show data skills", "Explain approach"]),
                Question(id: 34, text: "How do you approach troubleshooting an unexpected issue?", category: .universal, difficulty: .intermediate, tips: ["Show systematic approach", "Give example"]),
                Question(id: 35, text: "Share an example of when you developed a creative solution.", category: .universal, difficulty: .intermediate, tips: ["Show innovation", "Explain process"]),
                Question(id: 36, text: "How do you prioritize problems when multiple issues arise?", category: .universal, difficulty: .intermediate, tips: ["Show organization", "Give example"]),
                Question(id: 37, text: "Tell me about a time when your solution didn't work—what did you do?", category: .universal, difficulty: .intermediate, tips: ["Show resilience", "Explain learning"]),
                Question(id: 38, text: "How do you evaluate risks before making a decision?", category: .universal, difficulty: .intermediate, tips: ["Show risk assessment", "Give example"]),
                Question(id: 39, text: "Describe a time you improved a process.", category: .universal, difficulty: .intermediate, tips: ["Show improvement mindset", "Explain impact"]),
                Question(id: 40, text: "How do you approach learning something completely new?", category: .universal, difficulty: .intermediate, tips: ["Show learning ability", "Give example"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createLeadershipSet5() -> QuestionSet {
        return QuestionSet(
            id: 5,
            title: "Leadership & Career Growth",
            description: "Questions about your leadership experience and career aspirations",
            category: .universal,
            questions: [
                Question(id: 41, text: "Tell me about a time you led a team or project.", category: .universal, difficulty: .intermediate, tips: ["Use STAR method", "Show leadership"]),
                Question(id: 42, text: "How do you delegate tasks effectively?", category: .universal, difficulty: .intermediate, tips: ["Show management skills", "Give example"]),
                Question(id: 43, text: "What motivates you as a leader?", category: .universal, difficulty: .intermediate, tips: ["Be authentic", "Show values"]),
                Question(id: 44, text: "How do you handle underperforming team members?", category: .universal, difficulty: .intermediate, tips: ["Show management approach", "Give example"]),
                Question(id: 45, text: "Describe your leadership style.", category: .universal, difficulty: .intermediate, tips: ["Be specific", "Show self-awareness"]),
                Question(id: 46, text: "Tell me about a time you inspired others.", category: .universal, difficulty: .intermediate, tips: ["Show influence", "Give example"]),
                Question(id: 47, text: "How do you manage competing priorities as a leader?", category: .universal, difficulty: .intermediate, tips: ["Show organization", "Explain process"]),
                Question(id: 48, text: "What's the most difficult leadership decision you've made?", category: .universal, difficulty: .intermediate, tips: ["Show decision-making", "Explain reasoning"]),
                Question(id: 49, text: "How do you develop the skills of people you manage?", category: .universal, difficulty: .intermediate, tips: ["Show development focus", "Give example"]),
                Question(id: 50, text: "What kind of leader do you want to become in the future?", category: .universal, difficulty: .intermediate, tips: ["Show growth mindset", "Be specific"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    // MARK: - Business & Management Question Sets
    
    private func createBusinessGeneralSet6() -> QuestionSet {
        return QuestionSet(
            id: 6,
            title: "General Business Knowledge",
            description: "Fundamental business concepts and industry awareness",
            category: .business,
            questions: [
                Question(id: 51, text: "What are the biggest challenges businesses face today?", category: .business, difficulty: .intermediate, tips: ["Show industry awareness", "Give specific examples"]),
                Question(id: 52, text: "How do you stay informed about industry trends?", category: .business, difficulty: .beginner, tips: ["Show learning mindset", "Give specific sources"]),
                Question(id: 53, text: "Describe a time you identified a new business opportunity.", category: .business, difficulty: .intermediate, tips: ["Use STAR method", "Show analytical thinking"]),
                Question(id: 54, text: "How do you evaluate market competition?", category: .business, difficulty: .intermediate, tips: ["Show analytical skills", "Explain methodology"]),
                Question(id: 55, text: "What role does innovation play in business success?", category: .business, difficulty: .intermediate, tips: ["Show strategic thinking", "Give examples"]),
                Question(id: 56, text: "How do you assess customer needs?", category: .business, difficulty: .intermediate, tips: ["Show customer focus", "Explain approach"]),
                Question(id: 57, text: "Describe a time you helped improve business efficiency.", category: .business, difficulty: .intermediate, tips: ["Use STAR method", "Show results"]),
                Question(id: 58, text: "What are the key elements of a successful business plan?", category: .business, difficulty: .intermediate, tips: ["Show business knowledge", "Be comprehensive"]),
                Question(id: 59, text: "How do you measure business performance?", category: .business, difficulty: .intermediate, tips: ["Show analytical skills", "Give specific metrics"]),
                Question(id: 60, text: "How do you balance cost and quality in decision-making?", category: .business, difficulty: .intermediate, tips: ["Show strategic thinking", "Give examples"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createBusinessProjectSet7() -> QuestionSet {
        return QuestionSet(
            id: 7,
            title: "Project Management & Execution",
            description: "Project planning, execution, and management skills",
            category: .business,
            questions: [
                Question(id: 61, text: "Describe your experience managing projects.", category: .business, difficulty: .intermediate, tips: ["Be specific", "Show leadership"]),
                Question(id: 62, text: "How do you define project success?", category: .business, difficulty: .intermediate, tips: ["Show clear thinking", "Give metrics"]),
                Question(id: 63, text: "Tell me about a project that didn't go as planned.", category: .business, difficulty: .intermediate, tips: ["Use STAR method", "Show learning"]),
                Question(id: 64, text: "How do you manage project risks?", category: .business, difficulty: .intermediate, tips: ["Show risk management", "Explain process"]),
                Question(id: 65, text: "What tools do you use for project tracking?", category: .business, difficulty: .intermediate, tips: ["Show technical skills", "Give examples"]),
                Question(id: 66, text: "How do you handle scope creep?", category: .business, difficulty: .intermediate, tips: ["Show management skills", "Give example"]),
                Question(id: 67, text: "Describe a time you had to reallocate resources mid-project.", category: .business, difficulty: .intermediate, tips: ["Use STAR method", "Show adaptability"]),
                Question(id: 68, text: "How do you prioritize tasks within a project?", category: .business, difficulty: .intermediate, tips: ["Show organization", "Explain methodology"]),
                Question(id: 69, text: "How do you communicate progress to stakeholders?", category: .business, difficulty: .intermediate, tips: ["Show communication skills", "Give examples"]),
                Question(id: 70, text: "Tell me about a project you are most proud of.", category: .business, difficulty: .intermediate, tips: ["Be specific", "Show passion"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createBusinessPeopleSet8() -> QuestionSet {
        return QuestionSet(
            id: 8,
            title: "People Management & HR Scenarios",
            description: "Team management, conflict resolution, and employee development",
            category: .business,
            questions: [
                Question(id: 71, text: "How do you handle conflict between team members?", category: .business, difficulty: .intermediate, tips: ["Show conflict resolution", "Give example"]),
                Question(id: 72, text: "Tell me about a time you coached someone to improve.", category: .business, difficulty: .intermediate, tips: ["Use STAR method", "Show development focus"]),
                Question(id: 73, text: "How do you handle underperforming employees?", category: .business, difficulty: .intermediate, tips: ["Show management skills", "Explain approach"]),
                Question(id: 74, text: "Describe a time you managed a diverse team.", category: .business, difficulty: .intermediate, tips: ["Use STAR method", "Show inclusivity"]),
                Question(id: 75, text: "How do you foster employee engagement?", category: .business, difficulty: .intermediate, tips: ["Show leadership", "Give specific strategies"]),
                Question(id: 76, text: "Tell me about a time you had to let someone go.", category: .business, difficulty: .advanced, tips: ["Show professionalism", "Explain process"]),
                Question(id: 77, text: "How do you recognize and reward employees?", category: .business, difficulty: .intermediate, tips: ["Show appreciation", "Give examples"]),
                Question(id: 78, text: "How do you balance individual and team goals?", category: .business, difficulty: .intermediate, tips: ["Show strategic thinking", "Explain approach"]),
                Question(id: 79, text: "Describe your approach to performance reviews.", category: .business, difficulty: .intermediate, tips: ["Show fairness", "Explain process"]),
                Question(id: 80, text: "How do you build trust within your team?", category: .business, difficulty: .intermediate, tips: ["Show leadership", "Give specific actions"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createBusinessStrategicSet9() -> QuestionSet {
        return QuestionSet(
            id: 9,
            title: "Strategic Thinking & Decision-Making",
            description: "Strategic planning, analysis, and long-term decision making",
            category: .business,
            questions: [
                Question(id: 81, text: "Describe a strategic decision you made and its impact.", category: .business, difficulty: .intermediate, tips: ["Use STAR method", "Show results"]),
                Question(id: 82, text: "How do you align decisions with company goals?", category: .business, difficulty: .intermediate, tips: ["Show strategic thinking", "Explain process"]),
                Question(id: 83, text: "How do you analyze competitive threats?", category: .business, difficulty: .intermediate, tips: ["Show analytical skills", "Give methodology"]),
                Question(id: 84, text: "Tell me about a time you adjusted strategy mid-course.", category: .business, difficulty: .intermediate, tips: ["Use STAR method", "Show adaptability"]),
                Question(id: 85, text: "How do you evaluate long-term vs short-term priorities?", category: .business, difficulty: .intermediate, tips: ["Show strategic thinking", "Give examples"]),
                Question(id: 86, text: "Describe a time you managed limited resources strategically.", category: .business, difficulty: .intermediate, tips: ["Use STAR method", "Show resourcefulness"]),
                Question(id: 87, text: "How do you identify key business drivers?", category: .business, difficulty: .intermediate, tips: ["Show analytical skills", "Explain approach"]),
                Question(id: 88, text: "Tell me about a time you anticipated a market shift.", category: .business, difficulty: .intermediate, tips: ["Use STAR method", "Show foresight"]),
                Question(id: 89, text: "How do you approach data-driven decisions?", category: .business, difficulty: .intermediate, tips: ["Show analytical thinking", "Give examples"]),
                Question(id: 90, text: "How do you handle uncertainty in planning?", category: .business, difficulty: .intermediate, tips: ["Show strategic thinking", "Explain approach"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createBusinessConsultingSet10() -> QuestionSet {
        return QuestionSet(
            id: 10,
            title: "Consulting & Client-Facing Scenarios",
            description: "Client relationship management and consulting skills",
            category: .business,
            questions: [
                Question(id: 91, text: "How do you build trust with clients?", category: .business, difficulty: .intermediate, tips: ["Show relationship skills", "Give specific actions"]),
                Question(id: 92, text: "Describe a time you had to deliver bad news to a client.", category: .business, difficulty: .intermediate, tips: ["Use STAR method", "Show communication skills"]),
                Question(id: 93, text: "How do you manage conflicting client expectations?", category: .business, difficulty: .intermediate, tips: ["Show problem-solving", "Give example"]),
                Question(id: 94, text: "Tell me about a time you added unexpected value for a client.", category: .business, difficulty: .intermediate, tips: ["Use STAR method", "Show initiative"]),
                Question(id: 95, text: "How do you manage client confidentiality?", category: .business, difficulty: .intermediate, tips: ["Show professionalism", "Explain protocols"]),
                Question(id: 96, text: "Describe a time you had to persuade a skeptical client.", category: .business, difficulty: .intermediate, tips: ["Use STAR method", "Show persuasion skills"]),
                Question(id: 97, text: "How do you handle scope changes requested by clients?", category: .business, difficulty: .intermediate, tips: ["Show management skills", "Explain approach"]),
                Question(id: 98, text: "How do you prepare for client presentations?", category: .business, difficulty: .intermediate, tips: ["Show preparation skills", "Give methodology"]),
                Question(id: 99, text: "Tell me about a time you built a long-term client relationship.", category: .business, difficulty: .intermediate, tips: ["Use STAR method", "Show relationship building"]),
                Question(id: 100, text: "How do you balance client needs with company capabilities?", category: .business, difficulty: .intermediate, tips: ["Show strategic thinking", "Give examples"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createSTEMGeneralSet11() -> QuestionSet {
        return QuestionSet(
            id: 11,
            title: "General STEM Background Questions",
            description: "Fundamental STEM knowledge and career motivation",
            category: .stem,
            questions: [
                Question(id: 141, text: "What inspired you to pursue a STEM career?", category: .stem, difficulty: .beginner, tips: ["Show passion", "Be authentic"]),
                Question(id: 142, text: "How do you keep up with advances in science and technology?", category: .stem, difficulty: .intermediate, tips: ["Show learning mindset", "Give specific sources"]),
                Question(id: 143, text: "Describe a challenging STEM project you worked on.", category: .stem, difficulty: .intermediate, tips: ["Use STAR method", "Show technical skills"]),
                Question(id: 144, text: "How do you approach problem-solving in technical fields?", category: .stem, difficulty: .intermediate, tips: ["Show systematic thinking", "Explain methodology"]),
                Question(id: 145, text: "Tell me about a time you applied theory to practice.", category: .stem, difficulty: .intermediate, tips: ["Use STAR method", "Show practical application"]),
                Question(id: 146, text: "How do you communicate complex STEM ideas to non-technical people?", category: .stem, difficulty: .intermediate, tips: ["Show communication skills", "Give examples"]),
                Question(id: 147, text: "What role do ethics play in scientific research?", category: .stem, difficulty: .intermediate, tips: ["Show ethical awareness", "Give examples"]),
                Question(id: 148, text: "Describe a time you had to troubleshoot a technical problem.", category: .stem, difficulty: .intermediate, tips: ["Use STAR method", "Show problem-solving"]),
                Question(id: 149, text: "How do you balance precision with deadlines in STEM work?", category: .stem, difficulty: .intermediate, tips: ["Show time management", "Give examples"]),
                Question(id: 150, text: "What's the most impactful STEM project you have contributed to?", category: .stem, difficulty: .intermediate, tips: ["Be specific", "Show impact"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createSTEMSoftwareSet12() -> QuestionSet {
        return QuestionSet(
            id: 12,
            title: "Software Engineering & Programming",
            description: "Programming skills, software development, and technical implementation",
            category: .stem,
            questions: [
                Question(id: 151, text: "What programming languages are you most comfortable with, and why?", category: .stem, difficulty: .intermediate, tips: ["Be specific", "Show reasoning"]),
                Question(id: 152, text: "Describe a challenging coding project you completed.", category: .stem, difficulty: .intermediate, tips: ["Use STAR method", "Show technical skills"]),
                Question(id: 153, text: "How do you ensure your code is maintainable and scalable?", category: .stem, difficulty: .intermediate, tips: ["Show best practices", "Give examples"]),
                Question(id: 154, text: "Tell me about a time you debugged a complex issue.", category: .stem, difficulty: .intermediate, tips: ["Use STAR method", "Show problem-solving"]),
                Question(id: 155, text: "How do you stay updated with new programming frameworks?", category: .stem, difficulty: .intermediate, tips: ["Show learning mindset", "Give specific sources"]),
                Question(id: 156, text: "Describe your experience working with version control systems.", category: .stem, difficulty: .intermediate, tips: ["Show technical skills", "Give examples"]),
                Question(id: 157, text: "How do you approach system design problems?", category: .stem, difficulty: .intermediate, tips: ["Show architectural thinking", "Explain approach"]),
                Question(id: 158, text: "Tell me about a time you optimized code for performance.", category: .stem, difficulty: .intermediate, tips: ["Use STAR method", "Show optimization skills"]),
                Question(id: 159, text: "How do you handle technical debt in a project?", category: .stem, difficulty: .intermediate, tips: ["Show strategic thinking", "Give examples"]),
                Question(id: 160, text: "Describe your experience working in agile or scrum teams.", category: .stem, difficulty: .intermediate, tips: ["Show teamwork", "Give specific examples"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createSTEMDataSet13() -> QuestionSet {
        return QuestionSet(
            id: 13,
            title: "Data Science & Analytics",
            description: "Data analysis, machine learning, and statistical methods",
            category: .stem,
            questions: [
                Question(id: 161, text: "How do you approach cleaning and preparing large datasets?", category: .stem, difficulty: .intermediate, tips: ["Show data skills", "Explain methodology"]),
                Question(id: 162, text: "What statistical methods do you use most often?", category: .stem, difficulty: .intermediate, tips: ["Be specific", "Show knowledge"]),
                Question(id: 163, text: "Tell me about a time you uncovered insights from messy data.", category: .stem, difficulty: .intermediate, tips: ["Use STAR method", "Show analytical skills"]),
                Question(id: 164, text: "How do you decide which machine learning model to use?", category: .stem, difficulty: .intermediate, tips: ["Show ML knowledge", "Explain decision process"]),
                Question(id: 165, text: "Describe a project where your analysis influenced business decisions.", category: .stem, difficulty: .intermediate, tips: ["Use STAR method", "Show business impact"]),
                Question(id: 166, text: "How do you communicate data findings to non-technical stakeholders?", category: .stem, difficulty: .intermediate, tips: ["Show communication skills", "Give examples"]),
                Question(id: 167, text: "Tell me about a time you dealt with biased data.", category: .stem, difficulty: .intermediate, tips: ["Use STAR method", "Show ethical awareness"]),
                Question(id: 168, text: "What are the biggest challenges in predictive modeling?", category: .stem, difficulty: .intermediate, tips: ["Show domain knowledge", "Give specific challenges"]),
                Question(id: 169, text: "How do you handle missing data in your analysis?", category: .stem, difficulty: .intermediate, tips: ["Show technical skills", "Explain approach"]),
                Question(id: 170, text: "Describe a time you automated a data process successfully.", category: .stem, difficulty: .intermediate, tips: ["Use STAR method", "Show automation skills"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createSTEMEngineeringSet14() -> QuestionSet {
        return QuestionSet(
            id: 14,
            title: "Engineering (Mechanical, Electrical, Civil)",
            description: "Engineering design, safety, and technical problem-solving",
            category: .stem,
            questions: [
                Question(id: 171, text: "Tell me about a complex engineering project you worked on.", category: .stem, difficulty: .intermediate, tips: ["Use STAR method", "Show technical skills"]),
                Question(id: 172, text: "How do you approach safety and compliance in engineering design?", category: .stem, difficulty: .intermediate, tips: ["Show safety awareness", "Explain protocols"]),
                Question(id: 173, text: "Describe a time you solved a problem with limited resources.", category: .stem, difficulty: .intermediate, tips: ["Use STAR method", "Show resourcefulness"]),
                Question(id: 174, text: "How do you balance cost, performance, and safety in projects?", category: .stem, difficulty: .intermediate, tips: ["Show strategic thinking", "Give examples"]),
                Question(id: 175, text: "Tell me about a time you worked with cross-disciplinary engineers.", category: .stem, difficulty: .intermediate, tips: ["Use STAR method", "Show collaboration"]),
                Question(id: 176, text: "How do you troubleshoot system failures?", category: .stem, difficulty: .intermediate, tips: ["Show systematic approach", "Explain process"]),
                Question(id: 177, text: "Describe a project where you applied engineering simulations.", category: .stem, difficulty: .intermediate, tips: ["Use STAR method", "Show technical skills"]),
                Question(id: 178, text: "How do you stay updated with industry regulations and standards?", category: .stem, difficulty: .intermediate, tips: ["Show learning mindset", "Give specific sources"]),
                Question(id: 179, text: "Tell me about a time you managed unexpected design changes.", category: .stem, difficulty: .intermediate, tips: ["Use STAR method", "Show adaptability"]),
                Question(id: 180, text: "How do you document your engineering work for future reference?", category: .stem, difficulty: .intermediate, tips: ["Show organization", "Explain approach"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createSTEMResearchSet15() -> QuestionSet {
        return QuestionSet(
            id: 15,
            title: "Research & Academic STEM Roles",
            description: "Research methodology, academic collaboration, and scientific publishing",
            category: .stem,
            questions: [
                Question(id: 181, text: "Tell me about your most significant research project.", category: .stem, difficulty: .intermediate, tips: ["Be specific", "Show impact"]),
                Question(id: 182, text: "How do you design experiments to minimize bias?", category: .stem, difficulty: .intermediate, tips: ["Show research skills", "Explain methodology"]),
                Question(id: 183, text: "Describe a time you dealt with inconclusive results.", category: .stem, difficulty: .intermediate, tips: ["Use STAR method", "Show resilience"]),
                Question(id: 184, text: "How do you secure funding for research projects?", category: .stem, difficulty: .intermediate, tips: ["Show grant writing skills", "Give examples"]),
                Question(id: 185, text: "Tell me about a time you published or presented your work.", category: .stem, difficulty: .intermediate, tips: ["Use STAR method", "Show communication skills"]),
                Question(id: 186, text: "How do you collaborate with other researchers?", category: .stem, difficulty: .intermediate, tips: ["Show teamwork", "Give examples"]),
                Question(id: 187, text: "Describe your experience with peer review.", category: .stem, difficulty: .intermediate, tips: ["Show academic experience", "Give examples"]),
                Question(id: 188, text: "How do you balance teaching, research, and service in academia?", category: .stem, difficulty: .intermediate, tips: ["Show time management", "Explain approach"]),
                Question(id: 189, text: "Tell me about a time your research challenged existing assumptions.", category: .stem, difficulty: .intermediate, tips: ["Use STAR method", "Show innovation"]),
                Question(id: 190, text: "How do you define success in academic research?", category: .stem, difficulty: .intermediate, tips: ["Show academic mindset", "Be specific"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createFinanceGeneralSet16() -> QuestionSet {
        return QuestionSet(
            id: 16,
            title: "General Finance Knowledge",
            description: "Fundamental finance concepts and market understanding",
            category: .finance,
            questions: [
                Question(id: 221, text: "What are the key financial statements, and how are they connected?", category: .finance, difficulty: .intermediate, tips: ["Show fundamental knowledge", "Explain relationships"]),
                Question(id: 222, text: "Explain the concept of time value of money.", category: .finance, difficulty: .intermediate, tips: ["Show technical knowledge", "Give examples"]),
                Question(id: 223, text: "How do interest rates affect financial markets?", category: .finance, difficulty: .intermediate, tips: ["Show market understanding", "Explain mechanisms"]),
                Question(id: 224, text: "Tell me about a time you analyzed a company's financial health.", category: .finance, difficulty: .intermediate, tips: ["Use STAR method", "Show analytical skills"]),
                Question(id: 225, text: "What's the difference between equity financing and debt financing?", category: .finance, difficulty: .intermediate, tips: ["Show knowledge", "Explain pros/cons"]),
                Question(id: 226, text: "How do you assess the financial risk of an investment?", category: .finance, difficulty: .intermediate, tips: ["Show risk assessment", "Explain methodology"]),
                Question(id: 227, text: "Describe a time you explained finance concepts to a non-finance colleague.", category: .finance, difficulty: .intermediate, tips: ["Use STAR method", "Show communication skills"]),
                Question(id: 228, text: "What role does financial forecasting play in business decisions?", category: .finance, difficulty: .intermediate, tips: ["Show strategic thinking", "Give examples"]),
                Question(id: 229, text: "How do macroeconomic factors influence financial planning?", category: .finance, difficulty: .intermediate, tips: ["Show economic awareness", "Explain connections"]),
                Question(id: 230, text: "What recent trend in finance do you find most interesting?", category: .finance, difficulty: .intermediate, tips: ["Show industry awareness", "Be specific"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createFinanceAccountingSet17() -> QuestionSet {
        return QuestionSet(
            id: 17,
            title: "Accounting & Auditing Scenarios",
            description: "Accounting principles, auditing processes, and compliance",
            category: .finance,
            questions: [
                Question(id: 231, text: "Walk me through the accounting cycle.", category: .finance, difficulty: .intermediate, tips: ["Show systematic knowledge", "Explain each step"]),
                Question(id: 232, text: "How do you ensure accuracy in financial reporting?", category: .finance, difficulty: .intermediate, tips: ["Show attention to detail", "Explain processes"]),
                Question(id: 233, text: "Tell me about a time you identified an accounting error.", category: .finance, difficulty: .intermediate, tips: ["Use STAR method", "Show analytical skills"]),
                Question(id: 234, text: "How do you approach compliance with accounting standards (GAAP/IFRS)?", category: .finance, difficulty: .intermediate, tips: ["Show regulatory knowledge", "Explain approach"]),
                Question(id: 235, text: "Describe your experience with audit processes.", category: .finance, difficulty: .intermediate, tips: ["Show audit knowledge", "Give examples"]),
                Question(id: 236, text: "How do you manage deadlines during audit season?", category: .finance, difficulty: .intermediate, tips: ["Show time management", "Explain strategies"]),
                Question(id: 237, text: "Tell me about a time you explained audit findings to management.", category: .finance, difficulty: .intermediate, tips: ["Use STAR method", "Show communication skills"]),
                Question(id: 238, text: "How do you ensure integrity in financial statements?", category: .finance, difficulty: .intermediate, tips: ["Show ethical awareness", "Explain controls"]),
                Question(id: 239, text: "What's the role of internal controls in accounting?", category: .finance, difficulty: .intermediate, tips: ["Show control knowledge", "Explain importance"]),
                Question(id: 240, text: "Describe a time you handled confidential financial information.", category: .finance, difficulty: .intermediate, tips: ["Use STAR method", "Show confidentiality"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createFinanceInvestmentSet18() -> QuestionSet {
        return QuestionSet(
            id: 18,
            title: "Investment Banking & Capital Markets",
            description: "Company valuation, financial modeling, and deal execution",
            category: .finance,
            questions: [
                Question(id: 241, text: "How do you value a company?", category: .finance, difficulty: .intermediate, tips: ["Show valuation knowledge", "Explain methodologies"]),
                Question(id: 242, text: "What are the main types of financial modeling you've used?", category: .finance, difficulty: .intermediate, tips: ["Be specific", "Show technical skills"]),
                Question(id: 243, text: "Tell me about a deal you worked on (real or case study).", category: .finance, difficulty: .intermediate, tips: ["Use STAR method", "Show deal experience"]),
                Question(id: 244, text: "How do you stay updated with capital markets trends?", category: .finance, difficulty: .intermediate, tips: ["Show market awareness", "Give specific sources"]),
                Question(id: 245, text: "Describe a time you worked under extreme time pressure.", category: .finance, difficulty: .intermediate, tips: ["Use STAR method", "Show composure"]),
                Question(id: 246, text: "How do mergers and acquisitions impact company valuation?", category: .finance, difficulty: .intermediate, tips: ["Show M&A knowledge", "Explain impacts"]),
                Question(id: 247, text: "Tell me about a time you had to prepare a pitch book.", category: .finance, difficulty: .intermediate, tips: ["Use STAR method", "Show presentation skills"]),
                Question(id: 248, text: "How do you assess risk in high-profile deals?", category: .finance, difficulty: .intermediate, tips: ["Show risk assessment", "Explain approach"]),
                Question(id: 249, text: "Explain the difference between IPO and direct listing.", category: .finance, difficulty: .intermediate, tips: ["Show market knowledge", "Explain differences"]),
                Question(id: 250, text: "What role does relationship management play in investment banking?", category: .finance, difficulty: .intermediate, tips: ["Show relationship skills", "Explain importance"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createFinanceCorporateSet19() -> QuestionSet {
        return QuestionSet(
            id: 19,
            title: "Corporate Finance & FP&A",
            description: "Financial planning, budgeting, and corporate financial analysis",
            category: .finance,
            questions: [
                Question(id: 251, text: "How do you approach building a financial model for budgeting?", category: .finance, difficulty: .intermediate, tips: ["Show modeling skills", "Explain approach"]),
                Question(id: 252, text: "Tell me about a time you worked on forecasting revenue.", category: .finance, difficulty: .intermediate, tips: ["Use STAR method", "Show forecasting skills"]),
                Question(id: 253, text: "How do you evaluate capital expenditure projects?", category: .finance, difficulty: .intermediate, tips: ["Show evaluation methods", "Explain criteria"]),
                Question(id: 254, text: "Describe a time you provided financial insights for executives.", category: .finance, difficulty: .intermediate, tips: ["Use STAR method", "Show communication skills"]),
                Question(id: 255, text: "How do you calculate a company's weighted average cost of capital (WACC)?", category: .finance, difficulty: .intermediate, tips: ["Show technical knowledge", "Explain components"]),
                Question(id: 256, text: "Tell me about a time you analyzed a variance in financial results.", category: .finance, difficulty: .intermediate, tips: ["Use STAR method", "Show analytical skills"]),
                Question(id: 257, text: "How do you balance short-term financial goals with long-term growth?", category: .finance, difficulty: .intermediate, tips: ["Show strategic thinking", "Give examples"]),
                Question(id: 258, text: "Describe your experience with scenario analysis.", category: .finance, difficulty: .intermediate, tips: ["Show analytical skills", "Give examples"]),
                Question(id: 259, text: "How do you measure the financial performance of business units?", category: .finance, difficulty: .intermediate, tips: ["Show performance metrics", "Explain approach"]),
                Question(id: 260, text: "What KPIs do you consider most important for company performance?", category: .finance, difficulty: .intermediate, tips: ["Show business acumen", "Be specific"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createFinanceRiskSet20() -> QuestionSet {
        return QuestionSet(
            id: 20,
            title: "Risk Management & Compliance",
            description: "Financial risk assessment, regulatory compliance, and fraud prevention",
            category: .finance,
            questions: [
                Question(id: 261, text: "How do you identify financial risks in a business?", category: .finance, difficulty: .intermediate, tips: ["Show risk assessment", "Explain methodology"]),
                Question(id: 262, text: "Tell me about a time you managed a compliance issue.", category: .finance, difficulty: .intermediate, tips: ["Use STAR method", "Show problem-solving"]),
                Question(id: 263, text: "What's the difference between operational risk and credit risk?", category: .finance, difficulty: .intermediate, tips: ["Show risk knowledge", "Explain differences"]),
                Question(id: 264, text: "How do you assess the risk of a new investment?", category: .finance, difficulty: .intermediate, tips: ["Show assessment skills", "Explain process"]),
                Question(id: 265, text: "Describe your experience with regulatory compliance (e.g., SOX, Basel III).", category: .finance, difficulty: .intermediate, tips: ["Show regulatory knowledge", "Give examples"]),
                Question(id: 266, text: "Tell me about a time you had to report a risk to leadership.", category: .finance, difficulty: .intermediate, tips: ["Use STAR method", "Show communication skills"]),
                Question(id: 267, text: "How do you balance profitability with regulatory requirements?", category: .finance, difficulty: .intermediate, tips: ["Show strategic thinking", "Give examples"]),
                Question(id: 268, text: "What's the role of stress testing in risk management?", category: .finance, difficulty: .intermediate, tips: ["Show risk knowledge", "Explain importance"]),
                Question(id: 269, text: "Describe a time you dealt with fraud detection or prevention.", category: .finance, difficulty: .intermediate, tips: ["Use STAR method", "Show vigilance"]),
                Question(id: 270, text: "How do you keep updated with changing financial regulations?", category: .finance, difficulty: .intermediate, tips: ["Show learning mindset", "Give specific sources"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createMarketingStrategySet21() -> QuestionSet {
        return QuestionSet(
            id: 21,
            title: "Marketing Strategy & Branding",
            description: "Brand development, market research, and strategic marketing planning",
            category: .marketing,
            questions: [
                Question(id: 291, text: "How do you define a successful brand?", category: .marketing, difficulty: .intermediate, tips: ["Show brand knowledge", "Give specific criteria"]),
                Question(id: 292, text: "Tell me about a time you helped shape a company's brand identity.", category: .marketing, difficulty: .intermediate, tips: ["Use STAR method", "Show brand development"]),
                Question(id: 293, text: "How do you conduct market research for a new product?", category: .marketing, difficulty: .intermediate, tips: ["Show research skills", "Explain methodology"]),
                Question(id: 294, text: "Describe a time you repositioned a product or service.", category: .marketing, difficulty: .intermediate, tips: ["Use STAR method", "Show strategic thinking"]),
                Question(id: 295, text: "How do you evaluate brand equity?", category: .marketing, difficulty: .intermediate, tips: ["Show analytical skills", "Explain metrics"]),
                Question(id: 296, text: "Tell me about a time you created a marketing strategy from scratch.", category: .marketing, difficulty: .intermediate, tips: ["Use STAR method", "Show strategic planning"]),
                Question(id: 297, text: "How do you measure the success of a marketing campaign?", category: .marketing, difficulty: .intermediate, tips: ["Show analytical skills", "Give specific metrics"]),
                Question(id: 298, text: "Describe your approach to competitor analysis.", category: .marketing, difficulty: .intermediate, tips: ["Show analytical thinking", "Explain methodology"]),
                Question(id: 299, text: "Tell me about a brand you admire and why.", category: .marketing, difficulty: .intermediate, tips: ["Show brand awareness", "Be specific"]),
                Question(id: 300, text: "How do you ensure consistency across all brand touchpoints?", category: .marketing, difficulty: .intermediate, tips: ["Show brand management", "Explain approach"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createMarketingDigitalSet22() -> QuestionSet {
        return QuestionSet(
            id: 22,
            title: "Digital Marketing & Analytics",
            description: "Digital channels, SEO, analytics, and online marketing strategies",
            category: .marketing,
            questions: [
                Question(id: 301, text: "What digital channels do you find most effective, and why?", category: .marketing, difficulty: .intermediate, tips: ["Be specific", "Show data-driven thinking"]),
                Question(id: 302, text: "How do you use SEO to drive organic traffic?", category: .marketing, difficulty: .intermediate, tips: ["Show technical skills", "Explain strategies"]),
                Question(id: 303, text: "Describe a time you improved conversion rates online.", category: .marketing, difficulty: .intermediate, tips: ["Use STAR method", "Show optimization skills"]),
                Question(id: 304, text: "How do you approach A/B testing for campaigns?", category: .marketing, difficulty: .intermediate, tips: ["Show analytical skills", "Explain methodology"]),
                Question(id: 305, text: "Tell me about a time you managed a paid advertising campaign.", category: .marketing, difficulty: .intermediate, tips: ["Use STAR method", "Show campaign management"]),
                Question(id: 306, text: "How do you use analytics to guide digital marketing strategies?", category: .marketing, difficulty: .intermediate, tips: ["Show data-driven approach", "Give examples"]),
                Question(id: 307, text: "Describe a time you grew a brand's social media presence.", category: .marketing, difficulty: .intermediate, tips: ["Use STAR method", "Show social media skills"]),
                Question(id: 308, text: "How do you measure customer engagement online?", category: .marketing, difficulty: .intermediate, tips: ["Show analytical skills", "Give specific metrics"]),
                Question(id: 309, text: "What role does content marketing play in digital strategy?", category: .marketing, difficulty: .intermediate, tips: ["Show content knowledge", "Explain importance"]),
                Question(id: 310, text: "How do you stay updated with changes in digital platforms?", category: .marketing, difficulty: .intermediate, tips: ["Show learning mindset", "Give specific sources"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createMarketingSalesSet23() -> QuestionSet {
        return QuestionSet(
            id: 23,
            title: "Sales Skills & Client Management",
            description: "Sales processes, client relationships, and sales performance",
            category: .marketing,
            questions: [
                Question(id: 311, text: "Describe your sales process from lead generation to closing.", category: .marketing, difficulty: .intermediate, tips: ["Show systematic approach", "Explain each step"]),
                Question(id: 312, text: "How do you handle objections from potential clients?", category: .marketing, difficulty: .intermediate, tips: ["Show sales skills", "Give examples"]),
                Question(id: 313, text: "Tell me about a time you exceeded sales targets.", category: .marketing, difficulty: .intermediate, tips: ["Use STAR method", "Show results"]),
                Question(id: 314, text: "How do you approach cold calling or prospecting?", category: .marketing, difficulty: .intermediate, tips: ["Show sales skills", "Explain approach"]),
                Question(id: 315, text: "Describe a time you lost a sale—what did you learn?", category: .marketing, difficulty: .intermediate, tips: ["Use STAR method", "Show learning mindset"]),
                Question(id: 316, text: "How do you maintain long-term relationships with clients?", category: .marketing, difficulty: .intermediate, tips: ["Show relationship skills", "Give specific strategies"]),
                Question(id: 317, text: "Tell me about a time you turned a difficult client into a loyal one.", category: .marketing, difficulty: .intermediate, tips: ["Use STAR method", "Show relationship building"]),
                Question(id: 318, text: "How do you use CRM tools in your sales process?", category: .marketing, difficulty: .intermediate, tips: ["Show technical skills", "Give examples"]),
                Question(id: 319, text: "What's your approach to upselling or cross-selling?", category: .marketing, difficulty: .intermediate, tips: ["Show sales skills", "Explain strategy"]),
                Question(id: 320, text: "How do you handle rejection in sales?", category: .marketing, difficulty: .intermediate, tips: ["Show resilience", "Explain approach"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createMarketingProductSet24() -> QuestionSet {
        return QuestionSet(
            id: 24,
            title: "Product Management & Go-to-Market",
            description: "Product development, launch strategies, and market positioning",
            category: .marketing,
            questions: [
                Question(id: 321, text: "How do you prioritize features for a product roadmap?", category: .marketing, difficulty: .intermediate, tips: ["Show prioritization skills", "Explain criteria"]),
                Question(id: 322, text: "Tell me about a time you launched a new product.", category: .marketing, difficulty: .intermediate, tips: ["Use STAR method", "Show launch experience"]),
                Question(id: 323, text: "How do you gather customer feedback for product decisions?", category: .marketing, difficulty: .intermediate, tips: ["Show customer focus", "Explain methods"]),
                Question(id: 324, text: "Describe a time you managed conflicting stakeholder priorities.", category: .marketing, difficulty: .intermediate, tips: ["Use STAR method", "Show management skills"]),
                Question(id: 325, text: "How do you determine pricing strategy for a product?", category: .marketing, difficulty: .intermediate, tips: ["Show strategic thinking", "Explain factors"]),
                Question(id: 326, text: "Tell me about a time you adapted a product for a new market.", category: .marketing, difficulty: .intermediate, tips: ["Use STAR method", "Show adaptability"]),
                Question(id: 327, text: "How do you evaluate product-market fit?", category: .marketing, difficulty: .intermediate, tips: ["Show analytical skills", "Explain metrics"]),
                Question(id: 328, text: "Describe a time you collaborated with engineering and design teams.", category: .marketing, difficulty: .intermediate, tips: ["Use STAR method", "Show collaboration"]),
                Question(id: 329, text: "How do you measure the success of a product launch?", category: .marketing, difficulty: .intermediate, tips: ["Show analytical skills", "Give specific metrics"]),
                Question(id: 330, text: "What's your process for creating a go-to-market strategy?", category: .marketing, difficulty: .intermediate, tips: ["Show strategic planning", "Explain approach"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createMarketingCustomerSet25() -> QuestionSet {
        return QuestionSet(
            id: 25,
            title: "Customer Success & Retention",
            description: "Customer satisfaction, retention strategies, and customer experience",
            category: .marketing,
            questions: [
                Question(id: 331, text: "How do you define customer success?", category: .marketing, difficulty: .intermediate, tips: ["Show customer focus", "Be specific"]),
                Question(id: 332, text: "Tell me about a time you helped reduce customer churn.", category: .marketing, difficulty: .intermediate, tips: ["Use STAR method", "Show retention skills"]),
                Question(id: 333, text: "How do you measure customer satisfaction?", category: .marketing, difficulty: .intermediate, tips: ["Show analytical skills", "Give specific metrics"]),
                Question(id: 334, text: "Describe a time you turned negative feedback into a positive outcome.", category: .marketing, difficulty: .intermediate, tips: ["Use STAR method", "Show problem-solving"]),
                Question(id: 335, text: "How do you balance customer needs with business goals?", category: .marketing, difficulty: .intermediate, tips: ["Show strategic thinking", "Give examples"]),
                Question(id: 336, text: "Tell me about a time you onboarded a challenging customer.", category: .marketing, difficulty: .intermediate, tips: ["Use STAR method", "Show customer management"]),
                Question(id: 337, text: "How do you identify opportunities for customer growth?", category: .marketing, difficulty: .intermediate, tips: ["Show analytical skills", "Explain approach"]),
                Question(id: 338, text: "Describe your approach to building customer loyalty.", category: .marketing, difficulty: .intermediate, tips: ["Show relationship skills", "Give specific strategies"]),
                Question(id: 339, text: "How do you manage escalated customer issues?", category: .marketing, difficulty: .intermediate, tips: ["Show problem-solving", "Explain process"]),
                Question(id: 340, text: "Tell me about a time you worked closely with product teams to improve customer experience.", category: .marketing, difficulty: .intermediate, tips: ["Use STAR method", "Show collaboration"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createHealthcareGeneralSet26() -> QuestionSet {
        return QuestionSet(
            id: 26,
            title: "General Healthcare Professional Questions",
            description: "Fundamental healthcare knowledge, patient care, and professional development",
            category: .healthcare,
            questions: [
                Question(id: 351, text: "Why did you choose to work in healthcare?", category: .healthcare, difficulty: .beginner, tips: ["Show passion", "Be authentic"]),
                Question(id: 352, text: "Tell me about a time you handled a difficult patient interaction.", category: .healthcare, difficulty: .intermediate, tips: ["Use STAR method", "Show empathy"]),
                Question(id: 353, text: "How do you stay current with clinical guidelines and medical advancements?", category: .healthcare, difficulty: .intermediate, tips: ["Show learning mindset", "Give specific sources"]),
                Question(id: 354, text: "Describe a situation where you had to make a quick clinical decision with limited information.", category: .healthcare, difficulty: .intermediate, tips: ["Use STAR method", "Show decision-making"]),
                Question(id: 355, text: "How do you ensure patient confidentiality and data security in your daily work?", category: .healthcare, difficulty: .intermediate, tips: ["Show ethical awareness", "Explain protocols"]),
                Question(id: 356, text: "Tell me about a time you identified and reported a patient safety concern.", category: .healthcare, difficulty: .intermediate, tips: ["Use STAR method", "Show vigilance"]),
                Question(id: 357, text: "How do you approach interdisciplinary collaboration with other healthcare professionals?", category: .healthcare, difficulty: .intermediate, tips: ["Show teamwork", "Explain approach"]),
                Question(id: 358, text: "Describe a time you had to educate a patient or family about a complex medical issue.", category: .healthcare, difficulty: .intermediate, tips: ["Use STAR method", "Show communication skills"]),
                Question(id: 359, text: "How do you manage stress and prevent burnout in a high-pressure healthcare environment?", category: .healthcare, difficulty: .intermediate, tips: ["Show self-awareness", "Give specific strategies"]),
                Question(id: 360, text: "What does evidence-based practice mean to you, and how have you applied it?", category: .healthcare, difficulty: .intermediate, tips: ["Show clinical knowledge", "Give examples"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createHealthcareNursingSet27() -> QuestionSet {
        return QuestionSet(
            id: 27,
            title: "Nursing & Patient Care",
            description: "Nursing practice, patient assessment, and clinical care delivery",
            category: .healthcare,
            questions: [
                Question(id: 361, text: "Explain your process for performing a thorough patient assessment on admission.", category: .healthcare, difficulty: .intermediate, tips: ["Show systematic approach", "Explain each step"]),
                Question(id: 362, text: "Tell me about a time you caught or prevented a medication error.", category: .healthcare, difficulty: .intermediate, tips: ["Use STAR method", "Show attention to detail"]),
                Question(id: 363, text: "How do you prioritize care when multiple patients need urgent attention?", category: .healthcare, difficulty: .intermediate, tips: ["Show prioritization skills", "Explain criteria"]),
                Question(id: 364, text: "Describe a situation where you had to advocate for a patient's needs.", category: .healthcare, difficulty: .intermediate, tips: ["Use STAR method", "Show advocacy skills"]),
                Question(id: 365, text: "How do you handle end-of-life conversations with patients and families?", category: .healthcare, difficulty: .intermediate, tips: ["Show empathy", "Explain approach"]),
                Question(id: 366, text: "Tell me about a time you managed infection control during an outbreak or exposure.", category: .healthcare, difficulty: .intermediate, tips: ["Use STAR method", "Show infection control knowledge"]),
                Question(id: 367, text: "How do you delegate tasks to nursing assistants while maintaining patient safety?", category: .healthcare, difficulty: .intermediate, tips: ["Show delegation skills", "Explain oversight"]),
                Question(id: 368, text: "Describe a clinical procedure you are most confident performing and why.", category: .healthcare, difficulty: .intermediate, tips: ["Be specific", "Show confidence"]),
                Question(id: 369, text: "How do you document care to ensure accuracy and continuity between shifts?", category: .healthcare, difficulty: .intermediate, tips: ["Show documentation skills", "Explain importance"]),
                Question(id: 370, text: "Tell me about a difficult family situation you navigated—what was your approach?", category: .healthcare, difficulty: .intermediate, tips: ["Use STAR method", "Show conflict resolution"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createHealthcareResearchSet28() -> QuestionSet {
        return QuestionSet(
            id: 28,
            title: "Medical Research & Clinical Trials",
            description: "Research methodology, clinical trials, and evidence-based medicine",
            category: .healthcare,
            questions: [
                Question(id: 371, text: "Describe a research project you were involved in and your role.", category: .healthcare, difficulty: .intermediate, tips: ["Be specific", "Show research experience"]),
                Question(id: 372, text: "How do you design a study to minimize bias and confounding?", category: .healthcare, difficulty: .intermediate, tips: ["Show research methodology", "Explain techniques"]),
                Question(id: 373, text: "Explain the informed consent process and how you ensure participant understanding.", category: .healthcare, difficulty: .intermediate, tips: ["Show ethical knowledge", "Explain process"]),
                Question(id: 374, text: "Tell me about a time you handled an adverse event during a trial.", category: .healthcare, difficulty: .intermediate, tips: ["Use STAR method", "Show crisis management"]),
                Question(id: 375, text: "How do you balance scientific rigor with ethical considerations in human research?", category: .healthcare, difficulty: .intermediate, tips: ["Show ethical reasoning", "Give examples"]),
                Question(id: 376, text: "What methods do you use to ensure data integrity and reproducibility?", category: .healthcare, difficulty: .intermediate, tips: ["Show data management", "Explain protocols"]),
                Question(id: 377, text: "Describe how you choose primary and secondary endpoints for a clinical trial.", category: .healthcare, difficulty: .intermediate, tips: ["Show research design", "Explain criteria"]),
                Question(id: 378, text: "How do you manage protocol deviations or noncompliance in a study?", category: .healthcare, difficulty: .intermediate, tips: ["Show protocol management", "Explain approach"]),
                Question(id: 379, text: "Tell me about your experience with regulatory submissions (e.g., IRB, ethics committees).", category: .healthcare, difficulty: .intermediate, tips: ["Show regulatory knowledge", "Give examples"]),
                Question(id: 380, text: "How do you translate research findings into clinical practice or policy?", category: .healthcare, difficulty: .intermediate, tips: ["Show implementation skills", "Explain process"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createHealthcarePublicHealthSet29() -> QuestionSet {
        return QuestionSet(
            id: 29,
            title: "Public Health & Policy",
            description: "Public health programs, policy development, and community health",
            category: .healthcare,
            questions: [
                Question(id: 381, text: "Describe a public health program you've worked on and its impact.", category: .healthcare, difficulty: .intermediate, tips: ["Use STAR method", "Show program impact"]),
                Question(id: 382, text: "How would you design a vaccination campaign for a hesitant community?", category: .healthcare, difficulty: .intermediate, tips: ["Show strategic thinking", "Explain approach"]),
                Question(id: 383, text: "Tell me about a time you used surveillance data to inform interventions.", category: .healthcare, difficulty: .intermediate, tips: ["Use STAR method", "Show data-driven approach"]),
                Question(id: 384, text: "How do you address health disparities in program planning?", category: .healthcare, difficulty: .intermediate, tips: ["Show equity awareness", "Explain strategies"]),
                Question(id: 385, text: "Describe your approach to risk communication during a public health emergency.", category: .healthcare, difficulty: .intermediate, tips: ["Show communication skills", "Explain methodology"]),
                Question(id: 386, text: "How do social determinants of health influence your policy recommendations?", category: .healthcare, difficulty: .intermediate, tips: ["Show policy knowledge", "Give examples"]),
                Question(id: 387, text: "Tell me about a time you coordinated with multiple agencies or stakeholders.", category: .healthcare, difficulty: .intermediate, tips: ["Use STAR method", "Show collaboration"]),
                Question(id: 388, text: "How do you evaluate the effectiveness of a public health intervention?", category: .healthcare, difficulty: .intermediate, tips: ["Show evaluation skills", "Explain metrics"]),
                Question(id: 389, text: "Describe a situation where you had to balance public health benefits with individual rights.", category: .healthcare, difficulty: .intermediate, tips: ["Use STAR method", "Show ethical reasoning"]),
                Question(id: 390, text: "How would you prepare a community for a predicted infectious disease outbreak?", category: .healthcare, difficulty: .intermediate, tips: ["Show preparedness planning", "Explain approach"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    private func createHealthcareAdminSet30() -> QuestionSet {
        return QuestionSet(
            id: 30,
            title: "Healthcare Administration & Management",
            description: "Healthcare operations, quality improvement, and administrative leadership",
            category: .healthcare,
            questions: [
                Question(id: 391, text: "Tell me about your experience managing budgets and financial resources in healthcare.", category: .healthcare, difficulty: .intermediate, tips: ["Show financial management", "Give examples"]),
                Question(id: 392, text: "How do you approach staffing and workforce planning for a clinical unit?", category: .healthcare, difficulty: .intermediate, tips: ["Show workforce planning", "Explain approach"]),
                Question(id: 393, text: "Describe a quality improvement project you led and its outcomes.", category: .healthcare, difficulty: .intermediate, tips: ["Use STAR method", "Show leadership"]),
                Question(id: 394, text: "How do you handle resistance to change when implementing new systems (e.g., EMR)?", category: .healthcare, difficulty: .intermediate, tips: ["Show change management", "Explain strategies"]),
                Question(id: 395, text: "Tell me about a time you improved patient satisfaction scores—what did you change?", category: .healthcare, difficulty: .intermediate, tips: ["Use STAR method", "Show improvement focus"]),
                Question(id: 396, text: "How do you ensure regulatory compliance and accreditation readiness?", category: .healthcare, difficulty: .intermediate, tips: ["Show compliance knowledge", "Explain processes"]),
                Question(id: 397, text: "Describe your process for managing a critical incident or operational crisis.", category: .healthcare, difficulty: .intermediate, tips: ["Show crisis management", "Explain approach"]),
                Question(id: 398, text: "How do you measure and improve clinical performance and key KPIs?", category: .healthcare, difficulty: .intermediate, tips: ["Show performance management", "Give specific metrics"]),
                Question(id: 399, text: "Tell me about your experience with vendor selection or contract negotiation for healthcare services.", category: .healthcare, difficulty: .intermediate, tips: ["Show procurement skills", "Give examples"]),
                Question(id: 400, text: "How do you balance cost containment with maintaining quality of care?", category: .healthcare, difficulty: .intermediate, tips: ["Show strategic thinking", "Explain approach"])
            ],
            isPremium: false,
            releaseDate: nil
        )
    }
    
    // Get Question Sets by Category
    func getQuestionSets(for category: QuestionCategory) -> [QuestionSet] {
        return allQuestionSets.filter { $0.category == category }
    }
    
}
