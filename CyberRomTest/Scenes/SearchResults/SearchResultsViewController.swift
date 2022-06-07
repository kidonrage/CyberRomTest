import UIKit

protocol SearchResultsDisplayLogic: AnyObject {
    
    func displaySearchResults(viewModel: SearchResults.SearchForQuestions.ViewModel)
}

final class SearchResultsViewController: UIViewController, SearchResultsDisplayLogic {
    
    // MARK: - IBOutlets
    @IBOutlet private(set) weak var searchBar: UISearchBar!
    @IBOutlet private(set) weak var searchResultsTableView: UITableView!
    @IBOutlet private(set) weak var emptyDataView: EmptyDataView!
    
    // MARK: - Public Properties
    var interactor: SearchResultsBusinessLogic?
    var questionsToDisplay: [ShallowQuestionViewModel] = []
    
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
    
    // MARK: Public methods
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
    
    // MARK: Private methods
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
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
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
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            searchResultsTableView.contentInset = .zero
        } else {
            searchResultsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        searchResultsTableView.scrollIndicatorInsets = searchResultsTableView.contentInset
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
        
        let question = questionsToDisplay[indexPath.row]
        cell.configureUI(with: .init(
            questionTitle: question.title,
            authorImageURL: question.ownerAvatarURL,
            authorNickname: question.ownerNickname,
            date: question.creationDate,
            answersCount: question.answerCount
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
