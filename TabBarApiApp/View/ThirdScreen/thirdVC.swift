//
//  thirdVC.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//

import UIKit

class thirdVC: UIViewController {

    let tableView = SubscriberController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        view.largeContentTitle = "Subscriber App"
    }
    func setUp(){
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }


}
