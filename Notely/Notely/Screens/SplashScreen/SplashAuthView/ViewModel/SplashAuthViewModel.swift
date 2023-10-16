import Combine
import Foundation
import UIKit

class SplashAuthViewModel {
    
    @Published var login: String = ""
    @Published var password: String = ""
    @Published var loadingState: AuthState = .none
    
    var loginData: LoginDataStruct = LoginDataStruct(email: "", password: "")
    
    var isLoginValid: AnyPublisher<Bool, Never> {
        $login
            .map { $0.isEmail() }
            .eraseToAnyPublisher()
    }
        
    var isPasswordValid: AnyPublisher<Bool, Never> {
        $password
            .map { $0.isText() }
            .eraseToAnyPublisher()
    }
    
    var isDataValidate: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isLoginValid, isPasswordValid)
            .map({$0 && $1})
            .eraseToAnyPublisher()
    }
    
    
    //MARK: - Methods
    func onLoginButtonPressed() {
        self.loadingState = .loading
        loginData = LoginDataStruct(email: login, password: password)
        let loginCompletion: (Result<Void, Error>) -> Void = { [weak self] result in
        switch result {
            case .success:
                self?.loadingState = .success
            
            case .failure(let error):
                ErrorOutput.shared.errorOutput(error: error)
                self?.loadingState = .failed
            }
        }
        
        DispatchQueue.main.async {
            AuthManager.shared.signIn(loginData: self.loginData, completion: loginCompletion)
        }
    }
}
