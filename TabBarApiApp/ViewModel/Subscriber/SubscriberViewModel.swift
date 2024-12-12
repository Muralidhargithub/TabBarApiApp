//
//  SubscriberViewModel.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//


import Foundation
import UIKit

class SubscriberViewModel {
    // MARK: - Properties
    private let subscriberData: ImageDef
    private(set) var subscribers: [SubscriberDetails] = []
    private var imageCache: [URL: UIImage] = [:]
    
    var onFetchSuccess: (() -> Void)?
    var onFetchFailure: ((String) -> Void)?
    
    // MARK: - Initializer
    init(subscriberData: ImageDef = ImageNetwork.sharedInstance) {
        self.subscriberData = subscriberData
    }
    
    // MARK: - Fetch Subscribers
    func fetchSubscribers() async {
        let url = commonUrl.subscriber
        do {
            let result: Subscriber = try await subscriberData.getData(url: url)
            DispatchQueue.main.async {
                self.subscribers = result.data
                self.onFetchSuccess?()
            }
        } catch {
            print("Failed to fetch subscribers: \(error.localizedDescription)")
            self.onFetchFailure?("Failed to fetch subscribers")
        }
    }


    
    // MARK: - Load Image
    private let cacheQueue = DispatchQueue(label: "com.subscriberApp.imageCacheQueue")

    func loadImage(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return nil
        }

        if let cachedImage = cacheQueue.sync(execute: { imageCache[url] }) {
            print("Returning cached image for URL: \(urlString)")
            return cachedImage
        }

        do {
            let image = try await subscriberData.getImage(url: urlString)
            cacheQueue.async {
                self.imageCache[url] = image
            }
            print("Image successfully loaded for URL: \(urlString)")
            return image
        } catch {
            print("Failed to load image from URL: \(urlString). Error: \(error.localizedDescription)")
            return nil
        }
    }

    
    
    func getCellData(for index: Int) -> (text: String, avatarURL: String?) {
        guard index >= 0 && index < subscribers.count else {
            print("Index out of bounds: \(index)")
            return (text: "", avatarURL: nil)
        }
        
        let subscriber = subscribers[index]
        let text = """
    ID: \(subscriber.id ?? 0)
    \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n
    FirstName: \(subscriber.first_name ?? "")
    \n
    """
        return (text: text, avatarURL: subscriber.avatar)
    }
}
