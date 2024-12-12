//
//  PhotoDetailViewController.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//


//
//  PhotoDetailViewController.swift
//  ImageAppMvvm
//
//  Created by Muralidhar reddy Kakanuru on 12/10/24.
//


import UIKit

class PhotoDetailViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: PhotoViewModel
    private let photoIndex: Int
    
    // MARK: - UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializer
    init(viewModel: PhotoViewModel, photoIndex: Int) {
            self.viewModel = viewModel
            self.photoIndex = photoIndex
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureView()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Configure View
    private func configureView() {
        guard let details = viewModel.getPhotoDetails(at: photoIndex) else { return }
        let photo = details.photo
        
        descriptionLabel.text = """
            Photo ID: \(photo.id ?? 0)
            Album ID: \(photo.albumId ?? 0)
            Title: \(photo.title ?? "No Title")
            """
        
        details.loadImage { [weak self] image in
            self?.imageView.image = image ?? UIImage(named: "placeholder")
        }
    }
}
