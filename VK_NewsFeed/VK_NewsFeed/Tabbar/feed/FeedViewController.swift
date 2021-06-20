//
//  FeedViewController.swift
//  VK_NewsFeed
//
//  Created by Dzmitry Semenovich on 19.06.21.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    var posts: FeedResponse = FeedResponse(items: [], profiles: [], groups: [])
    
    let spinner = SpinnerViewController()
    let dateFormatter = DateFormatter()
    
    var isLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.title = "Home"
        
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
        
        dateFormatter.dateFormat = "MMM d h:mm a"
        
        APIFeedRequest().fetchData { (result, loaded) in
            self.posts = result ?? FeedResponse(items: [], profiles: [], groups: [])
            self.isLoaded = loaded
            
            if(self.isLoaded){
                DispatchQueue.main.async {
                    self.table.reloadData()
                    self.spinner.willMove(toParent: self)
                    self.spinner.view.removeFromSuperview()
                    self.spinner.removeFromParent()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.table.estimatedRowHeight = 50
        self.table.rowHeight = UITableView.automaticDimension
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedTableViewCell
        
        cell.postName.text = profileResourceFinder(sourceId: posts.items[indexPath.row].source_id, resource: .profileName)
        cell.postText.text = posts.items[indexPath.row].text
        
        cell.postDate.text = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(posts.items[indexPath.row].date)))
        
        let profileImage = profileResourceFinder(sourceId: posts.items[indexPath.row].source_id, resource: .profileImage)
        cell.profileImage.load(urlString: profileImage, targetSize: CGSize(width: 100, height: 100))
        
        let postImageURL = posts.items[indexPath.row].attachments?[0].photo
        cell.postImage.load(urlString: postImageURL?.url ?? "", targetSize: CGSize(width: postImageURL?.width ?? 0, height: postImageURL?.height ?? 0))
        
        cell.likes.text = posts.items[indexPath.row].likes?.count.description
        cell.coments.text = posts.items[indexPath.row].comments?.count.description
        cell.reposts.text = posts.items[indexPath.row].reposts?.count.description
        
        let views = posts.items[indexPath.row].views?.count ?? 0
        
        if (Double(views / 1000) >= 1.0) {
            cell.views.text = String(views / 1000) + "k"
        } else {
            cell.views.text = views.description
        }
        
        return cell
    }
    
    enum LookingResource {
        case profileImage
        case profileName
    }
    
    func profileResourceFinder(sourceId: Int, resource: LookingResource) -> String{
        
        switch resource {
        case .profileImage:
            var url = posts.groups.first(where: { $0.id == abs(sourceId) })?.photo_100
            
            if url == nil {
                url = posts.profiles.first(where: { $0.id == abs(sourceId) })?.photo_100
            }
            
            return url ?? "There is no such source"
            
        case .profileName:
            var name = posts.groups.first(where: { $0.id == abs(sourceId) })?.name
            
            if name == nil {
                name = posts.profiles.first(where: { $0.id == abs(sourceId) })?.name
            }
            
            return name ?? "--"
        }
    }
}
