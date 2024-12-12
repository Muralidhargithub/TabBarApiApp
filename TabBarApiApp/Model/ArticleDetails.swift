//
//  ArticleDetails.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//


struct ArticleDetails: Codable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct Article: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [ArticleDetails]
}

