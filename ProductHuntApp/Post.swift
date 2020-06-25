//
//  Post.swift
//  ProductHuntApp
//
//  Created by Mark Kim on 6/23/20.
//  Copyright © 2020 Mark Kim. All rights reserved.
//

import Foundation

struct Post {
    let id: Int
    let name: String
    let commentsCount: Int
    let votesCount: Int
    let tagline: String
    let previewImageURL: URL
}

struct PostList: Decodable {
    var posts: [Post]
}

extension Post: Decodable {
    enum PostKeys: String, CodingKey {
        case id
        case name
        case commentsCount = "comments_count"
        case votesCount = "votes_count"
        case tagline
        case previewImageURL = "screenshot_url"
    }
    
    enum PreviewImageURLKeys: String, CodingKey {
        // We only want the 850px urls
        case imageURL = "850px"
    }
    
    init(from decoder: Decoder) throws {
        let postsContainer = try decoder.container(keyedBy: PostKeys.self)
        id = try postsContainer.decode(Int.self, forKey: .id)
        name = try postsContainer.decode(String.self, forKey: .name)
        commentsCount = try postsContainer.decode(Int.self, forKey: .commentsCount)
        votesCount = try postsContainer.decode(Int.self, forKey: .votesCount)
        tagline = try postsContainer.decode(String.self, forKey: .tagline)
        
        let screenshotURLContainer = try postsContainer.nestedContainer(keyedBy: PreviewImageURLKeys.self, forKey: .previewImageURL)
        previewImageURL = try screenshotURLContainer.decode(URL.self, forKey: .imageURL)
    }
}
