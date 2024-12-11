//
//  NetworkManagerAPi.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//


import Foundation
import UIKit

protocol ImageDef {
    func getData<T:Codable>(url:String) async throws -> T
    func getImage(url: String) async throws -> UIImage
}

class ImageNetwork: ImageDef{
    // MARK: Properties
    
    static let sharedInstance = ImageNetwork()
    let urlSession: URLSession
    var imageCache = NSCache<NSString, UIImage>()
    
    //MARK: INitialization
    private init() {
        let config = URLSessionConfiguration.default
        self.urlSession = URLSession(configuration: config)
    }
    
    //MARK: Function to fetch data
    func getData<T:Codable>(url:String) async throws -> T {
        guard let serverURL = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await urlSession.data(from: serverURL)
        let decoded = try JSONDecoder().decode(T.self, from: data)
        return decoded
        
    }
                            
    //MARK: Function to fetchImages
    func getImage(url: String) async throws -> UIImage {
        if let cachedImage = imageCache.object(forKey: url as NSString){
            return cachedImage
        }
        
        guard let serverURL = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await urlSession.data(from: serverURL)
        guard let image = UIImage(data: data) else {
            throw NetworkError.invvalidImageData
        }
        imageCache.setObject(image, forKey: serverURL.absoluteString as NSString)
        return image
    }
}
