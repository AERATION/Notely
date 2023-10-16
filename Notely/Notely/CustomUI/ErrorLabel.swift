
import Foundation
import UIKit

class ErrorLabel: UILabel {
    
    //MARK: - Initializations
    init(textLabel: String) {
        super.init(frame: .zero)
        setupErrorLabel(textLabel: textLabel)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func setupErrorLabel(textLabel: String) {
        font = UR.Font.main14
        textColor = UR.Color.red
        text = textLabel
        isHidden = true
    }
}
