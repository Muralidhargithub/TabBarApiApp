//
//  SubscriberController.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//




import UIKit

class SubscriberController: UIView {
    // MARK: - Properties
    private var viewModel = SubscriberViewModel()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        bindViewModel()
        Task {
            await viewModel.fetchSubscribers()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setup() {
        self.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
        tableView.register(SubscriberCustomTableViewCell.self, forCellReuseIdentifier: "cell")

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.onFetchSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        viewModel.onFetchFailure = { errorMessage in
            DispatchQueue.main.async {
                print("Error: \(errorMessage)")
                // Handle UI updates for errors, e.g., show an alert
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension SubscriberController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.subscribers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SubscriberCustomTableViewCell else {
            return UITableViewCell()
        }

        let cellData = viewModel.getCellData(for: indexPath.row)
        cell.configure(text: cellData.text, avatarURL: cellData.avatarURL) { avatarURL in
            return await self.viewModel.loadImage(from: avatarURL)
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension SubscriberController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subscriber = viewModel.subscribers[indexPath.row]
        let detailVC = SubscriberDetailViewController()
        detailVC.subscriberDetails = subscriber
        detailVC.imageLoader = { [weak self] avatarURL in
            return await self?.viewModel.loadImage(from: avatarURL)
        }

        if let parentViewController = self.parentViewController {
            parentViewController.present(detailVC, animated: true)
        }
    }

}

// MARK: - Parent View Controller Extension
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
