//
//  NetworkManagerAPi.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//


import Foundation
import UIKit

// Protocol for fetching data and images
protocol ImageDef {
    func getData<T: Codable>(url: String) async throws -> T
    func getImage(url: String) async throws -> UIImage
}

class ImageNetwork: ImageDef {
    // MARK: Properties
    
    static let sharedInstance = ImageNetwork()
    private let urlSession: URLSession
    private var imageCache = NSCache<NSString, UIImage>()
    
    // MARK: Initialization
    private init() {
        let config = URLSessionConfiguration.default
        self.urlSession = URLSession(configuration: config)
    }
    
    // MARK: Function to fetch data
    func getData<T: Codable>(url: String) async throws -> T {
        guard let serverURL = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await urlSession.data(from: serverURL)
        
        // Check for valid response 
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        // Decode JSON data
        let decoded = try JSONDecoder().decode(T.self, from: data)
        return decoded
    }
    
    // MARK: Function to fetch Images with caching
    func getImage(url: String) async throws -> UIImage {
        // Check if the image is already cached
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            return cachedImage
        }
        
        guard let serverURL = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        // Fetch the image data
        let (data, response) = try await urlSession.data(from: serverURL)
        
        // Check for valid response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        guard let image = UIImage(data: data) else {
            throw NetworkError.invvalidImageData
        }
        
        // Cache the image for future use
        imageCache.setObject(image, forKey: serverURL.absoluteString as NSString)
        
        return image
    }
}
