import UIKit
import DictionaryAPI

protocol HomeViewControllerProtocol: AnyObject {
    func showWordDefinition(_ wordData: WordElement)
    func showError(_ error: String)
}

class HomeViewController: UIViewController {
    var presenter: HomePresenterProtocol?
    var historyPresenter: HistoryCellPresenterProtocol = HistoryCellPresenter()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        return searchBar
    }()
    
    private let recentLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent search"
        label.numberOfLines = 1
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let historyTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private var searchButtonBottomConstraint: NSLayoutConstraint!
    private var searchButtonBottomConstraintWithKeyboard: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        searchBar.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.register(UINib(nibName: "HistoryTableCell", bundle: nil), forCellReuseIdentifier: "HistoryTableCell")
        
        setupHomeUI()
        historyPresenter.loadSearchHistory()
    }
    
    private func setupHomeUI() {
        view.addSubview(searchBar)
        view.addSubview(historyTableView)
        view.addSubview(searchButton)
        view.addSubview(recentLabel)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        historyTableView.translatesAutoresizingMaskIntoConstraints = false
        recentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        searchButtonBottomConstraint = searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            recentLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            recentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            recentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            historyTableView.topAnchor.constraint(equalTo: recentLabel.bottomAnchor, constant: 8),
            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            historyTableView.bottomAnchor.constraint(equalTo: searchButton.topAnchor, constant: -20),
            
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 60),
            searchButtonBottomConstraint
        ])
    }
    
    @objc func searchButtonTapped() {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        let lowercasedText = searchText.lowercased()
        addToSearchHistory(lowercasedText)
        historyTableView.reloadData()
        
        presenter?.searchWord(lowercasedText) { [weak self] wordElement in
            self?.presenter?.navigateToDetail(with: lowercasedText, wordElement: wordElement)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let keyboardHeight = self.view.convert(keyboardFrame, from: nil).height
        
        searchButtonBottomConstraint.isActive = false
        searchButtonBottomConstraintWithKeyboard = searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -keyboardHeight)
        NSLayoutConstraint.activate([searchButtonBottomConstraintWithKeyboard])
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let searchButtonBottomConstraintWithKeyboard = searchButtonBottomConstraintWithKeyboard else {
            // If searchButtonBottomConstraintWithKeyboard is nil, return early to avoid the fatal error
            return
        }

        searchButtonBottomConstraintWithKeyboard.isActive = false
        searchButtonBottomConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func addToSearchHistory(_ searchText: String) {
        historyPresenter.addRecentSearch(searchText)
    }
    
    private func clearSearchHistory() {
        historyPresenter.clearSearchHistory()
        historyTableView.reloadData()
    }
}

extension HomeViewController: HomeViewControllerProtocol {
    func showWordDefinition(_ wordData: WordElement) {
        // Show word definition
    }
    
    func showError(_ error: String) {
        let errorMessage = "Such a word may not exist or you can try again by checking your internet connection."
        let alertController = UIAlertController(title: "This word could not be fetched", message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyPresenter.numberOfRecentSearches()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableCell", for: indexPath) as! HistoryTableCell
        let recentSearch = historyPresenter.recentSearch(at: indexPath.row)
        historyPresenter.configureCell(cell, with: recentSearch)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recentSearch = historyPresenter.recentSearch(at: indexPath.row)
        searchBar.text = recentSearch
        searchButtonTapped()
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchButtonTapped()
    }
}
