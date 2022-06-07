import UIKit

final class EmptyDataView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupFromXib()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupFromXib()
    }
}
