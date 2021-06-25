//
//  RepositoriesWorker.swift
//  CleanSwift
//
//  Created by m.shemin on 25.06.2021.
//

import Foundation

protocol RepositoriesStoreProtocol {
    func featchRepositories(searchQuery: String, startHadler: (() -> Void)?, errorHandler: ((BaseJsonApiServiceError) -> Void)?, completionHandler: @escaping (FetchRepositoriesResponse) -> Void) -> CancelableTask
}

class RepositoriesWorker {
    var repositoriesStore: RepositoriesStoreProtocol
    
    init(repositoriesStore: RepositoriesStoreProtocol) {
        self.repositoriesStore = repositoriesStore
    }
    
    func featchRepositories(
        searchQuery: String,
        startHadler: (() -> Void)?,
        errorHandler: ((BaseJsonApiServiceError) -> Void)?,
        completionHandler: @escaping (FetchRepositoriesResponse) -> Void
    ) -> CancelableTask {
        
        return repositoriesStore.featchRepositories(searchQuery: searchQuery,
                                                    startHadler: startHadler,
                                                    errorHandler: errorHandler,
                                                    completionHandler: completionHandler)
    }
}
