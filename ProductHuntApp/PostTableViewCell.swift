//
//  PostTableViewCell.swift
//  ProductHuntApp
//
//  Created by Mark Kim on 6/24/20.
//  Copyright © 2020 Mark Kim. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var nameOfPost: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var votesCount: UILabel!
    @IBOutlet weak var imageOfPost: UIImageView!
    @IBOutlet weak var taglineOfPost: UILabel!
    
    var post: Post? {
        // Runs every time the post variable is set
        didSet {
            // make sure we return if post doesn't exist
            guard let post = post else { return }
            nameOfPost.text = post.name
            commentsCount.text = "Comments: \(post.commentsCount)"
            votesCount.text = "Votes: \(post.votesCount)"
            taglineOfPost.text = post.tagline
            updatePreviewImage()
        }
    }
    
    func updatePreviewImage() {
        guard let post = post else { return }
        imageOfPost.image = UIImage(named: "placeholder")
    }
    
}
