import UIKit

class RemoteImageView: UIImageView {
    
    var pendingLoadImageTask: URLSessionDataTask?
    
    func setImage(from url: URL?, placeholder: UIImage? = nil) {
        pendingLoadImageTask?.cancel()
        
        image = placeholder
        
        guard let url = url else {
            return
        }
        
        pendingLoadImageTask = ImageCache.shared.image(for: url) { [weak self] result in
            DispatchQueue.main.async {
                defer {
                    self?.pendingLoadImageTask = nil
                }
                
                switch result {
                case .success(let image):
                    self?.image = image
                case .failure:
                    break
                }
            }
        }
    }
}
