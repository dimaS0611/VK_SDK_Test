//
//  FeedTableViewCell.swift
//  VK_NewsFeed
//
//  Created by Dzmitry Semenovich on 19.06.21.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postName: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var coments: UILabel!
    @IBOutlet weak var reposts: UILabel!
    @IBOutlet weak var views: UILabel!
}
