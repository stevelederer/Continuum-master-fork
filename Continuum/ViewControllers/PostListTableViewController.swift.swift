//
//  PostListTableViewController.swift
//  Continuum
//
//  Created by DevMountain on 9/17/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var postSearchBar: UISearchBar!
    
    var resultsArray: [SearchableRecord]?
    
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postSearchBar.delegate = self
<<<<<<< HEAD
//        tableView.prefetchDataSource = self
=======
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(postsChanged(_:)), name: PostController.PostsChangedNotification, object: nil)
        
>>>>>>> aee97c714262b1fa8095bd6230d2172142b37615
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
        fetchAllPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resultsArray = PostController.shared.posts
        tableView.reloadData()
    }
    
    @objc func postsChanged(_ notification: Notification) {
        tableView.reloadData()
    }
    
    func fetchAllPosts() {
        PostController.shared.fetchQueriedPosts { (firstPosts, continuedPosts) in
            if firstPosts != nil {
//                guard let firstPosts = firstPosts else { return }
//                let indexPath = IndexPath(row: firstPosts.count - 1, section: 0)
                DispatchQueue.main.async {

                    self.tableView.reloadData()
                }
            }
            if continuedPosts != nil {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isSearching ? resultsArray?.count ?? 0: PostController.shared.posts.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell
//        let post = resultsArray?[indexPath.row] as? Post
        let dataSource = isSearching ? resultsArray : PostController.shared.posts
        let post = dataSource?[indexPath.row]
        cell?.post = post as? Post
        return cell ?? UITableViewCell()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let posts = PostController.shared.posts
        let filteredPosts = posts.filter { $0.matches(searchTerm: searchText) }.compactMap { $0 as SearchableRecord }
        resultsArray = filteredPosts
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        resultsArray = PostController.shared.posts
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostDetailVC"{
            let destinationVC = segue.destination as? PostDetailTableViewController
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let post = PostController.shared.posts[indexPath.row]
            destinationVC?.post = post
        }
    }

}

extension PostListTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            let post = PostController.shared.posts[indexPath.row]
            guard let url = post.imageAsset?.fileURL else {print("No tep url"); return }
            print("Prefetching \(post.caption)")
            URLSession.shared.dataTask(with: url).resume()
        }
    }
    
    
    
}