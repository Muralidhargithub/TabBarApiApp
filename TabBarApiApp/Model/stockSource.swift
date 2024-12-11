//
//  stockSource.swift
//  ApiParsingMVVM
//
//  Created by Muralidhar reddy Kakanuru on 12/5/24.
//


import Foundation


struct stockSource: Codable{
    let id : String?
    let name : String?
}

struct stockArticle: Codable{
    let source : stockSource
    let author : String?
    let title : String?
    let description: String?
    let url :String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct Stocks: Codable{
    let status: String?
    let totalResults: Int?
    let articles: [stockArticle]
}
