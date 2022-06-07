import UIKit

enum SearchResults {
    
    // MARK: Use cases
    
    enum SearchForQuestions {
        
        struct Request {
            let searchQuery: String?
        }
        
        struct Response {
            let foundQuestions: [SearchQuestionsResponse.Item]?
        }
        
        struct ViewModel {
            let foundQuestions: [ShallowQuestionViewModel]?
            var isResultsVisible: Bool {
                return (foundQuestions?.count ?? 0) > 0
            }
        }
    }
}
