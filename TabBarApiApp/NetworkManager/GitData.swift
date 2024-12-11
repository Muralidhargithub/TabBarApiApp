//
//  GitData.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//


//
//  GitData.swift
//  ApiParsingMVVM
//
//  Created by Muralidhar reddy Kakanuru on 12/5/24.
//


import Foundation
import UIKit

protocol GitData {
    func getData<T: Decodable>(url: String, completion: @escaping @Sendable (T) -> ())
    func getImage(url: String, completion: @escaping (UIImage?) -> Void)
}

final class DataGit: GitData {

    static let shared = DataGit()
    private let urlSession: URLSession
    private var imageCache = NSCache<NSString, UIImage>()

    private init() {
        let config = URLSessionConfiguration.default
        self.urlSession = URLSession(configuration: config)
    }

    func getData<T: Decodable>(url: String, completion: @escaping @Sendable (T) -> Void) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }

        urlSession.dataTask(with: url) {data, _, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
               // DispatchQueue.main.async {
                    completion(decoded)
               // }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }

    func getImage(url: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            completion(cachedImage)
            return
        }

        guard let url = URL(string: url) else {
            print("Invalid Image URL")
            completion(nil)
            return
        }

        urlSession.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to load image data")
                completion(nil)
                return
            }

            self?.imageCache.setObject(image, forKey: url.absoluteString as NSString)

            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
