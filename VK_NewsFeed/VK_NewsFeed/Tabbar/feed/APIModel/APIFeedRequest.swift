//
//  APIRequest.swift
//  VK_NewsFeed
//
//  Created by Dzmitry Semenovich on 19.06.21.
//

import Foundation
import UIKit
import VK_ios_sdk

struct APIFeedRequest {
    
    var accessToken: String = VKSdk.accessToken().accessToken
    var userId: String = VKSdk.accessToken().userId
    
    func fetchData(completion: @escaping (FeedResponse?, Bool) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.vk.com/method/newsfeed.get?user_id=\(userId)&filters=post,photo&v=5.131&access_token=\(accessToken)")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            if(error != nil) {
                print(error as Any)
            } else {
                do {
                    let jsonData = String(decoding: data!, as: UTF8.self)
                    let response  = try? JSONDecoder().decode(FeedResponseWrapped.self, from: jsonData.data(using: .utf8)!)
                    
                    completion(response?.response, true)
                }
            }
        }
        dataTask.resume()
    }
}
