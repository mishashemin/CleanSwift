//
//  RepositoriesListInteractor.swift
//  CleanSwift
//
//  Created by m.shemin on 24.06.2021.

import UIKit

protocol RepositoriesListBusinessLogic {
    func fetchRepositories(request: RepositoriesList.FetchRepositories.Request)
    func showRepository(request: RepositoriesList.SelectRepository.Request)
}

protocol RepositoriesListDataStore {}

class RepositoriesListInteractor {
    var presenter: RepositoriesListPresentationLogic?
    var worker: RepositoriesWorker = RepositoriesWorker(repositoriesStore: RepositoriesApiService.shared)
    
    private weak var lastTask: CancelableTask?
}

extension RepositoriesListInteractor: RepositoriesListBusinessLogic {
    func showRepository(request: RepositoriesList.SelectRepository.Request) {
        let response = RepositoriesList.SelectRepository.Response(repositoryId: request.repositoryId)
        presenter?.showRepository(response: response)
    }
    
    func fetchRepositories(request: RepositoriesList.FetchRepositories.Request) {
        if let lastTask = lastTask {
            lastTask.cancel()
        }
        let searchQuery = request.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if searchQuery.isEmpty {
            presenter?.setFetchStatus(.emptyRequest)
        } else {
            lastTask = worker.featchRepositories(
                searchQuery: request.searchQuery,
                startHadler: { [weak presenter] in
                    presenter?.setFetchStatus(.loading)
                },
                errorHandler: { [weak presenter] error in
                    presenter?.setFetchStatus(.error(error: error))
                },
                completionHandler: { [weak presenter] value in
                    if value.count == 0 {
                        presenter?.setFetchStatus(.emptyResponse)
                    } else {
                        let response = RepositoriesList.FetchRepositories.Response.init(repositoriesResponse: value)
                        presenter?.setFetchStatus(.success)
                        presenter?.displayRepositories(response: response)
                    }
                }
            )
        }
    }
}

extension RepositoriesListInteractor: RepositoriesListDataStore {}
