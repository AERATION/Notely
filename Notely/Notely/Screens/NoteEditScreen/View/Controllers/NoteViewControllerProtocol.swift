import SnapKit
import Combine
import UIKit

protocol NoteViewControllerProtocol: UIViewController {
    
    //MARK: - Methods
    func setNoteData(noteData: NoteData?)
    func makeConstraints(noteScrollView: NoteScrollView)
}

//MARK: - Extension
extension NoteViewControllerProtocol {
    func makeConstraints(noteScrollView: NoteScrollView) {
        noteScrollView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func makeRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(named:"Union.svg")? .withTintColor(UR.Color.superDrakGray ?? .darkGray, renderingMode: .alwaysOriginal),
            style: .plain, target: self, action: nil)
    }
}
