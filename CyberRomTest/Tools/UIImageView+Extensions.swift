import UIKit

extension UIImageView {
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                guard let data = data else {
                    return
                }
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }).resume()
        }
    }
}
