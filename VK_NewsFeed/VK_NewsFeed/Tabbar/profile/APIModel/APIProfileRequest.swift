//
//  APIProfileRequest.swift
//  VK_NewsFeed
//
//  Created by Dzmitry Semenovich on 20.06.21.
//

import Foundation
import VK_ios_sdk

struct APIProfileRequest {
    
    var accessToken: String = VKSdk.accessToken().accessToken
    var userId: String = VKSdk.accessToken().userId
    
    func fetchData(completion: @escaping (ProfileResponse?, Bool) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.vk.com/method/users.get?user_ids=\(userId)&fields=photo_200_orig,sex,city,country,education,followers_count,bdate,counters,online,%20status&v=5.131&access_token=\(accessToken)")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            if(error != nil) {
                print(error as Any)
            } else {
                do {
                    let jsonData = String(decoding: data!, as: UTF8.self)
                    let response  = try? JSONDecoder().decode(ProfileResponseWrapped.self, from: jsonData.data(using: .utf8)!)
                    
                    completion(response?.response[0], true)
                }
            }
            
        }
        dataTask.resume()
    }
}
