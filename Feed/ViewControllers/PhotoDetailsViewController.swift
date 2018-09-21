//
//  PhotoDetailsViewController.swift
//  Feed
//
//  Created by user145766 on 9/21/18.
//  Copyright © 2018 Kenia Rioja. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var photoDetailsImageView: UIImageView!
    
    var post: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let post = post {
            
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
                let url = URL(string: urlString)!
                
            photoDetailsImageView.af_setImage(withURL: url)
            }
        }
    }
}

