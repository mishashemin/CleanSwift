//
//  RepositoryModels.swift
//  CleanSwift
//
//  Created by m.shemin on 25.06.2021.

import UIKit

enum Repository {
    enum ViewWillAppear {
        struct Request {
        }
        struct Response {
            let repositoryResponse: FetchRepositoryResponse
        }
        struct ViewModel {
            let ownerName: String
            let repositoryDescription: String
            let starCount: String
            let forksCount: String
            let watchersCount: String
        }
    }
    
    enum ShowPage {
        enum PageType {
            case owner
            case repository
        }
        struct Request {
            var pageType: PageType
        }
        struct Response {
            let url: URL?
        }
        struct ViewModel {
            let url: URL?
        }
    }
}
