import UIKit

class UserLabel: UIView {
    // MARK: UIElements
    var userIcon = UserView()
    
    var userName: UILabel = {
        var label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UR.Font.main14
        label.textColor = UR.Color.superDrakGray
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
    
    // MARK: Setup functions
    private func setupView() {
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        self.addSubview(userIcon)
        self.addSubview(userName)
    }
    
    private func setupConstraints() {
        userIcon.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(16)
            make.width.equalTo(16)
        }
        
        userName.snp.makeConstraints{ make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(userIcon.snp.trailing).offset(5)
            make.trailing.equalToSuperview()
        }
    }
    
}
