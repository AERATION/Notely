import UIKit

class NoteScrollView: UIScrollView {
    
    //MARK: - Properties
    private var contentView: NoteScrollContentView!
    
    //MARK: - Lifecycle methods
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    //MARK: - Private methods
    private func configure() {
        contentView = NoteScrollContentView()
        self.addSubview(contentView)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    func getContentView() -> NoteScrollContentView {
        return contentView
    }
}

//MARK: - Extensions
extension NoteScrollView {
    private func makeConstraints() {
        contentView.snp.makeConstraints { make in
            make.leading.equalTo(self.contentLayoutGuide.snp.leading)
            make.trailing.equalTo(self.contentLayoutGuide.snp.trailing)
            make.bottom.equalTo(self.contentLayoutGuide.snp.bottom)
            make.top.equalTo(self.contentLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview()
        }
    }
}
