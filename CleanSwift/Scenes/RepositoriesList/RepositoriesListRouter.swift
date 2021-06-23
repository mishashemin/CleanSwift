//
//  RepositoriesListRouter.swift
//  CleanSwift
//
//  Created by m.shemin on 24.06.2021.

import UIKit

protocol RepositoriesListRoutingLogic {
    func routeToRepository(id: Int)
}

protocol RepositoriesListDataPassing {
  var dataStore: RepositoriesListDataStore? { get }
}

class RepositoriesListRouter: RepositoriesListDataPassing {
  weak var viewController: RepositoriesListViewController?
  var dataStore: RepositoriesListDataStore?
}

extension RepositoriesListRouter: RepositoriesListRoutingLogic {
    func routeToRepository(id: Int) {
        
    }
}
