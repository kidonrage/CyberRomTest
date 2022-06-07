import UIKit

protocol SearchResultsPresentationLogic {
    func presentFoundQuestions(response: SearchResults.SearchForQuestions.Response)
}

class SearchResultsPresenter: SearchResultsPresentationLogic {
    weak var viewController: SearchResultsDisplayLogic?
    
    // MARK: Do something
    
    func presentFoundQuestions(response: SearchResults.SearchForQuestions.Response) {
        let viewModel = SearchResults.SearchForQuestions.ViewModel(foundQuestions: response.foundQuestions)
        DispatchQueue.main.async {
            self.viewController?.displaySearchResults(viewModel: viewModel)
        }
    }
}
