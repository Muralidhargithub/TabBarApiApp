//
//  FirstVC.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//

import UIKit

class FirstVC: UIViewController {

    let tableView = PhotoController()

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
