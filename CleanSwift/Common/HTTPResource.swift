//
//  HTTPResource.swift
//  CleanSwift
//
//  Created by m.shemin on 25.06.2021.
//

import Foundation

struct HTTPResource<Value> {
    
    var urlString: String
    var method: URLRequest.HTTPMethod
    var parameters: [String: Any]?
    var encoding: ParameterEncoding
    var headers: HTTPHeaders
    var parse: ((Data) throws -> Value)?
    var acceptableStatusCodes: [Int]
    
    init(urlString: String,
         method: URLRequest.HTTPMethod,
         parameters: [String: Any]? = nil,
         encoding: ParameterEncoding = URLEncoding.default,
         headers: HTTPHeaders = [:],
         parse: ((Data) throws -> Value)?,
         acceptableStatusCodes: [Int] = Array(200..<300)) {
        self.urlString = urlString
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
        self.parse = parse
        self.acceptableStatusCodes = acceptableStatusCodes
    }
}
