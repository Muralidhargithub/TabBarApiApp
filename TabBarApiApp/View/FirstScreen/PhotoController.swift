//
//  PhotoController.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//


import UIKit

class PhotoController: UIView {
    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        return tableView
    }()
    
    // MARK: - ViewModel
    private var viewModel = PhotoViewModel()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        bindViewModel()
        Task {
            await viewModel.fetchPhotos()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        bindViewModel()
        Task {
            await viewModel.fetchPhotos()
        }
    }

    // MARK: - Setup UI
    private func setup() {
        addSubview(tableView)
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.onPhotosFetchSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        viewModel.onPhotosFetchFailure = { errorMessage in
            DispatchQueue.main.async {
                print("Error: \(errorMessage)")
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension PhotoController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }

        if let photoDetails = viewModel.getPhotoDetails(at: indexPath.row) {
            cell.configure(with: photoDetails.photo) { completion in
                photoDetails.loadImage(completion)
            }
        }

        return cell
    }


}

// MARK: - UITableViewDelegate
extension PhotoController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = PhotoDetailViewController(viewModel: viewModel, photoIndex: indexPath.row)
        if let parentVC = self.parentViewController {
            parentVC.present(detailVC, animated: true, completion: nil)
        }
    }
}

// MARK: - UIView Extension
extension UIView {
    var parentViewController1: UIViewController? {
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
