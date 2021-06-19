//
//  APIResponse.swift
//  VK_NewsFeed
//
//  Created by Dzmitry Semenovich on 19.06.21.
//

import Foundation

struct FeedResponseWrapped: Decodable {
    let response: FeedResponse
}

struct FeedResponse: Decodable {
    var items: [FeedItem]
    var profiles: [Profile]
    var groups: [Group]
}

struct FeedItem: Decodable {
    let sourceId: Int
    let date: Int
    let topicId: Int
    let text: String?
    let attachements: [Attachements]?
    let comments: CounterItem?
    let likes: CounterItem?
    let reposts: CounterItem?
    let views: CounterItem?
    
}

struct Attachements: Decodable {
    let photo: Photo?
}

struct Photo: Decodable {
    let id: Int
    let sizes: [PhotoSize]
    
    var height: Int {
        return photoSize().height
    }
    
    var width: Int {
        return photoSize().width
    }
    
    var url: String {
        return photoSize().url
    }
    
    private func photoSize() -> PhotoSize {
        if let typeX = sizes.first(where: { $0.type == "x" }) {
            return typeX
        } else if let size = sizes.last {
            return size
        } else {
            return PhotoSize(height: 0, url: "err", type: "err", width: 0)
        }
    }
        
}

struct PhotoSize : Decodable {
    let height : Int
    let url : String
    let type : String
    let width : Int
}

struct CounterItem: Decodable {
    let count: Int
}

struct Profile: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String
    
    var name: String {
        return firstName + "" + lastName
    }
}

struct Group: Decodable {
    let id: Int
    let name: String
    let photo100: String
}
