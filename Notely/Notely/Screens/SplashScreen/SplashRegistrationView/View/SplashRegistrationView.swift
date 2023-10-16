import UIKit
import Combine

class SplashRegistrationView: UIView {
    
    // MARK: - Properties
    private let viewModel = SplashRegistrationViewModel()
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let userRegistrationNoteLabel: UserNoteLabel = UserNoteLabel(textLabel: "Зарегистрировавшись вы сможете синхронизировать заметки, а также получите возможность делать свои заметки публичными.")

    private let emailTextFeild: InputTextField = InputTextField(placeholder: "Ваша почта", textLabel: "Почта")
    
    private let passwordTextFeild: InputTextField = {
        let textField = InputTextField(placeholder: "Введите пароль", textLabel: "Пароль")
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        return textField
    } ()
    
    private let nameTextFeild: InputTextField = InputTextField(placeholder: "Ваше имя", textLabel: "Имя")
    
    private let surnameTextFeild: InputTextField = InputTextField(placeholder: "Ваша фамилия", textLabel: "Фамилия")
    
    private let aboutMyselfScrollableView: ScrollableView = ScrollableView(textLabel: "О себе")
    
    private let loadingIndicator: LoadingIndicator = LoadingIndicator(frame: .zero)
    
    private let errorRegistrationLabel: ErrorLabel  = ErrorLabel(textLabel: "Ошибка регистрации!")

    private let registrationButton: SubmitButton = SubmitButton(titleLabel: "Зарегистрироваться")
    
    private var viewController: UIViewController = UIViewController()
    
