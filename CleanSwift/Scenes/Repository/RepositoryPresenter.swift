//
//  RepositoryPresenter.swift
//  CleanSwift
//
//  Created by m.shemin on 25.06.2021.

import UIKit

protocol RepositoryPresentationLogic: AnyObject {
    func displayRepository(response: Repository.ViewWillAppear.Response)
    func displayPage(response: Repository.ShowPage.Response)
}

class RepositoryPresenter {
    weak var viewController: RepositoryDisplayLogic?
}

extension RepositoryPresenter: RepositoryPresentationLogic {
    func displayPage(response: Repository.ShowPage.Response) {
        viewController?.showPage(viewModel: Repository.ShowPage.ViewModel(url: response.url))
    }
    
    func displayRepository(response: Repository.ViewWillAppear.Response) {
        
        let ownerName = response.repositoryResponse.owner.name
        let repositoryDescription = response.repositoryResponse.description
        let starCount = "\(response.repositoryResponse.starsCount)"
        let forksCount = "\(response.repositoryResponse.forksCount)"
        let watchersCount = "\(response.repositoryResponse.subscribersCount)"
        
        let viewModel = Repository.ViewWillAppear.ViewModel(ownerName: ownerName,
                                                            repositoryDescription: repositoryDescription,
                                                            starCount: starCount,
                                                            forksCount: forksCount,
                                                            watchersCount: watchersCount)
        viewController?.update(viewModel: viewModel)
    }
}
