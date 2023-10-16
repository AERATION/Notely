import UIKit

//MARK: - KeyboardLayout
extension NoteViewControllerPrivate {
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
    
    @objc private func keyboardWillShow(sender: Notification) {
        guard let userInfo = sender.userInfo,
              let keyboard = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboard.cgRectValue
        let noteScrollView = getNoteScrollView()
        var contentInset = noteScrollView.contentInset
        
        contentInset.bottom = keyboardFrame.height - 20
        noteScrollView.contentInset = contentInset
    }
    
    @objc private func keyboardWillHide(sender: Notification) {
        let noteScrollView = getNoteScrollView()
        let contentInset = UIEdgeInsets.zero
        noteScrollView.contentInset = contentInset
    }
    
    private func hideKeyboardThenTappedAroundOrSwipeLeft() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipe.direction = .left
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(swipe)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - MakeRightBarButton
extension NoteViewControllerPrivate {
    func addBarButtonAction() {
        navigationItem.rightBarButtonItem?.action = #selector(self.menuBarButtonClick)
    }
    
    @objc private func menuBarButtonClick(_ sender: Any?) {
        self.present(makeMenuAlert(), animated: true)
    }
}
