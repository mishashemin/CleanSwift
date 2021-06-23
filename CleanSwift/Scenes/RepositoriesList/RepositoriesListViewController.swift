//
//  RepositoriesListViewController.swift
//  CleanSwift
//
//  Created by m.shemin on 24.06.2021.

import UIKit

protocol RepositoriesListDisplayLogic: AnyObject {
    func updateRepositories(viewModel: RepositoriesListViewController.ViewModel)
    func showRepository(by id: Int)
}

class RepositoriesListViewController: UIViewController {
    typealias ViewModel = RepositoriesList.FetchRepositories.ViewModel
    typealias Request = RepositoriesList.FetchRepositories.Request
    
    var interactor: RepositoriesListBusinessLogic?
    var router: (RepositoriesListRoutingLogic & RepositoriesListDataPassing)?
    
    private var repositories: [ViewModel.Repository] = []
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(searchBar)
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(RepositoryTableViewCell.self, forCellReuseIdentifier: RepositoryTableViewCell.reuseIdentifier)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = RepositoriesListInteractor()
        let presenter = RepositoriesListPresenter()
        let router = RepositoriesListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
        searchBar.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -10).isActive = true
        
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
    }
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RepositoriesListViewController: RepositoriesListDisplayLogic {
    func showRepository(by id: Int) {
    }
    
    func updateRepositories(viewModel: ViewModel) {
        repositories = viewModel.repositories
        tableView.reloadData()
    }
}

extension RepositoriesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RepositoryTableViewCell else {
            return
        }
        interactor?.showRepository(by: cell.id)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension RepositoriesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.reuseIdentifier, for: indexPath) as? RepositoryTableViewCell else {
            return UITableViewCell()
        }
        let repository = repositories[indexPath.row]
        cell.configure(with: RepositoryTableViewCell.Repository(name: repository.name,
                                                                description: repository.description,
                                                                mainLanguage: repository.language,
                                                                id: repository.id))
        return cell
    }
}

extension RepositoriesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let request = Request(searchQuery: searchText)
        interactor?.fetchRepositories(request: request)
    }
}
