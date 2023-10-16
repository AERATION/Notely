import Combine
import Foundation
import UIKit

class ProfileContentView: UIView {
    
    //MARK: - Properties
    private let profileLabel:  UILabel = {
        let label = UILabel()
        label.text = "Профиль"
        label.textColor = UR.Color.black
        label.font = .boldSystemFont(ofSize: 34)
        return label
    } ()
    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "person.circle.fill")
        return image
    } ()

    private let viewModel = ProfileViewModel()
    
    private var subscriptions = Set<AnyCancellable>()

    private let surnameTextField: InputTextField = InputTextField(placeholder: "Ваша фамилия", textLabel: "Фамилия")
    
    private let nameTextField: InputTextField = InputTextField(placeholder: "Ваше имя", textLabel: "Имя")
    
    private let aboutMeScrollableView: ScrollableView = ScrollableView(textLabel: "О себе")

    private let profileIndicator: LoadingIndicator = LoadingIndicator(frame: .zero)

    private let saveButton: SubmitButton = SubmitButton(titleLabel: "Сохранить")
    
    private var viewController: UIViewController = UIViewController()
    
    //MARK: - Initialization
    init() {
        super.init(frame: .zero)
        configure()
        connectViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init(coder:) has not implemented")
    }
    
    //MARK: - Private methods
    private func connectViewModel() {
        viewModel.viewLoaded()

        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: surnameTextField)
            .compactMap( {($0.object as? UITextField)?.text ?? "" })
            .assign(to: \.surname, on: viewModel)
            .store(in: &subscriptions)
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: nameTextField)
            .compactMap( { ($0.object as? UITextField)?.text ?? "" })
            .assign(to: \.name, on: viewModel)
            .store(in: &subscriptions)

        NotificationCenter.default
            .publisher(for: UITextView.textDidChangeNotification, object: aboutMeScrollableView.scrollableTextView)
            .compactMap( {($0.object as? UITextView)?.text ?? "" })
            .assign(to: \.aboutMyself, on: viewModel)
            .store(in: &subscriptions)
        
        viewModel.$name
            .sink { [weak self] name in
                self?.nameTextField.text = name
            }
            .store(in: &subscriptions)
        
        viewModel.$surname
            .sink { [weak self] surname in
                self?.surnameTextField.text = surname
            }
            .store(in: &subscriptions)
        
        viewModel.$aboutMyself
            .sink { [weak self] aboutMe in
                self?.aboutMeScrollableView.scrollableTextView.text = aboutMe
            }
            .store(in: &subscriptions)
        
        viewModel.isDataValidate
            .sink { [weak self] state in
                if state == false {
                    self?.saveButton.isEnabled = false
                    self?.saveButton.backgroundColor = UR.Color.darkGray
                } else {
                    self?.saveButton.isEnabled = true
                    self?.saveButton.backgroundColor = UR.Color.blue
                }
            }
            .store(in: &subscriptions)

        viewModel.isSurnameValid
            .sink { [weak self] state in
                if state == false {
                    self?.surnameTextField.errorTextLabel.text = "Некорректная фамилия"
                    self?.surnameTextField.errorTextLabel.isHidden = false
                    self?.surnameTextField.layer.borderColor = UR.Color.red?.cgColor
                } else {
                    self?.surnameTextField.errorTextLabel.text = ""
                    self?.surnameTextField.errorTextLabel.isHidden = true
                    self?.surnameTextField.layer.borderColor = UR.Color.green?.cgColor
                }
            }
            .store(in: &subscriptions)

        viewModel.isNameValid
            .sink { [weak self] state in
                if state == false {
                    self?.nameTextField.errorTextLabel.text = "Некорректное имя"
                    self?.nameTextField.errorTextLabel.isHidden = false
                    self?.nameTextField.layer.borderColor = UR.Color.red?.cgColor
                } else {
                    self?.nameTextField.errorTextLabel.text = ""
                    self?.nameTextField.errorTextLabel.isHidden = true
                    self?.nameTextField.layer.borderColor = UR.Color.green?.cgColor
                }
            }
            .store(in: &subscriptions)

        viewModel.isAboutMyselfValid
            .sink { [weak self] state in
                if state == false {
                    self?.aboutMeScrollableView.setErrorText(error: "Некорректный ввод")
                    self?.aboutMeScrollableView.setErrorStatus(status: false)
                    self?.aboutMeScrollableView.layer.borderColor = UR.Color.red?.cgColor
                } else {
                    self?.aboutMeScrollableView.setErrorText(error: "")
                    self?.aboutMeScrollableView.setErrorStatus(status: true)
                    self?.aboutMeScrollableView.layer.borderColor = UR.Color.green?.cgColor
                }
            }
            .store(in: &subscriptions)

        viewModel.$profileState
            .sink { [weak self] state in
                switch state {
                    case .loading:
                        self?.saveButton.setTitle("", for: .normal)
                        self?.profileIndicator.isHidden = false
                        self?.profileIndicator.startAnimating()
                    case .success:
                        self?.profileIndicator.isHidden = true
                        self?.profileIndicator.stopAnimating()
                        self?.showToast(message: "Сохранение успешно", color: .green)
                        self?.viewController.navigationController?.popViewController(animated: true)
                        self?.saveButton.setTitle("Сохранить", for: .normal)
                    case .failed:
                        self?.profileIndicator.isHidden = true
                        self?.profileIndicator.stopAnimating()
                        self?.showToast(message: "Ошибка сохранения!", color: .red)
                        self?.saveButton.setTitle("Сохранить", for: .normal)
                    case .none:
                        self?.profileIndicator.isHidden = true
                        self?.profileIndicator.stopAnimating()
                }
            }
            .store(in: &subscriptions)
        
        resetForm()
    }
    
    private func configure() {
        self.backgroundColor = .white
        self.addSubview(profileLabel)
        self.addSubview(profileImage)
        self.addSubview(nameTextField)
        self.addSubview(surnameTextField)
        self.addSubview(aboutMeScrollableView)
        self.addSubview(saveButton)
        self.addSubview(profileIndicator)
        makeContrains()
        saveButton.addTarget(self, action: #selector(saveButtonClick(sender: )), for: .touchDown)
        saveButton.addTarget(self, action: #selector(saveButtonOnDown(sender: )), for: .touchUpInside)
    }
    
    private func resetForm() {
        surnameTextField.errorTextLabel.isHidden = true
        surnameTextField.layer.borderColor = UR.Color.green?.cgColor
        nameTextField.errorTextLabel.isHidden = true
        nameTextField.layer.borderColor = UR.Color.green?.cgColor
        aboutMeScrollableView.setErrorStatus(status: true)
        aboutMeScrollableView.scrollableTextView.layer.borderColor = UR.Color.green?.cgColor
        saveButton.isEnabled = true
        saveButton.backgroundColor = UR.Color.blue
    }
    
    // MARK: - Methods
    func setProfileController(controller: UIViewController) { viewController = controller }
    
    func getProfileLabel() -> UILabel { return profileLabel }
    
    func getProfileImage() -> UIImageView { return profileImage }
    
    func getSurnameTextField() -> InputTextField { return surnameTextField }
    
    func getNameTextField() -> InputTextField { return nameTextField }
    
    func getSaveButton() -> SubmitButton { return saveButton }
    
    func getProfileIndicator() -> LoadingIndicator { return profileIndicator }
    
    func getViewModel() -> ProfileViewModel { return viewModel }
    
    func getScrollableView() -> ScrollableView { return aboutMeScrollableView }
    
}
