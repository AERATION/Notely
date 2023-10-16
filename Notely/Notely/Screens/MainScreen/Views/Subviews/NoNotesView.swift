import UIKit

class NoNotesView: UIView {
    // MARK: UIElements
    var noteIcon: UIImageView = {
        var icon = UIImageView()
        icon.image = UR.Icons.noteIcon
        icon.tintColor = UR.Color.superDrakGray
        icon.alpha = 0.6
        return icon
    }()
    
    var mainText: UILabel = {
        var label = UILabel()
        label.font = UR.Font.smallTitle
        label.textAlignment = .center
        label.text = "У вас еще нет заметок"
        return label
    }()
    
    var subText: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Здесь будут отображаться заметки,\n которые Вы создадите"
        label.font = UR.Font.main15
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
        self.addSubview(noteIcon)
        self.addSubview(mainText)
        self.addSubview(subText)
    }
    
    private func setupConstraints() {
        noteIcon.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(56)
            make.width.equalTo(noteIcon.snp.height)
        }
        
        mainText.snp.makeConstraints{ make in
            make.top.equalTo(noteIcon.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        subText.snp.makeConstraints{ make in
            make.top.equalTo(mainText.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
