import Foundation
import Combine

class SplashRegistrationViewModel: FirestoreProtocol {
    
    //MARK: - Properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var surname: String = ""
    @Published var aboutMyself: String = ""
    
    @Published var loadingState: RegistrationState = .none
    
    var isEmailValid: AnyPublisher<Bool, Never> {
        $email
            .map { $0.isEmail() }
            .eraseToAnyPublisher()
    }
    
    var isPasswordValid: AnyPublisher<Bool, Never> {
        $password
            .map { $0.isPassword() }
            .eraseToAnyPublisher()
    }
    
    var isNameValid: AnyPublisher<Bool, Never> {
        $name
            .map { $0.isText() }
            .eraseToAnyPublisher()
    }
    
    var isSurnameValid: AnyPublisher<Bool, Never> {
        $surname
            .map { $0.isText() }
            .eraseToAnyPublisher()
    }
    var isAboutMyselfValid: AnyPublisher<Bool, Never> {
        $aboutMyself
            .map { $0.isText() }
            .eraseToAnyPublisher()
    }
    
    var isEmailAndPasswordValidate: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isEmailValid, isPasswordValid)
            .map({$0 && $1})
            .eraseToAnyPublisher()
    }
    
    var isNameAndSurnameAndAboutMyselfValidate: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isNameValid, isSurnameValid, isAboutMyselfValid)
            .map({$0 && $1 && $2})
            .eraseToAnyPublisher()
    }
    
    var isDataValidate: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isEmailAndPasswordValidate, isNameAndSurnameAndAboutMyselfValidate)
            .map({$0 && $1})
            .eraseToAnyPublisher()
    }
    
    //MARK: - Methods
    func onRegistrationButtonPressed() {
        loadingState = .loading
        let registrationData: UserDataStruct = UserDataStruct(loginData: LoginDataStruct(email: email, password: password), profileData: ProfileDataStruct(firstName: name, lastName: surname, aboutMe: aboutMyself))
        DispatchQueue.main.async {
            AuthManager.shared.registerUser(loginData: registrationData.loginData) { [self, registrationData] result in
                switch result {
                    case .success:
                        DeviceManager.shared.checkDeviceExistence() { result in
                            switch result {
                                case .success():
                                    print("device added")
                                case .failure(let error):
                                    ErrorOutput.shared.errorOutput(error: error)
                            }
                        }
                        AuthManager.shared.signIn(loginData: registrationData.loginData) { signInResult in
                            switch signInResult {
                                case .success:
                                    self.loadingState = .success
                                    self.saveToFirestore(profileData: registrationData.profileData)
                                 
                                case .failure(let error):
                                    ErrorOutput.shared.errorOutput(error: error)
                                    self.loadingState = .failed
                            }
                        }
                    case .failure(let error):
                        if error.localizedDescription == "The email address is already in use by another account." {
                            loadingState = .emailAlreadyExist
                        } else { loadingState = .failed }
                }
            }
        }
    }
}
