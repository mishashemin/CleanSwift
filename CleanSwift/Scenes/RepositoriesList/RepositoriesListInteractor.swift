//
//  RepositoriesListInteractor.swift
//  CleanSwift
//
//  Created by m.shemin on 24.06.2021.

import UIKit

protocol RepositoriesListBusinessLogic {
    func fetchRepositories(request: RepositoriesList.FetchRepositories.Request)
    func showRepository(by id: Int)
}

protocol RepositoriesListDataStore {}

class RepositoriesListInteractor {
    var presenter: RepositoriesListPresentationLogic?
    var worker: RepositoriesListWorker?
}

extension RepositoriesListInteractor: RepositoriesListBusinessLogic {
    func showRepository(by id: Int) {
        presenter?.showRepository(by: id)
    }
    
    func fetchRepositories(request: RepositoriesList.FetchRepositories.Request) {
        worker = RepositoriesListWorker()
        worker?.doSomeWork()
        
        let repositoriesResponse = RepositoriesList.FetchRepositoriesResponse(
            count: 2,
            items: [
                .init(name: "name1", description: "description1", language: "Swift", id: 1),
                .init(name: "name2", description: "description2", language: "Swift", id: 1)
            ]
        )
        
        let response = RepositoriesList.FetchRepositories.Response.init(repositoriesResponse: repositoriesResponse)
        presenter?.displayRepositories(response: response)
    }
}

extension RepositoriesListInteractor: RepositoriesListDataStore {}
