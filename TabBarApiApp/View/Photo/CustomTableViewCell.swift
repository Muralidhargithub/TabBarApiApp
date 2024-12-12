import UIKit

class CustomTableViewCell: UITableViewCell {
    // MARK: - UI Components
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit // Maintain aspect ratio
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Properties
    private var currentPhotoID: Int? // Track the associated photo ID for reuse handling

    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: 0.25), // Maintain aspect ratio

            titleLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil // Reset the image to avoid displaying stale data
        currentPhotoID = nil       // Reset the ID to prevent mismatches
    }

    // MARK: - Configure Cell
    func configure(with photo: Photo, loadImage: @escaping (@escaping (UIImage?) -> Void) -> Void) {
        titleLabel.text = photo.title
        currentPhotoID = photo.id

        // Load image asynchronously using the provided closure
        loadImage { [weak self] image in
            guard let self = self else { return }
            // Ensure the cell is still displaying the correct photo
            if self.currentPhotoID == photo.id {
                self.updateImage(image)
            }
        }
    }

    // MARK: - Update Image
    private func updateImage(_ image: UIImage?) {
        DispatchQueue.main.async {
            self.photoImageView.image = image ?? UIImage(named: "placeholder") // Fallback to placeholder
        }
    }
}
