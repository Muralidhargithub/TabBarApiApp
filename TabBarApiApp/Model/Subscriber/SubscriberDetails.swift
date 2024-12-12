//
//  SubscriberDetails.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//


import Foundation


struct SubscriberDetails: Codable{
    let id: Int?
    let email: String?
    let first_name: String?
    let last_name: String?
    let avatar: String?
}

struct Subscriber: Codable{
    let data: [SubscriberDetails]
}

