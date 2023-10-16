import SnapKit
import Combine
import UIKit

class NoteViewControllerPrivate: UIViewController, NoteViewControllerProtocol {
    
    //MARK: - Properties
    private let noteScrollView = NoteScrollView()
    private var cancellables = Set<AnyCancellable>()
    private var noteViewModel: NoteViewModelProtocol?
    
    //TODO: Найти лучшее решение для отлавливания перехода по кнопки "back"
    private var isDeleted = false
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        connectViewModel()
        configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !isDeleted {
            if let noteViewModel = noteViewModel as? NoteViewModelPrivate {
                noteViewModel.saveData()
            }
        }
    }
    
    //MARK: - Private functions
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(noteScrollView)
        setupKeyboardLayout()
        makeRightBarButton()
        addBarButtonAction()
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
        
        imageView.setImage(image: UIImage(named: "folder-small.svg"))
        
        updateText(title: title, textView: textView)
        
        if let noteViewModel = noteViewModel as? NoteViewModelPrivate {
            textView.text = noteViewModel.noteData.noteText
            title.text = noteViewModel.noteData.title
            storage.text = noteViewModel.noteData.nameOfStorage
            date.text = DateFormatter().getFormattedDateToString(date: noteViewModel.noteData.dateOfCreation)
        }
    }
    
    //MARK: - Methods
    func getNoteScrollView() -> NoteScrollView {
        return noteScrollView
    }
    
    func setNoteData(noteData: NoteData?) {
        noteViewModel = NoteViewModelFactory.makeNoteController(.privateViewModel, noteData: noteData)
    }
}

//MARK: - Extensions
//MARK: - MakeMenuAlert
extension NoteViewControllerPrivate {
    func makeMenuAlert() -> UIAlertController {
        let alertMenuController = UIAlertController(title: "Выберите действие", message: nil, preferredStyle: .actionSheet)
        
        let deleteButton = UIAlertAction(title: "Удалить заметку", style: .destructive) {
            [weak self] action in
            if let noteViewModel = self?.noteViewModel as? NoteViewModelPrivate {
                noteViewModel.removeData()
            }
            self?.isDeleted = true
            self?.navigationController?.popViewController(animated: true)
        }
        
        let shareButton = UIAlertAction(title: "Поделиться", style: .default) { [weak self] action in
            var text = ""
            if let noteViewModel = self?.noteViewModel as? NoteViewModelPrivate {
                text = noteViewModel.noteData.title + "\n" + noteViewModel.noteData.noteText
            }
            let shareSheetVC = UIActivityViewController(activityItems: [text],
                                                        applicationActivities: nil)
            self?.present(shareSheetVC, animated: true)
        }
        
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel)
        
        alertMenuController.addAction(shareButton)
        alertMenuController.addAction(deleteButton)
        alertMenuController.addAction(cancelButton)
        
        return alertMenuController
    }
}

//MARK: - Update text fields
extension NoteViewControllerPrivate {
    private func updateText(title: UITextField, textView: NoteTextInputField) {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: title)
            .map { notification in
                (notification.object as? UITextField)?.text ?? ""
            }
            .sink { [weak self] text in
                if let noteViewModel = self?.noteViewModel as? NoteViewModelPrivate {
                    noteViewModel.noteData.title = text
                }
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: UITextView.textDidChangeNotification, object: textView)
            .map { notification in
                (notification.object as? UITextView)?.text ?? ""
            }
            .sink { [weak self] text in
                if let noteViewModel = self?.noteViewModel as? NoteViewModelPrivate {
                    noteViewModel.noteData.noteText = text
                }
            }
            .store(in: &cancellables)
        
        if let noteViewModel = self.noteViewModel as? NoteViewModelPrivate {
            noteViewModel.isTextViewEmpty
                .sink { empty in
                    if empty {
                        textView.placeholder.isHidden = false
                    } else {
                        textView.placeholder.isHidden = true
                    }
                }
                .store(in: &cancellables)
        }
    }
}

