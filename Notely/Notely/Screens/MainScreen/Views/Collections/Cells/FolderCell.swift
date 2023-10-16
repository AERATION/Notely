import UIKit

// TODO: not done
class FolderCell: UICollectionViewCell {
    static let reuseIdentifier = "FolderCell"
    
    var folderIcon: UIImageView = {
        var icon = UIImageView()
        icon.image = UR.Icons.folderIcon
        return icon
    }()
    
    var button: UIButton = {
        var button = UIButton()
        button.setImage(UR.Icons.dotsIcon, for: .normal)
        return button
    }()
    
    var folderName: UILabel = {
        var label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    var notesCounter: UILabel = {
        var label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    var folderObject: Folder? {
        didSet {
            setupData()
        }
    }
    
    private func setupData() {
        guard let note = folderObject else {
            return
        }
        
        folderName.text = note.name
        notesCounter.text = note.notesCounter.description
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        
        contentView.backgroundColor = UR.Color.superLightGray
        contentView.layer.cornerRadius = 11
        contentView.addSubview(folderIcon)
        contentView.addSubview(button)
        contentView.addSubview(folderName)
        contentView.addSubview(notesCounter)
        
        setupConstaints()
    }
    
    private func setupConstaints(){
        
        folderIcon.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(20)
            make.width.equalTo(22)
        }
        
        button.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        
        notesCounter.snp.makeConstraints{make in
            make.bottom.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
            make.left.equalToSuperview().offset(10)
        }
        
        folderName.snp.makeConstraints{make in
            make.bottom.equalTo(notesCounter.snp.top)
            make.right.equalToSuperview().inset(10)
            make.left.equalToSuperview().offset(10)
        }
        
    }
}
