//
//  FetchRepositoriesResponse.swift
//  CleanSwift
//
//  Created by m.shemin on 25.06.2021.
//

struct FetchRepositoriesResponse: Codable {
    var count: Int
    var items: [Repository]
    
    enum CodingKeys: String, CodingKey {
        case count = "total_count"
        case items
    }
    
    struct Repository: Codable {
        var path: String
        var name: String
        var description: String?
        var language: String?
        var id: Int
        
        enum CodingKeys: String, CodingKey {
            case path = "full_name"
            case name 
            case description
            case language
            case id
        }
    }
}
