import UIKit
import SnapKit

class SplashViewController: UIViewController  {
    
    //MARK: - Properties
    private let segmentedControl: SplashSegmentedControl = SplashSegmentedControl()
    
    private let splashScrollView: UIScrollView = UIScrollView()
    
    private let splashAuth: SplashAuthView = SplashAuthView()
    
    private let splashRegister: SplashRegistrationView = SplashRegistrationView()
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Private functions
    private func configure() {
        view.backgroundColor = UR.Color.white
        view.addSubview(segmentedControl)
        view.addSubview(splashScrollView)
        splashScrollView.addSubview(splashAuth)
        splashScrollView.addSubview(splashRegister)
        splashAuth.setController(controller: self)
        splashRegister.setController(controller: self)
        makeConstraints()
        setupKeyboardLayout()
        segmentedControl.addTarget(self, action: #selector(segmentedAction(sender: )), for: .valueChanged)
    }
    
    //MARK: - Methods
    func getSegmentedControl() -> SplashSegmentedControl { return segmentedControl }
    
    func getSplashScrollView() -> UIScrollView { return splashScrollView }
    
    func getAuthView() -> SplashAuthView { return splashAuth }
    
    func getRegisterView() -> SplashRegistrationView { return splashRegister }
}

