import UIKit
import Combine

class MyNoteListView: UIView, UICollectionViewDelegate {
    
    public let typeViewButton: UIButton = {
        var button = UIButton()
        button.setImage(UR.Icons.folderVeiw, for: .normal)
        button.tintColor = UR.Color.superDrakGray
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private let countLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .right
        label.font =  UR.Font.main15
        label.textColor = UR.Color.superDrakGray
        return label
    }()
    
    let emptyMessage: NoNotesView = {
        var view = NoNotesView()
        return view
    }()
    
    let addNoteButton: UIButton = {
        var button = UIButton()
        button.setImage(UR.Icons.newNoteIcon, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private var collectionView: UICollectionView?
    
    
    func setCountLabel(_ str: String){
        countLabel.text = str
    }
    
    
    // MARK: Inits
    init() {
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
        self.addSubview(typeViewButton)
        self.addSubview(countLabel)
        self.addSubview(emptyMessage)
        self.addSubview(addNoteButton)
    }
    
    private func setupConstraints() {
        typeViewButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(typeViewButton.snp.height)
        }
        
        countLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(24)
        }
        
        emptyMessage.snp.makeConstraints{ make in
            make.center.equalToSuperview()
        }
        
        addNoteButton.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(10)
            make.height.equalTo(65)
            make.width.equalTo(addNoteButton.snp.height)
        }
    }
    
    // TODO: this is test code
    func setCollectionView(_ view: UICollectionView) {
        collectionView = view
        self.addSubview(collectionView!)
        
        collectionView!.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(typeViewButton.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
        }
        
        self.bringSubviewToFront(addNoteButton)
    }
    
    // TODO: this is test code
    func removeCollectionView() {
        collectionView?.removeFromSuperview()
        collectionView?.removeAllConstraints()
        collectionView = nil
    }
}

