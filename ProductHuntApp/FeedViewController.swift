//
//  FeedViewController.swift
//  ProductHuntApp
//
//  Created by Mark Kim on 6/23/20.
//  Copyright © 2020 Mark Kim. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    @IBOutlet weak var feedTableView: UITableView!
    
//    var mockData: [Post] = {
//        var meTube = Post(id: 0, name: "MeTube", commentsCount: 4, votesCount: 25, tagline: "Selfish youtube")
//        var boogle = Post(id: 1, name: "Boogle", commentsCount: 50, votesCount: 1000, tagline: "Budget google")
//        var meTunes = Post(id: 2, name: "meTunes", commentsCount: 590, votesCount: 25000, tagline: "Songs only for me")
//        
//        return [meTube, boogle, meTunes]
//    }()
    
    var posts: [Post] = [] {
        didSet {
            feedTableView.reloadData()
        }
    }
    
    var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFeed()
        
        feedTableView.dataSource = self
        feedTableView.delegate = self
    }
    
    func updateFeed() {
        networkManager.getPosts() { result in
            self.posts = result
        }
    }


}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    /// Determines how many cells will be shown on the table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    /// Creates and configures each cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        
        let post = posts[indexPath.row]
        cell.post = post
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let commentsView = storyboard.instantiateViewController(withIdentifier: "commentsView") as? CommentsViewController else {
            return
        }
        
        commentsView.comments = ["kjaodfsdjf jdoifaj", "oiajdfoaj", "ioi.ioj io22memf."]
        navigationController?.pushViewController(commentsView, animated: true)
    }
}

