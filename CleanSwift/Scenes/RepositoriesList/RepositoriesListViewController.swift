//
//  RepositoriesListViewController.swift
//  CleanSwift
//
//  Created by m.shemin on 24.06.2021.

import UIKit

protocol RepositoriesListDisplayLogic: AnyObject {
    func updateRepositories(viewModel: RepositoriesList.FetchRepositories.ViewModel)
    func showRepository(viewModel: RepositoriesList.SelectRepository.ViewModel)
    func update(status: RepositoriesList.FetchRepositoriesStatus)
}

class RepositoriesListViewController: UIViewController {
    
    var interactor: RepositoriesListBusinessLogic?
    var router: (RepositoriesListRoutingLogic & RepositoriesListDataPassing)?
    
    private var repositories: [RepositoriesList.FetchRepositories.ViewModel.Repository] = []
    
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
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RepositoryTableViewCell.self, forCellReuseIdentifier: RepositoryTableViewCell.reuseIdentifier)
        self.view.insertSubview(tableView, belowSubview: statusView)
        return tableView
    }()
    
    private lazy var statusView: FetchRepositoriesStatusView = {
        let view = FetchRepositoriesStatusView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        self.view.addSubview(view)
        return view
    }()
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
        setupUI()
        setupConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        let tapOnStatusView = UITapGestureRecognizer(target: self, action: #selector(tapOnStatusView))
        statusView.addGestureRecognizer(tapOnStatusView)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
        [tableView, statusView].forEach { subView in
            NSLayoutConstraint.activate([
                searchBar.bottomAnchor.constraint(equalTo: subView.topAnchor, constant: -10),
                subView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                subView.rightAnchor.constraint(equalTo: view.rightAnchor),
                subView.leftAnchor.constraint(equalTo: view.leftAnchor)
            ])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Репозитории"
        self.navigationItem.title = "Репозитории"
        
        let request = RepositoriesList.FetchRepositories.Request(searchQuery: searchBar.text ?? "")
        interactor?.fetchRepositories(request: request)
    }
    
    @objc func tapOnStatusView() {
        searchBar.resignFirstResponder()
    }
}

extension RepositoriesListViewController: RepositoriesListDisplayLogic {
    func update(status: RepositoriesList.FetchRepositoriesStatus) {
        DispatchQueue.main.async {
            self.statusView.update(status: status)
        }
    }
    
    func showRepository(viewModel: RepositoriesList.SelectRepository.ViewModel) {
        router?.routeToRepository(path: viewModel.repositoryPath)
    }
    
    func updateRepositories(viewModel: RepositoriesList.FetchRepositories.ViewModel) {
        repositories = viewModel.repositories
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.repositories.count > 0 {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }
    }
}

extension RepositoriesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = RepositoriesList.SelectRepository.Request(index: indexPath.row)
        interactor?.showRepository(request: request)
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
                                                                mainLanguage: repository.language))
        return cell
    }
}

extension RepositoriesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let request = RepositoriesList.FetchRepositories.Request(searchQuery: searchText)
        interactor?.fetchRepositories(request: request)
    }
}
