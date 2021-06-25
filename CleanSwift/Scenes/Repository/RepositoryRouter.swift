//
//  RepositoryRouter.swift
//  CleanSwift
//
//  Created by m.shemin on 25.06.2021.

import UIKit

protocol RepositoryRoutingLogic: AnyObject {
    func openUrl(url: URL?)
}

protocol RepositoryDataPassing: AnyObject {
    var dataStore: RepositoryDataStore? { get }
}

class RepositoryRouter: NSObject, RepositoryDataPassing {
    weak var viewController: RepositoryViewController?
    var dataStore: RepositoryDataStore?
    
}

extension RepositoryRouter: RepositoryRoutingLogic {
    func openUrl(url: URL?) {
        if let url = url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
