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
        }
        struct ViewModel {
        }
    }
}

extension RepositoriesList {
    struct FetchRepositoriesResponse: Codable {
        var count: Int
        var items: [Repository]
        
        enum CodingKeys: String, CodingKey {
            case count = "total_count"
            case items
        }
        
        struct Repository: Codable {
            var name: String
            var description: String
            var language: String
            var id: Int
            
            enum CodingKeys: String, CodingKey {
                case name = "full_name"
                case description
                case language
                case id
            }
        }
    }
    
}
