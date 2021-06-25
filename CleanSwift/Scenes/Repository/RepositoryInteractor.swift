//
//  RepositoryInteractor.swift
//  CleanSwift
//
//  Created by m.shemin on 25.06.2021.

import UIKit

protocol RepositoryBusinessLogic {
    func viewWillAppear(request: Repository.ViewWillAppear.Request)
    func tapOnButton(type: Repository.ShowPage.PageType)
}

protocol RepositoryDataStore: AnyObject {
    var path: String { get set }
}

class RepositoryInteractor: RepositoryDataStore {
    var presenter: RepositoryPresentationLogic?
    var worker: RepositoriesWorker = RepositoriesWorker(repositoriesStore: RepositoriesApiService.shared)
    var path: String = ""
    
    private var ownerUrl: URL?
    private var repositoryUrl: URL?
}

extension RepositoryInteractor: RepositoryBusinessLogic {
    func tapOnButton(type: Repository.ShowPage.PageType) {
        switch type {
        case .owner:
            presenter?.displayPage(response: Repository.ShowPage.Response(url: ownerUrl))
        case .repository:
            presenter?.displayPage(response: Repository.ShowPage.Response(url: repositoryUrl))
        }
    }
    
    func viewWillAppear(request: Repository.ViewWillAppear.Request) {
        worker.featchRepository(
            path: path,
            errorHandler: { _ in
                
            } ,
            completionHandler: { [weak presenter, weak self] response in
                self?.ownerUrl = URL(string: response.owner.url)
                self?.repositoryUrl = URL(string: response.url)
                presenter?.displayRepository(response: Repository.ViewWillAppear.Response(repositoryResponse: response))
            }
        )
    }
}
