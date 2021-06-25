//
//  RepositoryViewController.swift
//  CleanSwift
//
//  Created by m.shemin on 25.06.2021.

import UIKit

protocol RepositoryDisplayLogic: AnyObject {
    func update(viewModel: Repository.ViewWillAppear.ViewModel)
    func showPage(viewModel: Repository.ShowPage.ViewModel)
}

class RepositoryViewController: UIViewController {
    var interactor: RepositoryBusinessLogic?
    var router: (RepositoryRoutingLogic & RepositoryDataPassing)?
    
    lazy var ownerNameLabel: UILabel = buildBasicInfoLabel()
    lazy var repositoryDescriptionLabel: UILabel = buildBasicInfoLabel()
    
    lazy var ownerStackView: UIStackView = buildBasicInfoStackView(text: "Владелец: ", infoLabel: ownerNameLabel)
    lazy var repositoryStackView: UIStackView = buildBasicInfoStackView(text: "Описание: ", infoLabel: repositoryDescriptionLabel)
    
    lazy var starLabel: UILabel = buildAdditionalInfoLabel()
    lazy var forkLabel: UILabel = buildAdditionalInfoLabel()
    lazy var watchersLabel: UILabel = buildAdditionalInfoLabel()
    
    lazy var starStackView: UIStackView = buildAdditionalInfoStackView(text: "Звезды: ", infoLabel: starLabel)
    lazy var forkStackView: UIStackView = buildAdditionalInfoStackView(text: "Форки: ", infoLabel: forkLabel)
    lazy var watchersStackView: UIStackView = buildAdditionalInfoStackView(text: "Наблюдатели: ", infoLabel: watchersLabel)
    
    lazy var additionalInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [starStackView, forkStackView, watchersStackView])
        stackView.spacing = 5
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var allInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ownerStackView, additionalInfoStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        return stackView
    }()
    
    lazy var ownerButton: UIButton = buildButton(label: "Страница владельца")
    lazy var repositoryButton: UIButton = buildButton(label: "Страница репозитория")
    
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
        let interactor = RepositoryInteractor()
        let presenter = RepositoryPresenter()
        let router = RepositoryRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private func setupConstraint() {
        
        view.addSubview(allInfoStackView)
        NSLayoutConstraint.activate([
            allInfoStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            allInfoStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24),
            allInfoStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24)
        ])
        
        self.view.addSubview(repositoryStackView)
        NSLayoutConstraint.activate([
            repositoryStackView.topAnchor.constraint(equalTo: allInfoStackView.bottomAnchor, constant: 20),
            repositoryStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24),
            repositoryStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24)
        ])
        
        self.view.addSubview(ownerButton)
        NSLayoutConstraint.activate([
            ownerButton.topAnchor.constraint(equalTo: repositoryStackView.bottomAnchor, constant: 30),
            ownerButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24),
            ownerButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24)
        ])
        
        self.view.addSubview(repositoryButton)
        NSLayoutConstraint.activate([
            repositoryButton.topAnchor.constraint(equalTo: ownerButton.bottomAnchor, constant: 10),
            repositoryButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24),
            repositoryButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24)
        ])
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        
        ownerButton.addTarget(self, action: #selector(tapOnOwnerButton), for: .touchUpInside)
        repositoryButton.addTarget(self, action: #selector(tapOnRepositoryButton), for: .touchUpInside)
    }
    
    // MARK: View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.viewWillAppear(request: Repository.ViewWillAppear.Request())
    }
    
    @objc func tapOnOwnerButton() {
        interactor?.tapOnButton(type: .owner)
    }
    
    @objc func tapOnRepositoryButton() {
        interactor?.tapOnButton(type: .repository)
    }
}

extension RepositoryViewController: RepositoryDisplayLogic {
    func showPage(viewModel: Repository.ShowPage.ViewModel) {
        router?.openUrl(url: viewModel.url)
    }
    
    func update(viewModel: Repository.ViewWillAppear.ViewModel) {
        DispatchQueue.main.async {
            self.ownerNameLabel.text = viewModel.ownerName
            self.repositoryDescriptionLabel.text = viewModel.repositoryDescription
            
            self.starLabel.text = viewModel.starCount
            self.forkLabel.text = viewModel.forksCount
            self.watchersLabel.text = viewModel.watchersCount
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}

//MARK: - private builder
extension RepositoryViewController {
    private func buildBasicInfoLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 20.0)
        label.textAlignment = .center
        label.numberOfLines = 5
        label.setContentHuggingPriority(.init(rawValue: 250), for: .vertical)
        return label
    }
    
    private func buildBasicInfoStackView(text: String, infoLabel: UILabel) -> UIStackView {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.textAlignment = .center
        label.text = text
        label.setContentHuggingPriority(.init(rawValue: 251), for: .vertical)
        let stackView = UIStackView(arrangedSubviews: [label, infoLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }
    
    private func buildAdditionalInfoLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 19.0)
        label.textAlignment = .center
        return label
    }
    
    private func buildAdditionalInfoStackView(text: String, infoLabel: UILabel) -> UIStackView {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.text = text
        label.textAlignment = .center
        let stackView = UIStackView(arrangedSubviews: [label, infoLabel])
        stackView.axis = .vertical
        stackView.layer.cornerRadius = 4
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.gray.cgColor
        return stackView
    }
    
    private func buildButton(label: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(label, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }
}
