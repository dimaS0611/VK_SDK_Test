//
//  ViewController.swift
//  VK_NewsFeed
//
//  Created by Dzmitry Semenovich on 18.06.21.
//

import UIKit
import VK_ios_sdk

class ViewController: UIViewController, VKSdkDelegate, VKSdkUIDelegate {
    
    let VK_APP_ID = "7883260"
    var accsessToken = "---"
    let scope =  ["wall", "friends", "staus", "photos"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sdkInstance = VKSdk.initialize(withAppId: VK_APP_ID)
        
        sdkInstance?.register(self)
        sdkInstance?.uiDelegate = self
    }
    
    @IBAction func logIn(_ sender: Any) {
        wakeUpSession()
    }
    
    func wakeUpSession() {
        VKSdk.wakeUpSession(scope,complete: {(state: VKAuthorizationState, error: Error?) -> Void in
            
            switch(state){
            case .authorized:
                break
                
            case .initialized:
                VKSdk.authorize(self.scope)
                
                break
            default:
                print("Something went wromg")
            }
        })
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        let vc = VKCaptchaViewController.captchaControllerWithError(captchaError)
        vc?.present(in: self)
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if((result.token) != nil) {
            print("Authorization was finished successfully")
        } else if((result.error) != nil) {
            print(result.error.debugDescription)
        }
    }
    
    func vkSdkAuthorizationStateUpdated(with result: VKAuthorizationResult!) {
        let stroryboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let tabbarController = stroryboard.instantiateViewController(identifier: "Tabbar") as! UITabBarController
        self.navigationController?.pushViewController(tabbarController, animated: true)
    }
    
    func vkSdkUserAuthorizationFailed() {
        let ac = UIAlertController(title: "", message: "Authorization was failed", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

