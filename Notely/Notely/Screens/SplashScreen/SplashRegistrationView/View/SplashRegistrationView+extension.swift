import UIKit


//MARK: - Functions
extension SplashRegistrationView {
    
    @objc func registrationButtonClick(sender: UIButton) {
        let viewModel = getViewModel()
        sender.backgroundColor = UR.Color.darkBlue
        viewModel.onRegistrationButtonPressed()
    }
    
    @objc func registrationButtonOnDown(sender: UIButton) {
        sender.backgroundColor = UR.Color.blue
    }
}

//MARK: - Make constraints
extension SplashRegistrationView {
    
    func makeConstraints() {
        
        let userRegistrationNoteLabel = getUserRegisterNoteLabel()
        let emailTextField = getEmailTextField()
        let passwordTextField = getPasswordTextField()
        let nameTextField = getNameTextField()
        let surnameTextField = getSurnameTextField()
        let aboutMyselfScrollableView = getAboutMeScrollableView()
        let loadingIndicator = getLoadingIndicator()
        let errorLabel = getErrorLabel()
        let registrationButton = getRegistrationButton()
        
        userRegistrationNoteLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(17.0)
            make.height.equalTo(72.0)
            make.leading.equalTo(self.snp.leading).offset(16.0)
            make.trailing.equalTo(self.snp.trailing).offset(-16.0)
        }

        emailTextField.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(userRegistrationNoteLabel.snp.bottom).offset(74.0)
            make.top.greaterThanOrEqualTo(userRegistrationNoteLabel.snp.bottom).offset(32.0)
            make.height.equalTo(44)
            make.leading.equalTo(self.snp.leading).offset(16.0)
            make.trailing.equalTo(self.snp.trailing).offset(-16.0)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(emailTextField.snp.bottom).offset(52.0)
            make.top.greaterThanOrEqualTo(emailTextField.snp.bottom).offset(32.0)
            make.height.equalTo(44)
            make.leading.equalTo(self.snp.leading).offset(16.0)
            make.trailing.equalTo(self.snp.trailing).offset(-16.0)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(passwordTextField.snp.bottom).offset(52.0)
            make.top.greaterThanOrEqualTo(passwordTextField.snp.bottom).offset(32.0)
            make.height.equalTo(44)
            make.leading.equalTo(self.snp.leading).offset(16.0)
            make.trailing.equalTo(self.snp.trailing).offset(-16.0)
        }
        
        surnameTextField.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(nameTextField.snp.bottom).offset(52.0)
            make.top.greaterThanOrEqualTo(nameTextField.snp.bottom).offset(32.0)
            make.height.equalTo(44)
            make.leading.equalTo(self.snp.leading).offset(16.0)
            make.trailing.equalTo(self.snp.trailing).offset(-16.0)
        }
        
        aboutMyselfScrollableView.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(surnameTextField.snp.bottom).offset(26.0)
            make.top.greaterThanOrEqualTo(surnameTextField.snp.bottom).offset(18.0)
            make.leading.equalTo(self.snp.leading).offset(16.0)
            make.trailing.equalTo(self.snp.trailing).offset(-16.0)
            make.bottom.equalTo(registrationButton.snp.top)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.centerY.equalTo(registrationButton.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(registrationButton.snp.top).offset(-4.0)
            make.centerX.equalTo(self.snp.centerX)
        }

        registrationButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-19.0)
            make.height.equalTo(56.0)
            make.leading.equalTo(self.snp.leading).offset(16.0)
            make.trailing.equalTo(self.snp.trailing).offset(-16.0)
        }
    }
}
