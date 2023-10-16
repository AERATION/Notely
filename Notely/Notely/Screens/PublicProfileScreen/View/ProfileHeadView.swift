import Foundation
import UIKit

class ProfileHeadView: UIView {
    // MARK: UIElements
    
    var avatar = UserView()
    
    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    var userName: UILabel = {
        var label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UR.Font.main17Semibold
        return label
    }()
    
    
    var noteCounter: UILabel = {
        var label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font =  UR.Font.main15
        label.textColor = UR.Color.darkGray
        
        return label
    }()
    
    var about: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font =  UR.Font.main14
        label.numberOfLines = 6
        return label
    }()
    
    
    // MARK: Inits
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNoteCount(_ count: Int){
        noteCounter.text = "\(count) заметок"
    }
    
    func setName(firstName: String, secondName: String){
        userName.text = "\(firstName) \(secondName)"
        avatar.setUserLabel(textFont:  UR.Font.main17Semibold, userFirstName: firstName, userLastName: secondName)
    }
    
    // MARK: Setup functions
    private func setupView() {
        addSubviews()
        setupConstraints()
        
        avatar.backgroundColor = .black
    }
    
    private func addSubviews() {
        self.addSubview(avatar)
        
        self.addSubview(stackView)
        stackView.addArrangedSubview(userName)
        stackView.addArrangedSubview(noteCounter)
        self.addSubview(about)
    }
    
    private func setupConstraints() {
        avatar.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.bottom.equalTo(about.snp.top)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(avatar.snp.height)
            make.height.equalTo(45)
        }
        
        stackView.snp.makeConstraints{ make in
            make.leading.equalTo(avatar.snp.trailing).offset(12)
            make.top.equalToSuperview()
            make.bottom.equalTo(about.snp.top)
            make.trailing.equalToSuperview().inset(16)
        }
        
        about.snp.makeConstraints{ make in
            make.top.equalTo(avatar.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().offset(26)
            make.bottom.equalToSuperview()
        }
    }
}

