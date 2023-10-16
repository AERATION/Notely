import UIKit

class NoteTextInputField: UITextView {
    
    //MARK: Properties
    let placeholder: UILabel = {
        let label = UILabel()
        label.text = "Введите текст..."
        label.textColor = .lightGray
        label.font = UR.Font.noteText
        return label
    }()
    
    //MARK: - Lifecycle methods
    init() {
        super.init(frame: CGRectZero, textContainer: .none)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func configure() {
        self.font = UR.Font.noteText
        self.textColor = .black
        self.textContainer.lineFragmentPadding = 0
        self.isScrollEnabled = false
        self.addSubview(placeholder)
        makeConstraints()
    }
}

//MARK: - Extension
extension NoteTextInputField {
    func makeConstraints() {
        placeholder.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview()
        }
    }
}
