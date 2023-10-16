import UIKit

protocol NoteCellPrivateDelegate {
    func deleteNote(_ note: NoteData)
    func moveFolder(_ note: NoteData)
    func makePublic(_ note: NoteData)
    func makePrivate(_ note: NoteData)
}

class NoteCellPrivate: UICollectionViewCell {
    
    static let reuseIdentifier = "NoteCellPrivate"
    
    // MARK: UIElements
    private let actionButton: UIButton = {
        var button = UIButton()
        button.showsMenuAsPrimaryAction = true
        button.setImage(UR.Icons.dotsIcon, for: .normal)
        return button
    }()
    
    private let globeImageView: UIImageView = {
        var imageView = UIImageView()
        let image = UIImage(named: "globe.svg")
        image?.withTintColor(UR.Color.blue ?? .lightGray, renderingMode: .automatic)
        imageView.image = image
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
    
    private let folderName: FolderLabel = {
        var label = FolderLabel()
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
    
    var delegate: NoteCellPrivateDelegate?
    
    var noteObject: NoteData? {
        didSet {
            setupData()
        }
    }
    
    private func getMenuItems() -> [UIAction] {
        let action: UIAction
        if noteObject!.isPublic {
            action = UIAction(title: "Сделать приватной", image: UIImage(systemName: "trash"), handler: makePrivateHandler)
        }else {
            action = UIAction(title: "Сделать публичной", image: UIImage(systemName: "trash"), handler: makePublicHandler)
        }
        
        return [
            action,
            UIAction(title: "Переместить", image: UIImage(systemName: "trash"), handler: moveHandler),
            UIAction(title: "Удалить..", image: UIImage(systemName: "trash"), attributes: .destructive, handler: deleteHandler)
        ]
    }
    
    func getItemMenu() -> UIMenu {
        return UIMenu(title: "Действия", image: nil, identifier: nil, options: [], children:  getMenuItems() )
    }
    
    func deleteHandler(_ action: UIAction) {
        guard let note = self.noteObject else {
            return
        }
        
        self.delegate?.deleteNote(note)
    }
    
    func moveHandler(_ action: UIAction) {
        guard let note = self.noteObject else {
            return
        }
        
        self.delegate?.moveFolder(note)
    }
    
    func makePublicHandler(_ action: UIAction) {
        guard let note = self.noteObject else {
            return
        }
        
        self.delegate?.makePublic(note)
    }
    
    func makePrivateHandler(_ action: UIAction) {
        guard let note = self.noteObject else {
            return
        }
        
        self.delegate?.makePrivate(note)
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
        actionButton.menu = getItemMenu()
        
        noteTitle.text = note.title
        noteContent.text =  note.noteText
        folderName.folderName.text = note.nameOfStorage
        globeImageView.isHidden =  !note.isPublic
        //refactor this
        creationDate.text = DateFormatter().getFormattedDateToString(date: note.dateOfCreation?.dateValue() ?? Date())
    }
    
    private func setupView() {
        contentView.layer.cornerRadius = UR.Constants.cornerRadius
        contentView.backgroundColor = UR.Color.superLightGray
        
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(noteTitle)
        contentView.addSubview(actionButton)
        contentView.addSubview(noteContent)
        contentView.addSubview(folderName)
        contentView.addSubview(creationDate)
        contentView.addSubview(globeImageView)
    }
    
    private func setupConstraints() {
        actionButton.snp.makeConstraints{ make in
            make.top.trailing.equalToSuperview().inset(16)
            make.height.equalTo(24)
            make.width.equalTo(actionButton.snp.height)
        }
        
        globeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalTo(noteTitle.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualTo(actionButton.snp.leading).offset(-8)
            make.height.width.equalTo(24)
        }
        
        noteTitle.snp.makeConstraints{ make in
            make.leading.top.equalToSuperview().offset(16)
        }
        
        noteContent.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(noteTitle.snp.bottom).offset(5)
        }
        
        folderName.snp.makeConstraints{ make in
            make.leading.bottom.equalToSuperview().inset(16)
            make.top.equalTo(noteContent.snp.bottom).offset(10)
        }
        
        creationDate.snp.makeConstraints{ make in
            make.bottom.trailing.equalToSuperview().inset(16)
            make.top.equalTo(noteContent.snp.bottom).offset(10)
            make.leading.equalTo(folderName.snp.trailing)
        }
    }
}
