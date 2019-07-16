//
//  NetworkService.swift
//  ViewableMVC
//
//  Created by K Y on 7/1/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case unknownError
    case connectionError
    case invalidCredentials
    case invalidRequest
    case notFound
    case invalidResponse(Error)
    case serverError
    case serverUnavailable
    case timeOut
    case unsupportedURL
    case emptyResult
}

enum HTTPVerb: String {
    case GET = "GET"
    case PUT = "PUT"
    case POST = "POST"
}

final class NetworkService {
    
    // MARK: - Properties
    
    fileprivate var session: URLSession
    let allowRedundantRequests: Bool
    private var currentRequests: Set<URL>?
    
    // MARK: - Initialization
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
        allowRedundantRequests = true
        currentRequests = Set<URL>()
    }
    
    init(_ session: URLSession, _ allowRedundantRequests: Bool = false) {
        self.session = session
        self.allowRedundantRequests = allowRedundantRequests
        if allowRedundantRequests == true {
            currentRequests = Set<URL>()
        }
        
    }
    
    // MARK: - Endpoint Accessors
    
    func dataTask<T:Decodable>(url: URL,
                               type: T.Type,
                               verb: HTTPVerb = .GET,
                               params: [String:String]?,
                               completion: @escaping (Result<T, NetworkError>)->()) {
        if currentRequests?.contains(url) ?? false { return }
        currentRequests?.insert(url)
        dataTaskHelper(type: type,
                       url: url,
                       verb: verb,
                       params: params) { (result) in
                        switch result {
                        case .success(let val):
                            completion(.success(val))
                        case .failure(let fail):
                            completion(.failure(fail))
                        }
                        self.currentRequests?.remove(url)
        }
    }
    
    private func dataTaskHelper<T: Decodable>(type: T.Type,
                                              url: URL,
                                              verb: HTTPVerb,
                                              params: [String:String]?,
                                              completion: @escaping (Result<T, NetworkError>)->()) {
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = params
        urlRequest.httpMethod = verb.rawValue
        session.dataTask(with: urlRequest)
        { (data, response, error) in
            if let _ = error {
                completion(Result.failure(.connectionError))
                return
            }
            guard let _ = response else {
                completion(Result.failure(.serverError))
                return
            }
            guard let safeData = data else {
                completion(Result.failure(.emptyResult))
                return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: safeData)
                completion(Result.success(result))
            }
            catch let err {
                completion(Result.failure(.invalidResponse(err)))
            }
        }.resume()
    }
    
    func image(url: URL,
               verb: HTTPVerb = .GET,
               params: [String:String]?,
               completion: @escaping (Data?)->()) {
        if currentRequests?.contains(url) ?? false { return }
        currentRequests?.insert(url)
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = params
        urlRequest.httpMethod = verb.rawValue
        session.dataTask(with: urlRequest)
        { (data, _, _) in
            completion(data)
            self.currentRequests?.remove(url)
            }.resume()
    }
}
