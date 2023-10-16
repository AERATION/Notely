import UIKit

class NoteScrollContentView: UIView {
    
    //MARK: - Properties
    private let titleInputField: UITextField = {
        let titleInputField = UITextField()
        
        titleInputField.placeholder = "Заголовок"
        titleInputField.font = UR.Font.largeTitle
        
        return titleInputField
    }()
    
    private var noteTextInputField: NoteTextInputField!
    private var infoView: NoteInfoView!
    
    //MARK: - Lifecycle methods
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    //MARK: - Private methods
    private func configure() {
        infoView = NoteInfoView()
        noteTextInputField = NoteTextInputField()
        
        self.addSubview(titleInputField)
        self.addSubview(infoView)
        self.addSubview(noteTextInputField)
        
        titleInputField.delegate = self
        noteTextInputField.delegate = self
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    func getNoteTextInputField() -> NoteTextInputField {
        return noteTextInputField
    }
    
    func getTitleInputField() -> UITextField {
        return titleInputField
    }
    
    func getInfoView() -> NoteInfoView {
        return infoView
    }
}

//MARK: - Extensions
extension NoteScrollContentView {
    private func makeConstraints() {
        titleInputField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalToSuperview()
            make.height.equalTo(60)
        }
        
        infoView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(titleInputField.snp.bottom).offset(8)
            make.height.equalTo(24)
        }
        
        noteTextInputField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(infoView.snp.top).offset(32)
            make.bottom.equalToSuperview()
        }
    }
}

//MARK: - Set character limit
//TODO: - Remove magic numbers
extension NoteScrollContentView: UITextFieldDelegate, UITextViewDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 50
        let currentString = textField.text ?? ""
        guard let stringRange = Range(range, in: currentString) else { return false}
        let newString = currentString.replacingCharacters(in: stringRange, with: string)
        return newString.count <= maxLength
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxLength = 50000
        let currentString = textView.text ?? ""
        guard let stringRange = Range(range, in: currentString) else { return false}
        let newString = currentString.replacingCharacters(in: stringRange, with: text)
        return newString.count <= maxLength
    }
}
