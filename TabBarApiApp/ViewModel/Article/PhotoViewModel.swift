import UIKit

class PhotoViewModel {
    // MARK: - Dependencies
    private let photoService: ImageDef = ImageNetwork.sharedInstance

    // MARK: - Properties
    private var photos: [Photo] = []
    private var imageCache = NSCache<NSURL, UIImage>()
    private let cacheQueue = DispatchQueue(label: "com.app.imageCache", attributes: .concurrent)

    // MARK: - Closures for Updates
    var onPhotosFetchSuccess: (() -> Void)?
    var onPhotosFetchFailure: ((String) -> Void)?

    // MARK: - Fetch Photos
    func fetchPhotos() async {
        guard let url = URL(string: commonUrl.photos) else {
            onPhotosFetchFailure?("Invalid URL")
            return
        }

        do {
            let fetchedPhotos: [Photo] = try await photoService.getData(from: url.absoluteString, decodingType: [Photo].self )
            DispatchQueue.main.async {
                self.photos = fetchedPhotos
                self.onPhotosFetchSuccess?()
            }
        } catch {
            DispatchQueue.main.async {
                self.onPhotosFetchFailure?("Failed to fetch data: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Accessors
    func numberOfRows() -> Int {
        return photos.count
    }

    func photo(at index: Int) -> Photo? {
        guard index >= 0 && index < photos.count else { return nil }
        return photos[index]
    }

    // MARK: - Load Image
    func loadImage(from url: URL) async -> UIImage? {
        // Read from cache safely
        if let cachedImage = cacheQueue.sync(execute: { imageCache.object(forKey: url as NSURL) }) {
            return cachedImage
        }

        do {
            let image = try await photoService.getImage(url: url.absoluteString)
            // Write to cache safely
            cacheQueue.async(flags: .barrier) {
                self.imageCache.setObject(image, forKey: url as NSURL)
            }
            return image
        } catch {
            print("Failed to load image: \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - Photo Details
    func getPhotoDetails(at index: Int) -> (photo: Photo, loadImage: (@escaping (UIImage?) -> Void) -> Void)? {
        guard let selectedPhoto = photo(at: index) else { return nil }

        let loadImage: (@escaping (UIImage?) -> Void) -> Void = { [weak self] completion in
            guard let self = self, let urlString = selectedPhoto.url, let url = URL(string: urlString) else {
                print("Invalid URL for photo at index \(index)")
                completion(nil)
                return
            }

            Task {
                if let image = await self.loadImage(from: url) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }

        return (photo: selectedPhoto, loadImage: loadImage)
    }
}
