//
//  ViewController.swift
//  VK_NewsFeed
//
//  Created by Dzmitry Semenovich on 18.06.21.
//

import UIKit
import VK_ios_sdk

class ViewController: UIViewController, VKSdkDelegate, VKSdkUIDelegate {
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        // -TODO: move to WebView
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if((result.token) != nil) {
            print("token: \(String(describing: result.token))")
            accsessToken = result.token.accessToken
        } else if((result.error) != nil) {
            print(result.error.debugDescription)
        }
    }
    
    func vkSdkAuthorizationStateUpdated(with result: VKAuthorizationResult!) {
        let stroryboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let tabbarController = stroryboard.instantiateViewController(identifier: "Tabbar") as! UITabBarController
        let destinationController = tabbarController.viewControllers?[0] as! FeedViewController
        destinationController.token = accsessToken
        destinationController.id = result.user.id.intValue
        self.navigationController?.pushViewController(tabbarController, animated: true)
    }
    func vkSdkUserAuthorizationFailed() {
       
    }
    
    let VK_APP_ID = "7883260"
    var accsessToken = "---"
    let scope =  ["wall", "friends", "staus", "photos"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sdkInstance = VKSdk.initialize(withAppId: VK_APP_ID)
        
        sdkInstance?.register(self)
        sdkInstance?.uiDelegate = self
        
        VKSdk.wakeUpSession(scope,complete: {(state: VKAuthorizationState, error: Error?) -> Void in
            if state == VKAuthorizationState.authorized {
                
            } else {
                VKSdk.authorize(self.scope)
            }
        })
        
//
        
    }


}

