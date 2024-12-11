import UIKit

class CustomTableViewCellstock: UITableViewCell {
    
    private let viewModel = StocksViewModel()
    private var currentImageURL: String? // Track the image URL for this cell

    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit // Maintain aspect ratio
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        contentView.addSubview(articleImageView)
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            articleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            articleImageView.heightAnchor.constraint(equalTo: articleImageView.widthAnchor, multiplier: 0.75), // Maintain aspect ratio

            label.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with article: stockArticle) {
        // Reset placeholder
        currentImageURL = nil
        articleImageView.image = UIImage(named: "placeholder")

        // Configure text
        let text = """
        Source ID: \(article.source.id ?? "N/A")
        Source Name: \(article.source.name ?? "N/A")
        Author: \(article.author ?? "N/A")
        Title: \(article.title ?? "No Title")
        Description: \(article.description ?? "No Description")
        Published At: \(formattedDate(from: article.publishedAt) ?? "Unknown Date")
        Content: \(article.content ?? "No Content")
        """
        label.text = text

        // Configure image
        if let imageUrl = article.urlToImage {
            currentImageURL = imageUrl
            viewModel.getImage(for: imageUrl) { [weak self] image in
                guard let self = self, self.currentImageURL == imageUrl else { return }
                DispatchQueue.main.async {
                    self.articleImageView.image = image ?? UIImage(named: "placeholder")
                }
            }
        }
    }

    private func formattedDate(from isoDate: String?) -> String? {
        guard let isoDate = isoDate else { return nil }
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd-MM-yyyy"
            return outputFormatter.string(from: date)
        }
        return nil
    }
}
