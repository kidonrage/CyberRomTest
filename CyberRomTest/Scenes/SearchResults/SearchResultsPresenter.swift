import UIKit

protocol SearchResultsPresentationLogic {
    
    func presentFoundQuestions(response: SearchResults.SearchForQuestions.Response)
}

final class SearchResultsPresenter: SearchResultsPresentationLogic {
    
    // MARK: Public Properties
    weak var viewController: SearchResultsDisplayLogic?
    
    // MARK: Public Methods
    func presentFoundQuestions(response: SearchResults.SearchForQuestions.Response) {
        let viewModel = SearchResults.SearchForQuestions.ViewModel(foundQuestions: response.foundQuestions)
        DispatchQueue.main.async {
            self.viewController?.displaySearchResults(viewModel: viewModel)
        }
    }
}
