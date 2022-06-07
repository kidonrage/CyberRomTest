import UIKit

final class ImageCache {
    
    static let shared = ImageCache()
    
    private let defaultSession = URLSession(configuration: .default)
    private let cache = NSCache<NSString, UIImage>()
    
    func image(for url: URL, _ completion: @escaping (ImageFetchingResult) -> Void) -> URLSessionDataTask? {
        if let imageInCache = self.cache.object(forKey: url.absoluteString as NSString)  {
            completion(.success(image: imageInCache))
            return nil
        }
        
        let imageFetchingTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data,
                  let networkResponse = response as? HTTPURLResponse,
                  networkResponse.statusCode == 200,
                  let image = UIImage(data: data)
            else {
                completion(.failure)
                return
            }
            
            self?.cache.setObject(image, forKey: url.absoluteString as NSString)
            completion(.success(image: image))
        }
        
        imageFetchingTask.resume()
        
        return imageFetchingTask
    }
}

extension ImageCache {
    
    enum ImageFetchingResult {
        case success(image: UIImage)
        case failure
    }
}
