//
//  SecondVC.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//

import UIKit

class SecondVC: UIViewController {

    private let customTableView = CustomTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    private func setUpUI() {
        customTableView.frame = view.bounds
        view.addSubview(customTableView)
    }
}

