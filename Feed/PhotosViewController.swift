//
//  PhotosViewController.swift
//  Feed
//
//  Created by user145766 on 9/18/18.
//  Copyright © 2018 Kenia Rioja. All rights reserved.
//

import UIKit
import AlamofireImage

private let reuseIdentifier = "Cell"

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    var posts: [[String: Any]] = [] //Will store the posts retrieved from the network request
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PhotosViewController.didPullToRefresh(_:)), for: .valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 229
        
        fetchPosts()
        
    }
    
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        fetchPosts()
    }
    
    
    func fetchPosts() {
        activityIndicator.startAnimating()
        // Network request snippet
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                //print(dataDictionary)
                
                // TODO: Get the posts and store in posts property
                // Get the dictionary from the response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                // TODO: Reload the table view
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let post = posts[indexPath.row]
        
        if let photos = post["photos"] as? [[String: Any]] {
            // photos is NOT nil, we can use it!
            // TODO: Get the photo url
            // 1. Get the first photo in the photos array
            let photo = photos[0]
            // 2. Get the original size dictionary from the photo
            let originalSize = photo["original_size"] as! [String: Any]
            // 3. Get the url string from the original size dictionary
            let urlString = originalSize["url"] as! String
            // 4. Create a URL using the urlString
            let url = URL(string: urlString)
            
            cell.photoImageView.af_setImage(withURL: url!)
        }
        return cell
    }}
