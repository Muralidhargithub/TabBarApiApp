//
//  CustomTableView.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//



//
//  CustomTableView.swift
//  ApiParsingMVVM
//
//  Created by Muralidhar reddy Kakanuru on 12/5/24.
//


import UIKit

class CustomTableView: UIView {
    
    private let viewModel = StocksViewModel()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        bindViewModel()
        viewModel.fetchStocks()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        addSubview(tableView)
        tableView.register(CustomTableViewCellstock.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.didUpdateData = { [weak self] in
            DispatchQueue.main.async{
                self?.tableView.reloadData()
            }
        }
    }
}

extension CustomTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CustomTableViewCellstock else {
            return UITableViewCell()
        }
        let article = viewModel.getArticle(at: indexPath.row)
                cell.configure(with: article)
                return cell
            }
}

