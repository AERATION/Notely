import UIKit

class SplashSegmentedControl: UISegmentedControl {

    //MARK: - Properties
    let items = ["Авторизация","Регистрация"]
    
    //MARK: - Initializations
    init() {
        super.init(items: items)
        setupSegmentedControl()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func setupSegmentedControl() {
        let segmentAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0),
            NSAttributedString.Key.foregroundColor: UR.Color.black
        ]

        self.selectedSegmentIndex = 0
        self.layer.cornerRadius = 5
        self.setTitleTextAttributes(segmentAttributes as [NSAttributedString.Key : Any], for: .normal)
        self.backgroundColor = UR.Color.superLightGray
    }
}
