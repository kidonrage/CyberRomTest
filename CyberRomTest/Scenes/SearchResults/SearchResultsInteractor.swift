import UIKit

protocol SearchResultsBusinessLogic {
    
    func searchForQuestions(request: SearchResults.SearchForQuestions.Request)
}

protocol SearchResultsDataStore {
    //var name: String { get set }
}

class SearchResultsInteractor: SearchResultsBusinessLogic, SearchResultsDataStore {
    
    var presenter: SearchResultsPresentationLogic?
    var worker = SearchResultsWorker()
    
    private var searchThrottlingTimer: Timer?
    
    // MARK: Do something
    
    func searchForQuestions(request: SearchResults.SearchForQuestions.Request)
    {
        searchThrottlingTimer?.invalidate()
        
        searchThrottlingTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { [weak self] _ in
            self?.performSearch(searchQuery: request.searchQuery)
        })
    }
    
    private func performSearch(searchQuery: String?) {
        worker.searchForQuestions(byQuery: searchQuery, completion: { [weak self] foundQuestions, error in
            let response = SearchResults.SearchForQuestions.Response(foundQuestions: foundQuestions)
            self?.presenter?.presentFoundQuestions(response: response)
            
            if let error = error {
//                self?.presenter?.presentError(error: error)
            }
        })
    }
}
