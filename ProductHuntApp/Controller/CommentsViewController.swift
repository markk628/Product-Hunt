//
//  CommentsViewController.swift
//  ProductHuntApp
//
//  Created by Mark Kim on 6/25/20.
//  Copyright © 2020 Mark Kim. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {

    @IBOutlet weak var commentsTableView: UITableView!
    
    var comments: [Comment] = [] {
        didSet {
            commentsTableView.reloadData()
        }
    }
    
    var postID: Int!
    
    var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateComments()
        
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
    }
    
    func updateComments() {
       networkManager.getComments(postID) { result in
           switch result {
           case let .success(comments):
             self.comments = comments
           case let .failure(error):
             print(error)
           }
       }
    }
    
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        
        let comment = comments[indexPath.row]
        cell.commentTextView.text = comment.body
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}
