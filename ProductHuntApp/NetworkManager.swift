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
    
    func getPosts(completion: @escaping ([Post]) -> Void) {
        // API query
        let query = "posts/all?sort_by=votes_count&order=desc&search[featured]=true&per_page=20"
        // Adding the baseURL to it
        let fullURL = URL(string: baseURL + query)!
        // Creating the request
        var request = URLRequest(url: fullURL)
        
        // We're sending a GET request, so we need to specify that
        request.httpMethod = "GET"
        // Add in all the header fields just like we did in Postman
        request.allHTTPHeaderFields = [
           "Accept": "application/json",
           "Content-Type": "application/json",
           "Authorization": "Bearer \(token)",
           "Host": "api.producthunt.com"
        ]
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                return
            }
            
            // Decode the API response into the PostList object that can be used/interacted with
            guard let result = try? JSONDecoder().decode(PostList.self, from: data) else {
                return
            }
            
            let posts = result.posts
            
            DispatchQueue.main.async {
                completion(posts)
            }
        }
        task.resume()
    }
}
