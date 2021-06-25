//
//  RepositoriesListModels.swift
//  CleanSwift
//
//  Created by m.shemin on 24.06.2021.

import UIKit

enum RepositoriesList {
    enum FetchRepositories {
        struct Request {
            var searchQuery: String
        }
        struct Response {
            var repositoriesResponse: FetchRepositoriesResponse
        }
        struct ViewModel {
            struct Repository {
                var name: String
                var description: String
                var language: String
                var id: Int
            }
            var repositories: [Repository]
        }
    }
    
    enum SelectRepository {
        struct Request {
            var repositoryId: Int
        }
        struct Response {
            var repositoryId: Int
        }
        struct ViewModel {
            var repositoryId: Int
        }
    }
}

extension RepositoriesList {
    enum FetchRepositoriesStatus {
        case success
        case loading
        case emptyRequest
        case emptyResponse
        case error(error: Error)
    }
}
