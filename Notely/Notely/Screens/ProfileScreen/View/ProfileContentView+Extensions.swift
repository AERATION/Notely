import Foundation
import SnapKit
import UIKit

//MARK: - Methods
extension ProfileContentView {
    
    @objc func saveButtonClick(sender: UIButton) {
        let viewModel = getViewModel()
        sender.backgroundColor = UR.Color.darkBlue
        viewModel.onSaveButtonPressed()
    }
    
    @objc func saveButtonOnDown(sender: UIButton) {
        sender.backgroundColor = UR.Color.blue
    }
    
    func showToast(message : String, color: UIColor) {

        let toastLabel = UILabel()
        toastLabel.textColor = color
        toastLabel.font = UR.Font.main14
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.clipsToBounds = true
        
        self.addSubview(toastLabel)
        let saveButton = getSaveButton()
        toastLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(saveButton.snp.top).offset(-8)
            make.height.equalTo(18.0)
        }
        
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension ProfileContentView {
    func makeContrains() {
        let profileLabel = getProfileLabel()
        let profileImage = getProfileImage()
        let surnameTextField = getSurnameTextField()
        let nameTextField = getNameTextField()
        let aboutMeScrolalbleView = getScrollableView()
        let saveButton = getSaveButton()
        let profileIndicator = getProfileIndicator()

        profileLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(44.0)
            make.leading.equalTo(self.snp.leading).offset(16.0)
        }

        profileImage.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(44.0)
            make.trailing.equalTo(self.snp.trailing).offset(-16.0)
            make.height.equalTo(33.0)
            make.width.equalTo(33.0)
        }

        surnameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileLabel.snp.bottom).offset(68)
            make.height.equalTo(44.0)
            make.leading.equalTo(self.snp.leading).offset(16.0)
            make.trailing.equalTo(self.snp.trailing).offset(-16.0)
        }

        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(surnameTextField.snp.bottom).offset(52.0)
            make.leading.equalTo(self.snp.leading).offset(16.0)
            make.trailing.equalTo(self.snp.trailing).offset(-16.0)
            make.height.equalTo(44.0)
        }

        aboutMeScrolalbleView.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(26.0)
            make.leading.equalTo(self.snp.leading).offset(16.0)
            make.trailing.equalTo(self.snp.trailing).offset(-16.0)
        }

        profileIndicator.snp.makeConstraints { make in
            make.centerY.equalTo(saveButton.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
        }

        saveButton.snp.makeConstraints { make in
//            make.top.equalTo(aboutMeScrolalbleView.snp.bottom).offset(239.0)
            make.height.equalTo(56.0)
            make.leading.equalTo(self.snp.leading).offset(16.0)
            make.trailing.equalTo(self.snp.trailing).offset(-16.0)
            make.bottom.equalTo(self.snp.bottom).offset(-56.0)
        }
    }
}
