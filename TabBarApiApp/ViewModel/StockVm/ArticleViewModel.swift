//
//  ArticleViewModel.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//


import Foundation

class ArticleViewModel {
    
    private(set) var articleData: [ArticleDetails] = []
    var onFetchSucess: (() -> ())?
    
    func fetchArticles() async {
        let url = ServerConstants.baseUrl
        
        do {
            // Fetch the raw data
            let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
            
            // Print the raw response for debugging
            if let rawString = String(data: data, encoding: .utf8) {
                print("Raw response data: \(rawString)")
            }
            
            // Attempt to decode the data
            let fetchedData: Article = try JSONDecoder().decode(Article.self, from: data)
            DispatchQueue.main.async {
                self.articleData = fetchedData.articles
                self.onFetchSucess?()
            }
        } catch let error as DecodingError {
            // Catch specific decoding errors and print them
            print("Decoding error: \(error)")
        } catch {
            // Catch other errors
            print("Error to fetch the data: \(error.localizedDescription)")
        }
    }


    
    func getArticleData(at index: Int) -> ArticleDetails {
        return articleData[index]
    }
    
}
