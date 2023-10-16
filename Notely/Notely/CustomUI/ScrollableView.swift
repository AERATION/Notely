import Foundation
import UIKit
import SnapKit

class ScrollableView: UIView, UITextViewDelegate {
    
    //MARK: - Properties
    private let errorLabel: UILabel = UILabel()
    
    private let nameWindowLabel: UILabel = UILabel()
    
    private var textViewIsEditing: Bool = false
    
    var scrollableTextView = ScrollableTextView()
    
    //MARK: - Initializations
    init(textLabel: String) {
        super.init(frame: .zero)
        setupNameWindowLabel(textNameLabel: textLabel)
        setupErrorTextLabel()
        configure()
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func configure() {
        self.addSubview(scrollableTextView)
        self.addSubview(errorLabel)
        self.addSubview(nameWindowLabel)

        scrollableTextView.delegate = self
        makeConstrains()
    }
    
    private func setupNameWindowLabel(textNameLabel: String) {
        nameWindowLabel.text = textNameLabel
        nameWindowLabel.textColor = UR.Color.darkGray
        nameWindowLabel.font = UR.Font.main15
    }
    
    private func setupErrorTextLabel() {
        errorLabel.textColor = UR.Color.red
        errorLabel.font = UR.Font.main14
        errorLabel.text = "Некорректный ввод"
        errorLabel.isHidden = false
    }
    
    //MARK: - Methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderColor = UR.Color.darkBlue.cgColor
        textViewIsEditing = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderColor = UR.Color.lightGray?.cgColor
        textViewIsEditing = false
    }
    
    func getTextViewIsEditing() -> Bool { return textViewIsEditing }
    
    func getScrollableTextView() -> ScrollableTextView { return scrollableTextView }
    
    func setErrorText(error: String) {
        errorLabel.text = error
    }
    
    func setErrorStatus(status: Bool) {
        errorLabel.isHidden = status
    }
}

class ScrollableTextView: UITextView {
    
    //MARK: - Initializations
    init() {
        super.init(frame: .zero, textContainer: .none)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func configure() {
        font = .systemFont(ofSize: 16)
        textColor = UR.Color.black
        backgroundColor = UR.Color.superLightGray
        layer.borderWidth = 1
        layer.borderColor = UR.Color.lightGray?.cgColor
        layer.cornerRadius = 10
        textContainer.maximumNumberOfLines = 8
        isScrollEnabled = true
        isUserInteractionEnabled = true
        textContainerInset = .init(top: 10, left: 15, bottom: 0, right: 15)
    }
}


//MARK: - Layout
private extension ScrollableView {
    private func makeConstrains() {
        nameWindowLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(8.0)
            make.leading.equalTo(self.snp.leading)
            make.height.equalTo(18.0)
        }
        
        scrollableTextView.snp.makeConstraints { make in
            make.top.equalTo(nameWindowLabel.snp.bottom).offset(8.0)
            make.leading.equalTo(self.snp.leading)
            make.height.equalTo(64)
            make.trailing.equalTo(self.snp.trailing)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(scrollableTextView.snp.bottom).offset(8.0)
            make.leading.equalTo(self.snp.leading)
            make.height.equalTo(18.0)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
}

