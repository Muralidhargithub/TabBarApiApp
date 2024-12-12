//
//  ArticleDetailViewController.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//


import UIKit

class ArticleDetailViewController: UIViewController {
    var viewModel: ArticleDetailViewModel?

    private let imageView = UIImageView()
    private let detailsLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Article Details"
        view.backgroundColor = .white
        setupUI()
        bindData()
    }

    private func setupUI() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        detailsLabel.numberOfLines = 0
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(detailsLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            detailsLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func bindData() {
        guard let viewModel = viewModel else { return }
        
        detailsLabel.text = viewModel.articleDetails
        
        if let url = viewModel.articleImageURL {
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.imageView.image = image
                        }
                    }
                } catch {
                    print("Failed to load image: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(named: "placeholder") 
                    }
                }
            }
        }
    }
}
