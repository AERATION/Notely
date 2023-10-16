import UIKit

class NoteInfoView: UIView {
    
    //MARK: - Properties
    private var imageView = UserView()
    private let infoLabel = UILabel()
    private let dateLabel = UILabel()
    
    //MARK: - Lifecycle methods
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    //MARK: - Private methods
    private func configure() {
        infoLabel.setProperties()
        dateLabel.setProperties()
        
        self.addSubview(imageView)
        self.addSubview(infoLabel)
        self.addSubview(dateLabel)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    func getInfoLabel() -> UILabel {
        return infoLabel
    }
    
    func getDateLabel() -> UILabel {
        return dateLabel
    }
    
    func getImageView() -> UserView {
        return imageView
    }
}

//MARK: - Extension
extension NoteInfoView {
    private func makeConstraints() {
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.size.lessThanOrEqualTo(24)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
