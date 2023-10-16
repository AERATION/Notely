import SnapKit
import Combine
import UIKit

class NoteViewControllerPublic: UIViewController, NoteViewControllerProtocol {
    //MARK: - Properties
    private let noteScrollView = NoteScrollView()
    private var cancellables = Set<AnyCancellable>()
    private var noteViewModel: NoteViewModelProtocol?
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        connectViewModel()
        configure()
    }
    
    //MARK: - Private methods
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(noteScrollView)
        makeRightBarButton()
        makeConstraints(noteScrollView: noteScrollView)
    }
    
    private func connectViewModel() {
        
        let noteScrollView = self.noteScrollView
        let contentView = noteScrollView.getContentView()
        let infoView = contentView.getInfoView()
        
        let textView = contentView.getNoteTextInputField()
        let title = contentView.getTitleInputField()
        
        let storage = infoView.getInfoLabel()
        let date = infoView.getDateLabel()
        let imageView = infoView.getImageView()
        
        textView.isEditable = false
        title.isEnabled = false
        textView.placeholder.isHidden = true
        
        if let noteViewModel = noteViewModel as? NoteViewModelPublic {
            textView.text = noteViewModel.noteData.noteText
            title.text = noteViewModel.noteData.title
            storage.text = noteViewModel.noteData.firstName + " " + noteViewModel.noteData.lastName
            date.text = DateFormatter().getFormattedDateToString(date: noteViewModel.noteData.dateOfCreation)
        }
        
        configureImageView(imageView: imageView)
    }
    
    private func configureImageView(imageView: UserView) {
        imageView.backgroundColor = UR.Color.superDrakGray ?? UIColor(named: "super-dark-gray")
        if let noteViewModel = noteViewModel as? NoteViewModelPublic {
            imageView.setUserLabel(textFont: UR.Font.main13,
                                   userFirstName: noteViewModel.noteData.firstName,
                                   userLastName: noteViewModel.noteData.firstName)
        }
    }
    
    //MARK: - Methods
    func setNoteData(noteData: NoteData?) {
        noteViewModel = NoteViewModelFactory.makeNoteController(.publicViewModel, noteData: noteData)
    }
}
