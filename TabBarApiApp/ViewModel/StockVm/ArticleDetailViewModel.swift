//
//  ArticleDetailViewModel.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//


import Foundation

class ArticleDetailViewModel {
    private(set) var article: ArticleDetails?
    
    func setArticle(_ article: ArticleDetails) {
        self.article = article
    }

    var articleDetails: String {
        guard let article = article else { return "No details available" }
        return """
        Author: \(article.author ?? "Unknown")
        Title: \(article.title ?? "No Title")
        \n
        Published At: \(article.publishedAt ?? "Unknown Date")
        \n
        Description: \(article.description ?? "N/A")
        Content: \(article.content ?? "N/A")
        """
    }

    var articleImageURL: URL? {
        guard let urlString = article?.urlToImage else { return nil }
        return URL(string: urlString)
    }
}