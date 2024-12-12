//
//  ArticleNetworkManager.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//


import Foundation
import UIKit

//MARK: - Protocols for the data and image

protocol ArticleNetworkManager {
    func fetchArticleData<T: Decodable>(url:String) async throws -> T
    func fetchArticleImage(url: String)async throws -> UIImage
}

class ArticleNetworkManagerImpl: ArticleNetworkManager {
    static let shared = ArticleNetworkManagerImpl()
    private var imageCache = NSCache<NSString, UIImage>()
    private let urlSession: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        self.urlSession = URLSession(configuration: config)
    }
    
    //MARK: - Implementing FetchArticleData
    
    func fetchArticleData<T: Decodable>(url: String) async throws -> T  {
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await urlSession.data(from: url)
        
        do{
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        }
    }
    
    //MARK:- Implementing FetchArticleImage
    func fetchArticleImage(url: String) async throws -> UIImage {
        if let cachedImage = imageCache.object(forKey: url as NSString){
            return cachedImage
        }
        
        guard let serverURl = URL(string:url) else{
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await urlSession.data(from: serverURl)
        
        guard let image = UIImage(data: data) else{
            throw NetworkError.invalidData
        }
        imageCache.setObject(image, forKey: url as NSString)
        return image
        
    }
}
