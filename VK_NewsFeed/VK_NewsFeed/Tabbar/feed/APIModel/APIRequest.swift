//
//  APIRequest.swift
//  VK_NewsFeed
//
//  Created by Dzmitry Semenovich on 19.06.21.
//

import Foundation
import UIKit

protocol NetworkConnection {
    func request(urlPath: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void)
}

struct APIRequest {
    
    var accessToken: String
    init(token: String) {
        self.accessToken = token
    }
    
    func fetchData(completion: @escaping (FeedResponse?) -> Void) {
        let request = NSMutableURLRequest(url: NSURL(string: "\(APIStruct.scheme)\(APIStruct.hostName) \(APIStruct.method)?filters=post,photo&access_token=\(accessToken)")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            if(error != nil) {
                print(error as Any)
            } else {
                do {
                    let jsonData = String(decoding: data!, as: UTF8.self)
                    let response  = try? JSONDecoder().decode(FeedResponseWrapped.self, from: jsonData.data(using: .utf8)!)
                    
                    completion(response?.response)
                    print(jsonData)
                }
            }
            
        }
        dataTask.resume()
    }
    /*
    func fetchData(response: @escaping (FeedResponse?) -> Void) {
        let params = ["filters" : "post, photo"]
        
        networkConnection.request(urlPath: APIStruct.method, params: params) { (data, error) in
            if error != nil {
                print("Error to fetch requesting data: \(String(describing: error?.localizedDescription))")
                response(nil)
            }
            
            let parsedData = self.JSONDecoder(type: FeedResponseWrapped.self, from: data)
            response(parsedData?.response)
        }
    }
    
    private func JSONDecoder<T: Decodable>(type: T.Type, from: Data?) -> T? {
        
        let decoder = Foundation.JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type, from: data) else { return nil }
        
        return response
    }*/
}
