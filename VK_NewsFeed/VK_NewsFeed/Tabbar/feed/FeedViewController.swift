//
//  FeedViewController.swift
//  VK_NewsFeed
//
//  Created by Dzmitry Semenovich on 19.06.21.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var posts: FeedResponse = FeedResponse(items: [], profiles: [], groups: [])
    var token: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        APIRequest(token: token).fetchData { res in
            self.posts = res ?? FeedResponse(items: [], profiles: [], groups: [])
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 //       return posts.count
        return posts.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedTableViewCell
        
        cell.postName.text = posts.items[indexPath.row].text
//        cell.postDate.text = posts.items[indexPath.row].
        //cell.postText.text = posts.items[indexPath.row].
      //  cell.postImage.image = posts[indexPath.row].image
        
        cell.likes.text = posts.items[indexPath.row].likes?.count.description
        cell.coments.text = posts.items[indexPath.row].comments?.count.description
        cell.reposts.text = posts.items[indexPath.row].reposts?.count.description
        cell.views.text = posts.items[indexPath.row].views?.count.description
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
