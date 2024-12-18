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
        (commonUrl.photos, "Photo"),
        (commonUrl.subscriber, "Subscribers"),
        (commonUrl.article, "Article")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validateAPIsSequentiallyAndSetupTabs()
    }
    
    func validateAPIsSequentiallyAndSetupTabs() {
        Task{
            var validatedTabs: [UIViewController] = []
            for (index, (url, title)) in endpoints.enumerated() {
                if let _ = try? await ImageNetwork.sharedInstance.getData(from: url, decodingType: DummyResponse.self) {
                    let viewController = getViewController(for: index)
                    let navC = UINavigationController(rootViewController: viewController)
                    navC.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: "\(index + 1).circle"), tag: index)
                    validatedTabs.append(navC)
                }
                else {
                    showErrorAlert(for: title)
                    break
                }
            }
            
            DispatchQueue.main.async{
                self.viewControllers = validatedTabs
            }
            
        }
        
    }
    
    func getViewController(for index: Int) -> UIViewController {
        switch index {
        case 1: return thirdVC()
        case 0: return FirstVC()
        case 2: return ArticleListVC()
        default: return ViewController()
        }
    }
    
    private func showErrorAlert(for tabName: String) {
            let alert = UIAlertController(
                title: "API Error",
                message: "Failed to load data for \(tabName) tab.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
        }
    }
    
struct DummyResponse: Codable {}
