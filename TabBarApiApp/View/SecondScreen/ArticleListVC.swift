//
//  ArticleListVC.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//


import UIKit

class ArticleListVC: UIViewController {
    
    private let viewModel = ArticleViewModel()
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bindViewModel()
        Task {
            await viewModel.fetchArticles()
        }
    }

    
    func setUp() {
        view.addSubview(tableView)
        tableView.register(ArticleListTableViewCell.self, forCellReuseIdentifier: "ArticleListTableViewCell")
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    
    func bindViewModel() {
        viewModel.onFetchSucess = {[weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension ArticleListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleListTableViewCell", for: indexPath) as? ArticleListTableViewCell else {
            return UITableViewCell()
        }
        
        let article = viewModel.articleData[indexPath.row]
        cell.configure(with: article)
        return cell
        
    }
}

extension ArticleListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = viewModel.articleData[indexPath.row]
        let articleDetailViewModel = ArticleDetailViewModel()
        articleDetailViewModel.setArticle(article)
        
        let articleDetailVC = ArticleDetailViewController()
        articleDetailVC.viewModel = articleDetailViewModel
        navigationController?.pushViewController(articleDetailVC, animated: true)
    }
}
