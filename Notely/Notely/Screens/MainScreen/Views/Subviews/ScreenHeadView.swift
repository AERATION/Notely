import UIKit

protocol ScreenHeadViewDelegate {
    func personPressed()
    func actionsPressed()
}

class ScreenHeadView: UIView {
    // MARK: UIElements
    var screenTitle: UILabel = {
        var label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UR.Font.largeTitle
        label.text = "Notely"
        return label
    }()
    
    var personButton: UIButton = {
        var button = UIButton()
        button.setImage(UR.Icons.personIcon, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    var actionsButton: UIButton = {
        var button = UIButton()
        button.setImage(UR.Icons.roundDotsIcon, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    var delegate: ScreenHeadViewDelegate?
    
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
        addTargets()
    }
    
    private func addSubviews() {
        self.addSubview(screenTitle)
        self.addSubview(personButton)
        self.addSubview(actionsButton)
    }
    
    private func setupConstraints() {
        screenTitle.snp.makeConstraints{ make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        actionsButton.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(33)
            make.width.equalTo(actionsButton.snp.height)
        }
        
        personButton.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(actionsButton.snp.leading).offset(-15)
            make.leading.equalTo(screenTitle.snp.trailing)
            make.height.equalTo(33)
            make.width.equalTo(personButton.snp.height)
        }
    }
}

extension ScreenHeadView {
    private func addTargets() {
        personButton.addTarget(self, action: #selector(personPressed), for: .touchUpInside)
        actionsButton.addTarget(self, action: #selector(actionsPressed), for: .touchUpInside)
    }
    
    @objc private func personPressed(){
        delegate?.personPressed()
    }
    
    @objc private func actionsPressed(){
        delegate?.actionsPressed()
    }
}
