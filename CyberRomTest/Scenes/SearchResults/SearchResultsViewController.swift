import UIKit

protocol SearchResultsDisplayLogic: AnyObject {
    
    func displaySearchResults(viewModel: SearchResults.SearchForQuestions.ViewModel)
}

class SearchResultsViewController: UIViewController, SearchResultsDisplayLogic {
    
    // MARK: - @IBOutlets
    @IBOutlet private(set) weak var searchBar: UISearchBar!
    @IBOutlet private(set) weak var searchResultsTableView: UITableView!
    @IBOutlet private(set) weak var emptyDataView: EmptyDataView!
    
    // MARK: - Properties
    var interactor: SearchResultsBusinessLogic?
    var questionsToDisplay: [Question] = []
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupScene()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupScene()
    }
    
    // MARK: VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        searchForQuestions()
    }
    
    // MARK: Public
    
    func searchForQuestions() {
        let request = SearchResults.SearchForQuestions.Request(searchQuery: searchBar.text)
        interactor?.searchForQuestions(request: request)
    }
    
    func displaySearchResults(viewModel: SearchResults.SearchForQuestions.ViewModel) {
        questionsToDisplay = viewModel.foundQuestions ?? []
        searchResultsTableView.reloadData()
        searchResultsTableView.isHidden = !viewModel.isResultsVisible
        emptyDataView.isHidden = viewModel.isResultsVisible
    }
    
    // MARK: Private
    
    private func setupScene() {
        let viewController = self
        let interactor = SearchResultsInteractor()
        let presenter = SearchResultsPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    private func setupUI() {
        setupTable()
        setupSearchBar()
    }
    
    private func setupTable() {
        searchResultsTableView.register(UINib(nibName: QuestionTableViewCell.reuseId, bundle: nil), forCellReuseIdentifier: QuestionTableViewCell.reuseId)
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        searchResultsTableView.isHidden = false
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension SearchResultsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTableViewCell.reuseId) as? QuestionTableViewCell
        else {
            return UITableViewCell()
        }
        
        let item = questionsToDisplay[indexPath.row]
        cell.configureUI(with: .init(
            questionTitle: item.title,
            authorImagePath: item.owner?.profileImage,
            authorNickname: item.owner?.displayName ?? "Unknown",
            date: "\(item.creationDate)",
            answersCount: "\(item.answerCount)"
        ))
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension SearchResultsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchForQuestions()
    }
}
