//
//  ArticleListTableViewCell.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//



import UIKit

class ArticleListTableViewCell: UITableViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCell() {
        contentView.addSubview(label)
        contentView.addSubview(articleImageView)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints for articleImageView
        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            articleImageView.widthAnchor.constraint(equalToConstant: 100),
            articleImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Constraints for label
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            label.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    func configure(with article: ArticleDetails) {
        let text = """
        Author: \(article.author ?? "")
        Title: \(article.title ?? "")
        Published At: \(article.publishedAt ?? "")
        """
        label.text = text
        
        guard let url = URL(string: article.urlToImage ?? "") else {
                articleImageView.image = UIImage(named: "placeholder")
                return
            }
        
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                guard let image = UIImage(data: data) else {
                    throw NetworkError.invalidData
                }
                
                DispatchQueue.main.async {
                    self.articleImageView.image = image
                }
            } catch {
                DispatchQueue.main.async {
                    self.articleImageView.image = UIImage(named: "placeholder")
                }
            }
        }
    }
}
