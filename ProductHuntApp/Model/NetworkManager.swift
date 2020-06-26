//
//  NetworkManager.swift
//  ProductHuntApp
//
//  Created by Mark Kim on 6/25/20.
//  Copyright © 2020 Mark Kim. All rights reserved.
//


import UIKit

class NetworkManager {
    let urlSession = URLSession.shared
    
    var baseURL = "https://api.producthunt.com/v1/"
    var token = "OoSLWuc-2zC3_oIhbjaZXEwORjM9J4qQb0LwiuAcNxw"
    
    enum EndPoints {
        case posts
        case comments(postId: Int)
        
        func getPath() -> String {
            switch self {
            case .posts:
                return "posts/all"
            case .comments:
                return "comments"
            }
        }
        
        func getHTTPMethod() -> String {
            return "GET"
        }
        
        func getHeaders(token: String) -> [String: String] {
            return [
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)",
                "Host": "api.producthunt.com"
            ]
        }
        
        func getParams() -> [String: String] {
            switch self {
            case .posts:
                return [
                    "sort_by": "votes_count",
                    "order": "desc",
                    "per_page": "20",
                    
                    "search[featured]": "true"
                ]
            case let .comments(postId):
                return [
                    "sort_by": "votes",
                    "order": "asc",
                    "per_page": "20",

                    "search[post_id]": "\(postId)"
                ]
            }
        }
        
        func paramsToString() -> String {
            let parameterArray = getParams().map { key, value in
                return "\(key)=\(value)"
            }
            
            return parameterArray.joined(separator: "&")
        }
    }
    
    enum Result<T> {
        case success(T)
        case failure(Error)
    }
    
    enum EndPointError: Error {
        case couldNotParse
        case noData
    }
    
    // Cleaned up getPost function
    func getPosts(_ completion: @escaping (Result<[Post]>) -> Void) {
        let postsRequest = makeRequest(for: .posts)
        let task = urlSession.dataTask(with: postsRequest) { data, response, error in
            
            if let error = error {
                return completion(Result.failure(error))
            }
            
            guard let data = data else {
                return completion(Result.failure(EndPointError.noData))
            }
            
            guard let result = try? JSONDecoder().decode(PostList.self, from: data) else {
                return completion(Result.failure(EndPointError.couldNotParse))
            }
            
            let posts = result.posts
            
            DispatchQueue.main.async {
                completion(Result.success(posts))
            }
        }
        task.resume()
    }
    
    func getComments(_ postId: Int, completion: @escaping (Result<[Comment]>) -> Void) {
        let commentsRequest = makeRequest(for: .comments(postId: postId))
        let task = urlSession.dataTask(with: commentsRequest) { data, response, error in
            
            if let error = error {
                return completion(Result.failure(error))
            }
            
            guard let data = data else {
                return completion(Result.failure(EndPointError.noData))
            }
            
            guard let result = try? JSONDecoder().decode(CommentApiResponse.self, from: data) else {
                return completion(Result.failure(EndPointError.couldNotParse))
            }
            
            DispatchQueue.main.async {
                completion(Result.success(result.comments))
            }
        }
        task.resume()
    }
    
    // Cleaned up code
    private func makeRequest(for endPoint: EndPoints) -> URLRequest {
        // Grabing parameters from the endpoint and convert them into a string
        let stringParams = endPoint.paramsToString()
        // Getting the path of the endpoint
        let path = endPoint.getPath()
        // Creating full url from variables above
        let fullURL = URL(string: baseURL.appending("\(path)?\(stringParams)"))!
        // Building request
        var request = URLRequest(url: fullURL)
        
        request.httpMethod = endPoint.getHTTPMethod()
        request.allHTTPHeaderFields = endPoint.getHeaders(token: token)
        
        return request
        
    }
}
