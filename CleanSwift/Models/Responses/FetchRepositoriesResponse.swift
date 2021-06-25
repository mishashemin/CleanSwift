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
        var name: String
        var description: String?
        var language: String?
        var id: Int
        
        enum CodingKeys: String, CodingKey {
            case name = "full_name"
            case description
            case language
            case id
        }
    }
}
