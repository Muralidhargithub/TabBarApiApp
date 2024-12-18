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
        let dispatchGroup = DispatchGroup()
        var validatedTabs: [UIViewController] = []
        var encounteredError: Error? = nil
        let typeMap: [Decodable.Type] = [Subscriber.self, [Photo].self, Article.self]

        DispatchQueue.global(qos: .userInitiated).async {
            for (index, (url, title)) in self.endpoints.enumerated() {
                dispatchGroup.enter()

                do {
                    if let targetType = typeMap[index] as? Decodable.Type {
                        try self.fetchAndValidateDataSync(url: url, type: targetType)
                    }

                    DispatchQueue.main.async {
                        let viewController = self.getViewController(for: index)
                        let navVC = UINavigationController(rootViewController: viewController)
                        navVC.tabBarItem = UITabBarItem(
                            title: title,
                            image: UIImage(systemName: "\(index + 1).circle"),
                            tag: index
                        )
                        validatedTabs.append(navVC)
                        self.viewControllers = validatedTabs
                    }
                } catch let error {
                    encounteredError = error

                    DispatchQueue.main.async {
                        if index == 0 {
                            self.viewControllers = []
                        }
                        self.showErrorAlert(for: title, error: error)
                    }
                    break
                }

                dispatchGroup.leave()
                dispatchGroup.wait()
            }

            dispatchGroup.notify(queue: .main) {
                if let error = encounteredError {
                    print("Validation stopped due to error: \(error.localizedDescription)")
                }
            }
        }
    }
    private func getViewController(for index: Int) -> UIViewController {
        switch index {
        case 0:
            return thirdVC()
        case 1:
            return FirstVC()
        case 2:
            return ArticleListVC()
        default:
            return UIViewController()
        }
    }


    private func fetchAndValidateDataSync<T: Decodable>(url: String, type: T.Type) throws {
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<T, Error>!

        Task {
            do {
                let data = try await ImageNetwork.sharedInstance.getData(url: url) as T
                result = .success(data)
            } catch {
                result = .failure(error)
            }
            semaphore.signal()
        }

        semaphore.wait()

        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        case .none:
            throw NetworkError.invalidData
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
