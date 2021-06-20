//
//  ProfileViewController.swift
//  VK_NewsFeed
//
//  Created by Dzmitry Semenovich on 20.06.21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var onlineStatus: UILabel!
    @IBOutlet weak var profileStatus: UILabel!
    @IBOutlet weak var userResidence: UILabel!
    @IBOutlet weak var dateOfBirth: UILabel!
    @IBOutlet weak var userSex: UILabel!
    @IBOutlet weak var userFriends: UILabel!
    @IBOutlet weak var userFollowers: UILabel!
    @IBOutlet weak var userCommunities: UILabel!
    @IBOutlet weak var userPhotos: UILabel!
    
    let spinner = SpinnerViewController()
    var profile: ProfileResponse? = nil
    
    var isLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.navigationController?.title = "Profile"
        self.tabBarController?.navigationItem.hidesBackButton = true
        
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
        
        
        APIProfileRequest().fetchData { (result, loaded) in
            self.profile = result
            self.isLoaded = loaded
            
            if(self.isLoaded) {
                
                DispatchQueue.main.async {
                    self.initFields()
                    self.spinner.willMove(toParent: self)
                    self.spinner.view.removeFromSuperview()
                    self.spinner.removeFromParent()
                }
                
            }
        }
    }
    
    func initFields() {
        self.profilePhoto.load(urlString: self.profile?.photo_200_orig ?? "https://vk.com/images/camera_200.png", targetSize: CGSize(width: 150,height: 150))
        self.name.text = ((profile?.first_name ?? "userName") + " " + (profile?.last_name ?? ""))
        
        if(profile?.online == 1){
            self.onlineStatus.text = "online"
        } else {
            self.onlineStatus.text = "offline"
        }
        
        self.profileStatus.text = profile?.status
        self.userResidence.text = ((profile?.city?.title ?? "") + " " + (profile?.country?.title ?? ""))
        self.dateOfBirth.text = profile?.bdate
        
        if(profile?.sex == 1) {
            self.userSex.text = "female"
        } else if(profile?.sex == 2) {
            self.userSex.text = "male"
        }
        
        self.userFriends.text = ("Friends " + String(profile?.counters?.friends ?? 0))
        self.userFollowers.text = ("Followers " + String(profile?.counters?.followers ?? 0))
        self.userCommunities.text = ("Communities " + String(profile?.counters?.groups ?? 0))
        self.userPhotos.text = ("Photos " + String(profile?.counters?.photos ?? 0))
    }
}
