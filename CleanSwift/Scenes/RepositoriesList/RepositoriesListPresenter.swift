//
//  RepositoriesListPresenter.swift
//  CleanSwift
//
//  Created by m.shemin on 24.06.2021.

import UIKit

protocol RepositoriesListPresentationLogic {
    func displayRepositories(response: RepositoriesList.FetchRepositories.Response)
    func showRepository(by id: Int)
}

class RepositoriesListPresenter {
    typealias ViewModel = RepositoriesList.FetchRepositories.ViewModel
    typealias Response = RepositoriesList.FetchRepositories.Response
    weak var viewController: RepositoriesListDisplayLogic?
}
 
extension RepositoriesListPresenter: RepositoriesListPresentationLogic {
    func displayRepositories(response: Response) {
        let repositories = response.repositoriesResponse.items
            .map({ rawRepository in
                return ViewModel.Repository.init(name: rawRepository.name,
                                                 description: rawRepository.description,
                                                 language: rawRepository.language,
                                                 id: rawRepository.id)
            })
        let viewModel = ViewModel(repositories: repositories)
        viewController?.updateRepositories(viewModel: viewModel)
    }
    
    func showRepository(by id: Int) {
        viewController?.showRepository(by: id)
    }
}