    // MARK: - Lifecycle methods
    init() {
        super.init(frame: .zero)
        registrationButton.addTarget(self, action: #selector(registrationButtonClick(sender: )), for: .touchDown)
        registrationButton.addTarget(self, action: #selector(registrationButtonOnDown(sender: )), for: .touchUpInside)
        connectViewModel()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init(coder:) has not implemented")
    }
    
    // MARK: - Private methods
    private func configure() {
        self.addSubview(userRegistrationNoteLabel)
        self.addSubview(emailTextFeild)
        self.addSubview(passwordTextFeild)
        self.addSubview(nameTextFeild)
        self.addSubview(surnameTextFeild)
        self.addSubview(aboutMyselfScrollableView)
        self.addSubview(registrationButton)
        self.addSubview(loadingIndicator)
        self.addSubview(errorRegistrationLabel)
        makeConstraints()
        resetForm()
    }
    
    private func connectViewModel() {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: emailTextFeild)
            .compactMap( {($0.object as? UITextField)?.text ?? "" })
            .assign(to: \.email, on: viewModel)
            .store(in: &subscriptions)
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: passwordTextFeild)
            .compactMap( { ($0.object as? UITextField)?.text ?? "" })
            .assign(to: \.password, on: viewModel)
            .store(in: &subscriptions)
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: nameTextFeild)
            .compactMap( { ($0.object as? UITextField)?.text ?? "" })
            .assign(to: \.name, on: viewModel)
            .store(in: &subscriptions)
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: surnameTextFeild)
            .compactMap( { ($0.object as? UITextField)?.text ?? "" })
            .assign(to: \.surname, on: viewModel)
            .store(in: &subscriptions)
        NotificationCenter.default
            .publisher(for: UITextView.textDidChangeNotification, object: aboutMyselfScrollableView.scrollableTextView)
            .compactMap( { ($0.object as? UITextView)?.text ?? "" })
            .assign(to: \.aboutMyself, on: viewModel)
            .store(in: &subscriptions)
        
        viewModel.isDataValidate
            .sink { [weak self] state in
                if state == false {
                    self?.registrationButton.isEnabled = false
                    self?.registrationButton.backgroundColor = UR.Color.darkGray
                } else {
                    self?.registrationButton.isEnabled = true
                    self?.registrationButton.backgroundColor = UR.Color.blue
                }
            }
            .store(in: &subscriptions)
        
        viewModel.isEmailValid
            .sink { [weak self] state in
                if state == false {
                    self?.emailTextFeild.errorTextLabel.text = "Некорректная почта"
                    self?.emailTextFeild.errorTextLabel.isHidden = false
                    self?.emailTextFeild.layer.borderColor = UR.Color.red?.cgColor
                } else {
                    self?.emailTextFeild.errorTextLabel.text = ""
                    self?.emailTextFeild.errorTextLabel.isHidden = true
                    self?.emailTextFeild.layer.borderColor = UR.Color.green?.cgColor
                }
            }
            .store(in: &subscriptions)
        
        viewModel.isPasswordValid
            .sink { [weak self] state in
                if state == false {
                    self?.passwordTextFeild.errorTextLabel.text = "Некорректный пароль"
                    self?.passwordTextFeild.errorTextLabel.isHidden = false
                    self?.passwordTextFeild.layer.borderColor = UR.Color.red?.cgColor
                } else {
                    self?.passwordTextFeild.errorTextLabel.text = ""
                    self?.passwordTextFeild.errorTextLabel.isHidden = true
                    self?.passwordTextFeild.layer.borderColor = UR.Color.green?.cgColor
                }
            }
            .store(in: &subscriptions)
        
        viewModel.isNameValid
            .sink { [weak self] state in
                if state == false {
                    self?.nameTextFeild.errorTextLabel.text = "Некорректное имя"
                    self?.nameTextFeild.errorTextLabel.isHidden = false
                    self?.nameTextFeild.layer.borderColor = UR.Color.red?.cgColor
                } else {
                    self?.nameTextFeild.errorTextLabel.text = ""
                    self?.nameTextFeild.errorTextLabel.isHidden = true
                    self?.nameTextFeild.layer.borderColor = UR.Color.green?.cgColor
                }
            }
            .store(in: &subscriptions)
        
        viewModel.isSurnameValid
            .sink { [weak self] state in
                if state == false {
                    self?.surnameTextFeild.errorTextLabel.text = "Некорректная фамилия"
                    self?.surnameTextFeild.errorTextLabel.isHidden = false
                    self?.surnameTextFeild.layer.borderColor = UR.Color.red?.cgColor
                } else {
                    self?.surnameTextFeild.errorTextLabel.text = ""
                    self?.surnameTextFeild.errorTextLabel.isHidden = true
                    self?.surnameTextFeild.layer.borderColor = UR.Color.green?.cgColor
                }
            }
            .store(in: &subscriptions)
        
        viewModel.isAboutMyselfValid
            .sink { [weak self] state in
                if state == false {
                    self?.aboutMyselfScrollableView.setErrorText(error: "Некорректный ввод")
                    self?.aboutMyselfScrollableView.setErrorStatus(status: false)
                    self?.aboutMyselfScrollableView.layer.borderColor = UR.Color.red?.cgColor
                } else {
                    self?.aboutMyselfScrollableView.setErrorText(error: "")
                    self?.aboutMyselfScrollableView.setErrorStatus(status: true)
                    self?.aboutMyselfScrollableView.layer.borderColor = UR.Color.green?.cgColor
                }
            }
            .store(in: &subscriptions)
        viewModel.$loadingState
            .sink { [weak self] state in
                switch state {
                    case .loading:
                        self?.loadingIndicator.isHidden = false
                        self?.loadingIndicator.startAnimating()
                        self?.registrationButton.setTitle("", for: .normal)
                        self?.errorRegistrationLabel.isHidden = true
                    case .success:
                        self?.loadingIndicator.isHidden = true
                        self?.loadingIndicator.stopAnimating()
                        self?.errorRegistrationLabel.isHidden = true
                        self?.registrationButton.setTitle("Зарегистрироваться", for: .normal)
                        self?.viewController.navigationController?.popViewController(animated: true)
                    case .failed:
                        self?.loadingIndicator.isHidden = true
                        self?.errorRegistrationLabel.isHidden = false
                        self?.errorRegistrationLabel.text = "Ошибка регистрации"
                        self?.registrationButton.setTitle("Зарегистрироваться", for: .normal)
                        self?.loadingIndicator.stopAnimating()
                    case .emailAlreadyExist:
                        self?.loadingIndicator.isHidden = true
                        self?.emailTextFeild.errorTextLabel.isHidden = false
                        self?.emailTextFeild.errorTextLabel.text = "Данный email уже занят"
                        self?.registrationButton.setTitle("Зарегистрироваться", for: .normal)
                        self?.loadingIndicator.stopAnimating()
                    case .none:
                        self?.loadingIndicator.isHidden = true
                        self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &subscriptions)
    }
    
    private func resetForm() {
        passwordTextFeild.errorTextLabel.isHidden = true
        passwordTextFeild.layer.borderColor = UR.Color.lightGray?.cgColor
        emailTextFeild.errorTextLabel.isHidden = true
        emailTextFeild.layer.borderColor = UR.Color.lightGray?.cgColor
        nameTextFeild.errorTextLabel.isHidden = true
        nameTextFeild.layer.borderColor = UR.Color.lightGray?.cgColor
        surnameTextFeild.errorTextLabel.isHidden = true
        surnameTextFeild.layer.borderColor = UR.Color.lightGray?.cgColor
        aboutMyselfScrollableView.setErrorStatus(status: true)
        aboutMyselfScrollableView.scrollableTextView.layer.borderColor = UR.Color.lightGray?.cgColor
    }
    
    //MARK: - Methods
    func setController(controller: UIViewController) { viewController = controller }
    
    func getUserRegisterNoteLabel() -> UserNoteLabel { return userRegistrationNoteLabel }
    
    func getEmailTextField() -> InputTextField { return emailTextFeild }
    
    func getPasswordTextField() -> InputTextField { return passwordTextFeild }
    
    func getNameTextField() -> InputTextField { return nameTextFeild }
    
    func getSurnameTextField() -> InputTextField { return surnameTextFeild }
    
    func getAboutMeScrollableView() -> ScrollableView { return aboutMyselfScrollableView }
    
    func getRegistrationButton() -> SubmitButton { return registrationButton }
    
    func getLoadingIndicator() -> LoadingIndicator { return loadingIndicator }
    
    func getErrorLabel() -> ErrorLabel { return errorRegistrationLabel }
    
    func getViewModel() -> SplashRegistrationViewModel { return viewModel }
    
}
