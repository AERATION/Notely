import UIKit

class FolderLabel: UIView {
    // MARK: UIElements
    var folderIcon: UIImageView = {
        var icon = UIImageView()
        icon.image = UR.Icons.smallFolderIcon
        icon.tintColor = UR.Color.superDrakGray
        icon.alpha = 0.6
        return icon
    }()
    
    var folderName: UILabel = {
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
        self.addSubview(folderIcon)
        self.addSubview(folderName)
    }
    
    private func setupConstraints() {
        folderIcon.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(15)
            make.width.equalTo(16)
        }
        
        folderName.snp.makeConstraints{ make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(folderIcon.snp.trailing).offset(5)
            make.trailing.equalToSuperview()
        }
    }
    
}
