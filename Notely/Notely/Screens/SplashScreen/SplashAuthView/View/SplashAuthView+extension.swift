import UIKit

//MARK: - Functions
extension SplashAuthView {
    @objc func loginButtonClick(sender: UITextField) {
        let viewModel = getViewModel()
        viewModel.onLoginButtonPressed()
    }
}

//MARK: - MakeConstraint
extension SplashAuthView {
    func makeConstrains() {
        
        let userAuthNoteLabel = getUserAuthNoteLabel()
        let loginTextField = getLoginTextField()
        let passwordTextField = getPasswordTextField()
        let errorLoginMessage = getErrorLoginMessage()
        let loginButton = getLoginButton()
        let loadingIndicator = getLoadingIndicator()
        
        userAuthNoteLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(17.0)
            make.height.equalTo(72.0)
            make.leading.equalTo(self.snp.leading).offset(16.0)
            make.trailing.equalTo(self.snp.trailing).offset(-16.0)
        }
        
        loginTextField.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(userAuthNoteLabel.snp.bottom).offset(74.0)
            make.top.greaterThanOrEqualTo(userAuthNoteLabel.snp.bottom).offset(32.0)
            make.height.equalTo(44.0)
            make.leading.equalTo(self.snp.leading).offset(16.0)
            make.trailing.equalTo(self.snp.trailing).offset(-16.0)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(loginTextField.snp.bottom).offset(52.0)
            make.top.greaterThanOrEqualTo(loginTextField.snp.bottom).offset(32.0)
            make.height.equalTo(44.0)
            make.leading.equalTo(self.snp.leading).offset(16.0)
            make.trailing.equalTo(self.snp.trailing).offset(-16.0)
        }
        
        errorLoginMessage.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(passwordTextField.snp.bottom).offset(8.0)
            make.top.lessThanOrEqualTo(passwordTextField.snp.bottom).offset(32.0)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(18.0)
        }
        
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-32.0)
            make.height.equalTo(56.0)
            make.leading.equalTo(self.snp.leading).offset(16.0)
            make.trailing.equalTo(self.snp.trailing).offset(-16.0)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.centerY.equalTo(loginButton.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
}

