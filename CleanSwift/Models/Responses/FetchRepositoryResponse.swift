//
//  FeatchRepositoryResponse.swift
//  CleanSwift
//
//  Created by m.shemin on 26.06.2021.
//

struct FetchRepositoryResponse: Codable {
    
    var description: String
    var owner: Owner
    var url: String
    var forksCount: Int
    var starsCount: Int
    var subscribersCount: Int
    
    enum CodingKeys: String, CodingKey {
        case description
        case owner
        case url = "html_url"
        case starsCount = "stargazers_count"
        case forksCount = "forks"
        case subscribersCount = "subscribers_count"
    }
    
    struct Owner: Codable {
        var name: String
        var url: String
        
        enum CodingKeys: String, CodingKey {
            case name = "login"
            case url = "html_url"
        }
    }
}
