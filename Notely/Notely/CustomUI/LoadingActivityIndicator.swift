import UIKit

class LoadingIndicator: UIActivityIndicatorView {
    
    //MARK: - Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupActivityIndicator()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func setupActivityIndicator() {
        color = UR.Color.darkGray
        style = .large
        startAnimating()
        isHidden = true
    }
    
}
