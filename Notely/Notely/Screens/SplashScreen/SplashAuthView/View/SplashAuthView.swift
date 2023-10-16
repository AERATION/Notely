import UIKit
import SnapKit
import Combine

class SplashAuthView: UIView {

    //MARK: - Properties
    private let viewModel = SplashAuthViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    private let userAuthNoteLabel: UserNoteLabel = UserNoteLabel(textLabel: "После авторизации вы сможете синхронизировать заметки, а также получите возможность делать свои заметки публичными.")
    
    private let loginTextField: InputTextField = InputTextField(placeholder: "Введите логин", textLabel: "Логин")
    
    private let passwordTextField: InputTextField = {
        let textField = InputTextField(placeholder: "Введите пароль", textLabel: "Пароль")
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        return textField
    } ()
    
    private let loadingIndicator: LoadingIndicator = LoadingIndicator(frame: .zero)
    
    private let errorLoginMessage: ErrorLabel = ErrorLabel(textLabel: "Неправильный логин или пароль!")
    
    private let loginButton: SubmitButton = SubmitButton(titleLabel: "Войти")
    
    private var viewController: UIViewController = UIViewController()
    
    
    //MARK: - Lifecycle methods
    init() {
        super.init(frame: .zero)
        connectViewModel()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init(coder:) has not implemented")
    }
    
    //MARK: - Private functions
    private func configure() {
        loginButton.addTarget(self, action: #selector(loginButtonClick(sender: )), for: .touchDown)
        self.addSubview(userAuthNoteLabel)
        self.addSubview(loginTextField)
        self.addSubview(passwordTextField)
        self.addSubview(loginButton)
        self.addSubview(loadingIndicator)        
        self.addSubview(errorLoginMessage)
        makeConstrains()
    }
    
    private func connectViewModel() {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: loginTextField)
            .compactMap( {($0.object as? UITextField)?.text ?? "" })
            .assign(to: \.login, on: viewModel)
            .store(in: &subscriptions)
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: passwordTextField)
            .compactMap( { ($0.object as? UITextField)?.text ?? "" })
            .assign(to: \.password, on: viewModel)
            .store(in: &subscriptions)
        
        viewModel.isDataValidate
            .sink { [weak self] state in
                if state == false {
                    self?.loginButton.isEnabled = false
                    self?.loginButton.backgroundColor = UR.Color.darkGray
                } else {
                    self?.loginButton.isEnabled = true
                    self?.loginButton.backgroundColor = UR.Color.blue
                }
            }
            .store(in: &subscriptions)
        
        viewModel.$loadingState
            .sink { [weak self] state in
                switch state {
                    case .loading:
                        self?.loginButton.setTitle("", for: .normal)
                        self?.loadingIndicator.isHidden = false
                        self?.loadingIndicator.startAnimating()
                    case .success:
                        self?.loadingIndicator.isHidden = true
                        self?.loadingIndicator.stopAnimating()
                        self?.errorLoginMessage.isHidden = true
                        self?.loginButton.setTitle("Войти", for: .normal)
                        self?.viewController.navigationController?.popViewController(animated: true)
                    case .failed:
                        self?.loadingIndicator.isHidden = true
                        self?.loadingIndicator.stopAnimating()
                        self?.errorLoginMessage.isHidden = false
                        self?.loginButton.setTitle("Войти", for: .normal)

                    case .none:
                        self?.loadingIndicator.isHidden = true
                        self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &subscriptions)
    }
        
    //MARK: - Methods
    func setController(controller: UIViewController) { viewController = controller }
    
    func getViewModel() -> SplashAuthViewModel { return viewModel }
    
    func getUserAuthNoteLabel() -> UserNoteLabel { return userAuthNoteLabel }
    
    func getLoginTextField() -> InputTextField { return loginTextField }
    
    func getPasswordTextField() -> InputTextField { return passwordTextField }
    
    func getLoginButton() -> SubmitButton { return loginButton }
    
    func getLoadingIndicator() -> LoadingIndicator { return loadingIndicator }
    
    func getErrorLoginMessage() -> ErrorLabel { return errorLoginMessage }
        
    func getViewController() -> UIViewController { return viewController }
}

