import UIKit

protocol SearchResultsBusinessLogic {
    
    func searchForQuestions(request: SearchResults.SearchForQuestions.Request)
    func handleGoingToQuestionDetails(questionURL: URL?)
}

protocol SearchResultsDataStore {}

class SearchResultsInteractor: SearchResultsBusinessLogic, SearchResultsDataStore {
    
    // MARK: - Public Properties
    var presenter: SearchResultsPresentationLogic?
    var worker = SearchResultsWorker()
    
    // MARK: - Private Properties
    private var searchThrottlingTimer: Timer?
    
    // MARK: - Public Methods
    func searchForQuestions(request: SearchResults.SearchForQuestions.Request)
    {
        searchThrottlingTimer?.invalidate()
        
        searchThrottlingTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { [weak self] _ in
            self?.performSearch(searchQuery: request.searchQuery)
        })
    }
    
    func handleGoingToQuestionDetails(questionURL: URL?) {
        if let url = questionURL {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: - Private Methods
    private func performSearch(searchQuery: String?) {
        worker.searchForQuestions(byQuery: searchQuery, completion: { [weak self] searchResponse, error in
            let response = SearchResults.SearchForQuestions.Response(foundQuestions: searchResponse?.items)
            self?.presenter?.presentFoundQuestions(response: response)
            
            // Можно добавить обработку ошибок но это за рамками тестового :)
            //            if let error = error {
            //                self?.presenter?.presentError(error: error)
            //            }
        })
    }
}
