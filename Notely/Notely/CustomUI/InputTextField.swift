import UIKit

class InputTextField: UITextField {
    
    //MARK: - Properties
    private let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 40)
    var errorTextLabel = UILabel()
    private let nameLabel = UILabel()
    
    //MARK: - Initisalizations
    init(placeholder: String, textLabel: String) {
        super.init(frame: .zero)
        setupTextField(placeholder: placeholder)
        setupErrorTextLabel()
        setupNameLabel(textLabel: textLabel)
        configure(placeholder: placeholder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override methods
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    //MARK: - Private methods
    private func configure(placeholder: String) {
        self.addSubview(errorTextLabel)
        self.addSubview(nameLabel)
        self.addTarget(self, action: #selector(beginInputTextField(sender: )), for: .editingDidBegin)
        self.addTarget(self, action: #selector(endInputTextField(sender: )), for: .editingDidEnd)
        self.placeholder = placeholder
        makeConstrains()
    }
    
    private func setupErrorTextLabel() {
        errorTextLabel.textColor = UR.Color.red
        errorTextLabel.font = UR.Font.main14
        errorTextLabel.text = ""
    }
    
    private func setupNameLabel(textLabel: String) {
        nameLabel.text = textLabel
        nameLabel.textColor = UR.Color.darkGray
        nameLabel.font = UR.Font.main15
    }
    
    private func setupTextField(placeholder: String) {
        backgroundColor = UR.Color.superLightGray
        layer.borderWidth = 1
        layer.borderColor = UR.Color.lightGray?.cgColor
        layer.cornerRadius = 10
    }
    
}
//MARK: - Settings
private extension InputTextField {
    
    @objc func beginInputTextField(sender: UITextField) {
        sender.layer.borderColor = UR.Color.blue?.cgColor
    }
    
    @objc func endInputTextField(sender: UITextField) {
        sender.layer.borderColor = UR.Color.lightGray?.cgColor
    }
}

//MARK: - Layout
private extension InputTextField {
    private func makeConstrains() {
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.top).offset(-8.0)
            make.leading.equalTo(self.snp.leading)
            make.height.equalTo(18.0)
        }
        
        errorTextLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom).offset(4.0)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(18.0)
        }
    }
}
