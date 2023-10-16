import UIKit
import SnapKit

//MARK: - KeyboardLayout
extension ProfileViewController {

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
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let profileScrollView = getProfileScrollView()
        let contentView = getProfileContentView()
        let savebutton = contentView.getSaveButton()
        let height = savebutton.bounds.height
        
        profileScrollView.setContentOffset(CGPoint(x: 0, y: 0+keyboardFrame.cgRectValue.height/2-height), animated: true)
    }

    @objc private func keyboardWillHide(sender: Notification) {
        let profileScrollView = getProfileScrollView()
        
        profileScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
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

//MARK: - Make constraints
extension ProfileViewController {
    func makeConstraints() {

        let profileContentView = getProfileContentView()
        let profileScrollView = getProfileScrollView()

        profileScrollView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        profileContentView.snp.makeConstraints { make in
            make.top.equalTo(profileScrollView.snp.top)
            make.leading.equalTo(profileScrollView.snp.leading)
            make.trailing.equalTo(profileScrollView.snp.trailing)
            make.height.equalTo(profileScrollView.snp.height)
            make.width.equalTo(profileScrollView.snp.width)
            make.bottom.equalTo(profileScrollView.snp.bottom)
        }
    }
}
