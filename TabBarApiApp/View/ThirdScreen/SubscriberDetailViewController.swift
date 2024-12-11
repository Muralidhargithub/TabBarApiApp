//
//  SubscriberDetailViewController.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//


//
//  SubscriberDetailViewController.swift
//  SubscriberApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//


import UIKit

class SubscriberDetailViewController: UIViewController {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    var subscriberDetails: SubscriberDetails?
    var imageLoader: ((String) async -> UIImage?)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configureDetails()
    }

    private func setupUI() {
        view.addSubview(imageView)
        view.addSubview(detailsLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),

            detailsLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func configureDetails() {
        guard let details = subscriberDetails else { return }

        detailsLabel.text = """
        ID: \(details.id ?? 0)
        Email: \(details.email ?? "")
        First Name: \(details.first_name ?? "")
        Last Name: \(details.last_name ?? "")
        """

        if let avatarURL = details.avatar {
            Task {
                let image = await imageLoader?(avatarURL)
                DispatchQueue.main.async {
                    self.imageView.image = image ?? UIImage(named: "placeholder")
                }
            }
        }
    }
}
