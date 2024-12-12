//
//  SceneDelegate.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            guard let windowScene = (scene as? UIWindowScene) else { return }

            // Create a window
            window = UIWindow(windowScene: windowScene)

            // Create the tab bar controller
            let tabBarController = UITabBarController()

            // Create view controllers
            let PhotoVC = FirstVC()
            let SubscriberVC = thirdVC()
            let ArticleVC = ArticleListVC()
            let articleNavController = UINavigationController(rootViewController: ArticleVC)
            // Set tab bar items
            PhotoVC.tabBarItem = UITabBarItem(title: "Photos", image: UIImage(systemName: "star"), tag: 0)
            SubscriberVC.tabBarItem = UITabBarItem(title: "Subscribers", image: UIImage(systemName: "star.fill"), tag: 1)
            articleNavController.tabBarItem = UITabBarItem(title: "Articles", image: UIImage(systemName: "star"), tag: 2)


            // Set the view controllers for the tab bar controller
            tabBarController.viewControllers = [articleNavController, SubscriberVC,PhotoVC]

            // Set the window's root view controller
            window?.rootViewController = tabBarController
            window?.makeKeyAndVisible()
        }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

