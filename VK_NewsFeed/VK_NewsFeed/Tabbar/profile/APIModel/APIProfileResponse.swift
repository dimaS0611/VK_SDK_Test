//
//  APIProfileResponse.swift
//  VK_NewsFeed
//
//  Created by Dzmitry Semenovich on 20.06.21.
//

import Foundation

struct ProfileResponseWrapped: Decodable {
    let response: [ProfileResponse]
}

struct ProfileResponse: Decodable {
    let first_name: String
    let id: Int
    let last_name: String
    let sex: Int
    let online: Int
    let bdate: String
    let city: Location?
    let country: Location?
    let photo_200_orig: String
    let status: String
    let counters: Counters?
}

struct Location: Decodable {
    let id: Int
    let title: String
}

struct Counters: Decodable {
    let followers: Int
    let friends: Int
    let photos: Int
    let groups: Int
}

