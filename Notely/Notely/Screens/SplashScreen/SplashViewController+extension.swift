import UIKit

//MARK: - MakeConstraint
extension SplashViewController {
    
    func makeConstraints() {
        
        let segmentedControl = getSegmentedControl()
        let splashScrollView = getSplashScrollView()
        let splashAuth = getAuthView()
        let splashRegister = getRegisterView()
        
        segmentedControl.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(view.snp.top).offset(105.0)
            make.top.greaterThanOrEqualTo(view.snp.top).offset(50.0)
            make.height.equalTo(32.0)
            make.width.equalTo(354.0)
            make.leading.equalTo(view.snp.leading).offset(16.0)
            make.trailing.equalTo(view.snp.trailing).offset(-16.0)
        }
        
        splashScrollView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.width.equalTo(Int(UIScreen.main.bounds.width) * 2)
            make.bottom.equalTo(view.snp.bottom)
        }
        splashAuth.snp.makeConstraints { make in
            make.top.equalTo(splashScrollView.snp.top)
            make.leading.equalTo(splashScrollView.snp.leading)
            make.height.equalTo(splashScrollView.snp.height)
            make.width.equalTo(Int(UIScreen.main.bounds.width))
            make.bottom.equalTo(splashScrollView.snp.bottom)
        }
        splashRegister.snp.makeConstraints { make in
            make.top.equalTo(splashScrollView.snp.top)
            make.leading.equalTo(Int(UIScreen.main.bounds.width))
            make.height.equalTo(splashScrollView.snp.height)
            make.width.equalTo(Int(UIScreen.main.bounds.width))
            make.bottom.equalTo(splashScrollView.snp.bottom)
        }
    }
}

//MARK: - KeyboardLayout
extension SplashViewController {
    
    func setupKeyboardLayout() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        hideKeyboardThenTappedAroundOrSwipeLeft()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let splashScrollView = getSplashScrollView()
        
        let splashAuth = getAuthView()
        let loginButton = splashAuth.getLoginButton()
        let passwordTextField = splashAuth.getPasswordTextField()
        let loginTextField = splashAuth.getLoginTextField()
        
        let splashRegister = getRegisterView()
        _ = splashRegister.getRegistrationButton()
        let nameTextField = splashRegister.getNameTextField()
        let surnameTextField = splashRegister.getSurnameTextField()
        let aboutMeScrollableView = splashRegister.getAboutMeScrollableView()
        
        if (loginTextField.isEditing || passwordTextField.isEditing) {
            loginButton.snp.updateConstraints { make in
                make.bottom.equalTo(splashAuth.snp.bottom).offset(-keyboardFrame.cgRectValue.height)
            }
        }
        else if (nameTextField.isEditing || surnameTextField.isEditing || aboutMeScrollableView.getTextViewIsEditing()) {
            let ofsetX = UIScreen.main.bounds.width * CGFloat(1)
            splashScrollView.setContentOffset(CGPoint(x: ofsetX, y: 0+keyboardFrame.cgRectValue.height), animated: true)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {

        let segmentedControl = getSegmentedControl()
        let splashScrollView = getSplashScrollView()
        
        let splashAuth = getAuthView()
        let loginButton = splashAuth.getLoginButton()
        _ = splashAuth.getPasswordTextField()
        _ = splashAuth.getLoginTextField()
        
        if(segmentedControl.selectedSegmentIndex == 0) {
            loginButton.snp.updateConstraints { make in
                make.bottom.equalTo(splashAuth.snp.bottom).offset(-32)
            }
        } else {
            let ofsetX = UIScreen.main.bounds.width * CGFloat(1)
            splashScrollView.setContentOffset(CGPoint(x: ofsetX, y: 0), animated: true)
        }
    }
    
    private func hideKeyboardThenTappedAroundOrSwipeLeft() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
        
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - Functions
extension SplashViewController {
    @objc func segmentedAction(sender: UISegmentedControl) {
        
        let segmentedControl = getSegmentedControl()
        let splashScrollView = getSplashScrollView()
        let ofsetX = UIScreen.main.bounds.width * CGFloat(segmentedControl.selectedSegmentIndex)
        
        splashScrollView.setContentOffset(CGPoint(x: ofsetX, y: 0), animated: true)
    }
}
