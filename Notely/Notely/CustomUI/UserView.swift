import UIKit

class UserView: UIView {
    
    //MARK: - Lifecycle methods
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.width * 0.5
    }
    
    //MARK: - Methods
    func setUserLabel(textFont: UIFont, userFirstName: String, userLastName: String) {
        let label = UILabel()
        label.textColor = UR.Color.white ?? .white
        label.text = String(userFirstName.first ?? Character(" ")) + String(userLastName.first ?? Character(" "))
        label.font = textFont
        self.addSubview(label)
        makeLabelContraints(label)
    }
    
    func setImage(image: UIImage?) {
        var imageView = UIImageView()
        if let image = image {
            imageView = UIImageView(image: image.withTintColor(UR.Color.superDrakGray ?? .darkGray,
                                                               renderingMode: .automatic))
        }
        self.addSubview(imageView)
        makeImageViewConstraints(imageView)
    }
}

//MARK: - Extensions
extension UserView {
    private func makeLabelContraints(_ label: UILabel) {
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func makeImageViewConstraints(_ imageView: UIImageView) {
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(21)
            make.width.equalTo(24)
        }
    }
}
