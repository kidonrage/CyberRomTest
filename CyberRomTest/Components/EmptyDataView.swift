import UIKit

final class EmptyDataView: UIView {
    
    // MARK: - Object Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupFromXib()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupFromXib()
    }
}
