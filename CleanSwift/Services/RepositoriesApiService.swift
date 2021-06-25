//
//  RepositoriesApiService.swift
//  CleanSwift
//
//  Created by m.shemin on 25.06.2021.
//

private enum Comstants {
    static let baseUrl = "https://api.github.com"
    static let baseHeaders = ["Accept": "application/vnd.github.v3+json"]
    
    static let featchRepositoriesPath = "/search/repositories"
}

import Foundation

class RepositoriesApiService: BaseApiService {
    
    static let shared = RepositoriesApiService()
    
    init() {
        guard let baseUrl = URL(string: Comstants.baseUrl) else {
            fatalError("failed url creation")
        }
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 15
        
        super.init(baseUrl: baseUrl, baseHeaders: Comstants.baseHeaders, sessionConfiguration: sessionConfiguration)
    }
    
    func featchRepositories(searchQuery: String,
                            startHadler: (() -> Void)? = nil,
                            errorHandler: ((BaseJsonApiServiceError) -> Void)? = nil,
                            completionHandler: @escaping (FetchRepositoriesResponse) -> Void) -> CancelableTask {
        
        let resource = HTTPResource(urlString: Comstants.featchRepositoriesPath,
                                    method: .get,
                                    parameters: ["q": searchQuery],
                                    parse: { data in
                                        return try JSONDecoder().decode(FetchRepositoriesResponse.self, from: data)
                                    })
        
        let task = sendRequest(resource)
            .on(starting: startHadler,
                failed: errorHandler,
                value: completionHandler)
            .start()
        
        return task
    }
}

extension RepositoriesApiService: RepositoriesStoreProtocol {}
