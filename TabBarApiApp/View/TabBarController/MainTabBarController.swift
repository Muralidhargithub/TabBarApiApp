//
//  NetworkManager.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/17/24.
//


import UIKit
import Foundation


// MARK: - MainTabBarController with Sequential API Validation
class MainTabBarController: UITabBarController {
    
    private let endpoints = [
        (commonUrl.subscriber, "Subscribers"),
        (commonUrl.photos, "Photo"),
        (commonUrl.article, "Article")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validateAPIsSequentiallyAndSetupTabs()
    }
    
    func validateAPIsSequentiallyAndSetupTabs() {
        Task {
            var validatedTabs: [UIViewController] = []
            let typeMap: [Decodable.Type] = [Subscriber.self, [Photo].self, Article.self]
            
            for (index, (url, title)) in endpoints.enumerated() {
                do {
                    if let targetType = typeMap[index] as? Decodable.Type {
                        try await fetchAndValidateData(url: url, type: targetType)
                        
                        
                        // If successful, add the corresponding tab
                        let viewController = getViewController(for: index)
                        let navVC = UINavigationController(rootViewController: viewController)
                        navVC.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: "\(index + 1).circle"), tag: index)
                        validatedTabs.append(navVC)
                        
                        // Update the UI with validated tabs so far
                        DispatchQueue.main.async {
                            self.viewControllers = validatedTabs
                        }
                    }
                    
                } catch {
                    // Show an error alert and stop further processing only if the first API fails
                    DispatchQueue.main.async {
                        self.showErrorAlert(for: title, error: error)
                        if index == 0 {
                            self.viewControllers = [] // Clear all tabs if the first API fails
                        }
                    }
                    break 
                }
            }
        }
    }
    
    func fetchAndValidateData<T: Decodable>(url: String, type: T.Type) async throws {
        _ = try await ImageNetwork.sharedInstance.getData(url: url) as T
    }
    
    private func getViewController(for index: Int) -> UIViewController {
        switch index {
        case 0: return thirdVC()        // Subscribers
        case 1: return FirstVC()        // Photos
        case 2: return ArticleListVC()  // Articles
        default: return UIViewController()
        }
    }
    
    private func showErrorAlert(for tabName: String, error: Error) {
        let alert = UIAlertController(
            title: "API Error",
            message: "Failed to load data for \(tabName). Error: \(error.localizedDescription)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
