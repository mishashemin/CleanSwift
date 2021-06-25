//
//  BaseApiService.swift
//  CleanSwift
//
//  Created by m.shemin on 25.06.2021.
//

import Foundation

enum BaseJsonApiServiceError: Error {
    case failedToCreateRequest
    case invalidResponse
    case emptyResponseData
    case invalidStatusCode(code: Int)
    case serverError(error: Error)
    case parseError(error: Error)
}

class BaseApiService {
    private let baseUrl: URL
    private let baseHeaders: HTTPHeaders
    private let session: URLSession
    
    init(baseUrl: URL, baseHeaders: HTTPHeaders = [:], sessionConfiguration: URLSessionConfiguration = .default) {
        self.baseUrl = baseUrl
        self.baseHeaders = baseHeaders
        self.session = URLSession(configuration: sessionConfiguration)
    }
    
    func sendRequest<Value>(_ resource: HTTPResource<Value>) -> SessionDataTaskHandler<Value> {

        guard let request = try? self.request(
            urlString: resource.urlString,
            method: resource.method,
            parameters: resource.parameters,
            encoding: resource.encoding,
            headers: resource.headers
        ) else {
            return SessionDataTaskHandler(error: BaseJsonApiServiceError.failedToCreateRequest)
        }
        let dataTaskHandler = SessionDataTaskHandler<Value>()
        let task = session.dataTask(with: request) { data, response, error in
            defer {
                dataTaskHandler.terminateHandler?()
            }
            
            if let error = error {
                dataTaskHandler.errorHandler?(BaseJsonApiServiceError.serverError(error: error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                dataTaskHandler.errorHandler?(BaseJsonApiServiceError.invalidResponse)
                return
            }
            
            guard resource.acceptableStatusCodes.contains(response.statusCode) else {
                dataTaskHandler.errorHandler?(BaseJsonApiServiceError.invalidStatusCode(code: response.statusCode))
                return
            }
            
            guard let data = data else {
                if resource.parse == nil {
                    dataTaskHandler.completionHandler?()
                } else {
                    dataTaskHandler.errorHandler?(BaseJsonApiServiceError.emptyResponseData)
                }
                return
            }
            
            if let parse = resource.parse {
                do {
                    let value = try parse(data)
                    dataTaskHandler.valueHandler?(value)
                    dataTaskHandler.completionHandler?()
                } catch let error {
                    dataTaskHandler.errorHandler?(BaseJsonApiServiceError.parseError(error: error))
                }
            }
            
        }
        dataTaskHandler.sessionDataTask = task
        return dataTaskHandler
    }
    
    private func request(
        urlString: String,
        method: URLRequest.HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders = [:])
        throws ->  URLRequest {
        
        let url = baseUrl.appendingPathComponent(urlString)
        let headers = baseHeaders.merging(headers, uniquingKeysWith: { (_, new) in new })
        
        let originalRequest = URLRequest(url: url, method: method, headers: headers)
        let encodedURLRequest = try encoding.encode(originalRequest, with: parameters)
        return encodedURLRequest
    }
}

protocol CancelableTask: AnyObject {
    func cancel()
}

class SessionDataTaskHandler<Value>: CancelableTask {
    fileprivate var errorHandler: ((BaseJsonApiServiceError) -> Void)? {
        didSet {
            if let error = error {
                errorHandler?(error)
                terminateHandler?()
            }
        }
    }
    
    fileprivate var valueHandler: ((Value) -> Void)?
    fileprivate var startHandler: (() -> Void)?
    fileprivate var terminateHandler: (() -> Void)?
    fileprivate var completionHandler: (() -> Void)?
    
    private var error: BaseJsonApiServiceError?
    fileprivate var sessionDataTask: URLSessionDataTask?
    
    init(error: BaseJsonApiServiceError) {
        self.error = error
    }
    
    init() {}
    
    func on(starting: (() -> Void)? = nil,
            terminated: (() -> Void)? = nil,
            completed: (() -> Void)? = nil,
            failed: ((BaseJsonApiServiceError) -> Void)? = nil,
            value: ((Value) -> Void)? = nil) -> SessionDataTaskHandler<Value> {
        errorHandler = failed
        valueHandler = value
        startHandler = starting
        terminateHandler = terminated
        completionHandler = completed
        return self
    }
    
    func start() -> SessionDataTaskHandler<Value> {
        if let sessionDataTask = sessionDataTask {
            sessionDataTask.resume()
            startHandler?()
        }
        return self
    }
    
    func cancel() {
        if let sessionDataTask = sessionDataTask {
            errorHandler = nil
            valueHandler = nil
            completionHandler = nil
            
            sessionDataTask.cancel()
        }
    }
}
