import UIKit

class UserNoteLabel: UILabel {
    
    //MARK: - Initializations
    init(textLabel: String) {
        super.init(frame: .zero)
        setupUserNoteLabel(textLabel: textLabel)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func setupUserNoteLabel(textLabel: String) {
        text = textLabel
        numberOfLines = 3
        textColor = UR.Color.black
        font = UR.Font.main14
    }
}
