//
//  Comment.swift
//  ProductHuntApp
//
//  Created by Mark Kim on 6/25/20.
//  Copyright © 2020 Mark Kim. All rights reserved.
//

import Foundation

struct Comment: Decodable {
    let id: Int
    let body: String
}

struct CommentApiResponse: Decodable {
    let comments: [Comment]
}
