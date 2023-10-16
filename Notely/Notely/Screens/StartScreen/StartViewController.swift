import UIKit
import SnapKit

class StartViewController: UIViewController {
    
    private let startViewModel = StartViewModel()
    private let logoImageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        logoImageView.image = UIImage(named: "logo-full.svg")
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)

        activityIndicator.color = .gray
        view.addSubview(activityIndicator)

        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-48.5)
            make.width.equalTo(279)
            make.height.equalTo(279)
        }

        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(87)
        }

        activityIndicator.startAnimating()
        
        startViewModel.process(controller: self.navigationController!)
    }

}


