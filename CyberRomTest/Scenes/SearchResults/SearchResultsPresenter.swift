import UIKit

protocol SearchResultsPresentationLogic {
    
    func presentFoundQuestions(response: SearchResults.SearchForQuestions.Response)
}

final class SearchResultsPresenter: SearchResultsPresentationLogic {
    
    // MARK: Public Properties
    weak var viewController: SearchResultsDisplayLogic?
    
    // MARK: - Private Properties
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY HH:mm"
        return formatter
    }()
    
    // MARK: Public Methods
    func presentFoundQuestions(response: SearchResults.SearchForQuestions.Response) {
        let foundQuestions = response.foundQuestions?.map { question in
            return ShallowQuestionViewModel(
                title: question.title,
                ownerNickname: question.owner?.displayName ?? "Unknown",
                ownerAvatarURL: URL(string: question.owner?.profileImage ?? ""),
                answerCount: String(question.answerCount) + " Answer",
                creationDate: dateFormatter.string(
                    from: Date(
                        timeIntervalSince1970: TimeInterval(question.creationDate)
                    )
                )
            )
        } ?? []
        let viewModel = SearchResults.SearchForQuestions.ViewModel(foundQuestions: foundQuestions)
        DispatchQueue.main.async {
            self.viewController?.displaySearchResults(viewModel: viewModel)
        }
    }
}
