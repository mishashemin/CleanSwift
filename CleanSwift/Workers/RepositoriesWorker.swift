//
//  RepositoriesWorker.swift
//  CleanSwift
//
//  Created by m.shemin on 25.06.2021.
//

import Foundation

protocol RepositoriesStoreProtocol {
    func featchRepositories(searchQuery: String, startHadler: (() -> Void)?, errorHandler: ((BaseJsonApiServiceError) -> Void)?, completionHandler: @escaping (FetchRepositoriesResponse) -> Void) -> CancelableTask
    
    func featchRepository(path: String, startHadler: (() -> Void)?, errorHandler: ((BaseJsonApiServiceError) -> Void)?, completionHandler: @escaping (FetchRepositoryResponse) -> Void) -> CancelableTask
}

class RepositoriesWorker {
    var repositoriesStore: RepositoriesStoreProtocol
    
    init(repositoriesStore: RepositoriesStoreProtocol) {
        self.repositoriesStore = repositoriesStore
    }
    
    @discardableResult
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
    
    @discardableResult
    func featchRepository(
        path: String,
        startHadler: (() -> Void)? = nil,
        errorHandler: ((BaseJsonApiServiceError) -> Void)? = nil,
        completionHandler: @escaping (FetchRepositoryResponse) -> Void
    ) -> CancelableTask {
        
        return repositoriesStore.featchRepository(path: path,
                                                  startHadler: startHadler,
                                                  errorHandler: errorHandler,
                                                  completionHandler: completionHandler)
    }
}
