import UIKit

enum SearchResults {
    
    // MARK: Use cases
    
    enum SearchForQuestions {
        
        struct Request {
            let searchQuery: String?
        }
        
        struct Response {
            let foundQuestions: [Question]?
        }
        
        struct ViewModel {
            let foundQuestions: [Question]?
            var isResultsVisible: Bool {
                return (foundQuestions?.count ?? 0) > 0
            }
        }
    }
}
