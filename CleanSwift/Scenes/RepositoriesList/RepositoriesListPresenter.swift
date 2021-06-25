//
//  RepositoriesListPresenter.swift
//  CleanSwift
//
//  Created by m.shemin on 24.06.2021.

import UIKit

protocol RepositoriesListPresentationLogic: AnyObject {
    func displayRepositories(response: RepositoriesList.FetchRepositories.Response)
    func showRepository(response: RepositoriesList.SelectRepository.Response)
    func setFetchStatus(_ status: RepositoriesList.FetchRepositoriesStatus)
}

class RepositoriesListPresenter {
    weak var viewController: RepositoriesListDisplayLogic?
}
 
extension RepositoriesListPresenter: RepositoriesListPresentationLogic {
    func setFetchStatus(_ status: RepositoriesList.FetchRepositoriesStatus) {
        viewController?.update(status: status)
    }
    
    func displayRepositories(response: RepositoriesList.FetchRepositories.Response) {
        let repositories = response.repositoriesResponse.items
            .map({ rawRepository in
                return RepositoriesList.FetchRepositories.ViewModel.Repository.init(
                    name: rawRepository.name,
                    description: rawRepository.description ?? "Описание отсутсвует",
                    language: rawRepository.language ?? "-",
                    id: rawRepository.id
                )
            })
        let viewModel = RepositoriesList.FetchRepositories.ViewModel(repositories: repositories)
        viewController?.updateRepositories(viewModel: viewModel)
    }
    
    func showRepository(response: RepositoriesList.SelectRepository.Response) {
        let viewModel = RepositoriesList.SelectRepository.ViewModel(repositoryId: response.repositoryId)
        viewController?.showRepository(viewModel: viewModel)
    }
}
