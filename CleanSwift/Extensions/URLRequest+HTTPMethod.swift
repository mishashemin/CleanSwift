//
//  URLRequest+HTTPMethod.swift
//  CleanSwift
//
//  Created by m.shemin on 25.06.2021.
//

import Foundation

/// A dictionary of headers to apply to a `URLRequest`.
public typealias HTTPHeaders = [String: String]

extension URLRequest {
    
    public enum HTTPMethod: String {
        
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
        case head = "HEAD"
        case options = "OPTIONS"
        case trace = "TRACE"
        case connect = "CONNECT"
    }
    
    public var method: HTTPMethod? {
        
        get {
            guard let httpMethod = self.httpMethod else { return nil }
            let method = HTTPMethod(rawValue: httpMethod)
            return method
        }
        
        set {
            
            self.httpMethod = newValue?.rawValue
        }
    }
}

extension URLRequest {
    
    public init(url: URL, method: HTTPMethod, headers: HTTPHeaders? = nil) {
        self.init(url: url)

        httpMethod = method.rawValue

        if let headers = headers {
            for (headerField, headerValue) in headers {
                setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
    }
}
