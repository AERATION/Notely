import UIKit
import FirebaseFirestore

protocol NoteCellPublicDelegate {
    func profilePressed(_ profileId: String?)
}

class NoteCellPublic: UICollectionViewCell {
    
    static let reuseIdentifier = "NoteCellPublic"
    
    // MARK: UIElements
    private let lockImageView: UIImageView = {
        var imageView = UIImageView()
        let image = UIImage(named: "lock.svg")
        image?.withTintColor(UR.Color.blue ?? .lightGray, renderingMode: .automatic)
        imageView.image = image
        imageView.isHidden = true
        return imageView
    }()
    
    private let noteTitle: UILabel = {
        var label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UR.Font.smallTitle
        return label
    }()
    
    private let noteContent: UILabel = {
        var label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UR.Font.main15
        return label
    }()
    
    private let userInfo: UserLabel = {
        var label = UserLabel()
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let creationDate: UILabel = {
        var label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .right
        label.font = UR.Font.main14
        label.textColor = UR.Color.superDrakGray
        return label
    }()
    
    var delegate: NoteCellPublicDelegate?
    
    var noteObject: NoteData? {
        didSet {
            setupData()
        }
    }
    
    // MARK: Inits
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup functions
    private func setupData() {
        guard let note = noteObject else {
            return
        }
        
        noteTitle.text = note.title
        noteContent.text =  note.noteText
        
        
        //TODO: set from note.userName
        userInfo.userIcon.setUserLabel(textFont: UIFont.systemFont(ofSize: 10), userFirstName: note.userFirstName ?? "", userLastName: note.userLastName ?? "")
        userInfo.userIcon.backgroundColor = UR.Color.superDrakGray ?? UIColor(named: "super-dark-gray")
        userInfo.userName.text = (note.userFirstName ?? "a") + " " + (note.userLastName ?? "a")
        
        creationDate.text = DateFormatter().getFormattedDateToString(date: note.dateOfCreation?.dateValue() ?? Date())
    }
    
    private func setupView() {
        contentView.layer.cornerRadius = UR.Constants.cornerRadius
        contentView.backgroundColor = UR.Color.superLightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandller))
        userInfo.isUserInteractionEnabled = true
        userInfo.addGestureRecognizer(tap)
        
        addSubviews()
        setupConstraints()
    }
    
    @objc func tapHandller() {
        delegate?.profilePressed(noteObject?.user?.documentID)
    }
    
    private func addSubviews() {
        contentView.addSubview(noteTitle)
        contentView.addSubview(lockImageView)
        contentView.addSubview(noteContent)
        contentView.addSubview(userInfo)
        contentView.addSubview(creationDate)
    }
    
    private func setupConstraints() {
        
        lockImageView.snp.makeConstraints{ make in
            make.leading.equalTo(noteTitle.snp.trailing).offset(16)
            make.top.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(16)
        }
        
        noteTitle.snp.makeConstraints{ make in
            make.leading.top.equalToSuperview().offset(16)
        }
        
        noteContent.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(noteTitle.snp.bottom).offset(5)
        }
        
        userInfo.snp.makeConstraints{ make in
            make.leading.bottom.equalToSuperview().inset(16)
            make.top.equalTo(noteContent.snp.bottom).offset(10)
        }
        
        creationDate.snp.makeConstraints{ make in
            make.bottom.trailing.equalToSuperview().inset(16)
            make.top.equalTo(noteContent.snp.bottom).offset(10)
            make.leading.equalTo(userInfo.snp.trailing)
        }
    }
}
