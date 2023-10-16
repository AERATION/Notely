import Combine
import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    //MARK: - Properties
    private let profileScrollView: UIScrollView = UIScrollView()

    private let profileContentView: ProfileContentView = ProfileContentView()

    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    //MARK: - Private methods
    private func configure() {
        view.backgroundColor = UR.Color.white
        view.addSubview(profileScrollView)
        profileScrollView.addSubview(profileContentView)
        profileContentView.setProfileController(controller: self)
        setupKeyboardLayout()
        makeConstraints()
    }

    func getProfileScrollView() -> UIScrollView { return profileScrollView }

    func getProfileContentView() -> ProfileContentView { return profileContentView }
}
