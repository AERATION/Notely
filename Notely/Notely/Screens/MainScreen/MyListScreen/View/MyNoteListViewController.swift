import UIKit
import SnapKit
import Combine
import FirebaseFirestore

class MyNoteListViewController: UIViewController {
    
    var mainView = MyNoteListView()
    var viewModel = MyNoteListViewModel()
    
    var disableSegmented: ((Bool)->Void)?
    
    var myNotescollectionView: NotesCollectionView?
    var FolderscollectionView = FoldersCollectionView()
    
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myNotescollectionView = NotesCollectionView(cellProviderDelegate: self)
        
        self.view.backgroundColor = UR.Color.white
        self.view.addSubview(mainView)
        setupConstraints()
        
        mainView.addNoteButton.addTarget(self, action: #selector(newNotePressed), for: .touchUpInside)
        
        myNotescollectionView!.backgroundColor = .none
        myNotescollectionView!.delegate = self
        
        
        FolderscollectionView.delegate = self
        
        mainView.typeViewButton.addTarget(self, action: #selector(viewTypeButtonTapped), for: .touchUpInside)
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.startListenFolders()
        viewModel.startListenNotes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.stopListenNotes()
        viewModel.stopListenFolders()
    }
    
    @objc func viewTypeButtonTapped() {
        viewModel.switchView()
    }
    
    private func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func setupBindings() {
        viewModel.$notes
            .sink{ [weak self] (notes) in
                self?.myNotescollectionView!.updateNotesSnapshot(with: notes)
            }
            .store(in: &subscriptions)
        
        viewModel.$folders
            .sink{ [weak self] (folders) in
                self?.FolderscollectionView.updateFoldersSnapshot(with: folders)
            }
            .store(in: &subscriptions)
        
        viewModel.$isPressed
            .sink{ [weak self] (val) in
                if val {
                    self?.mainView.removeCollectionView()
                    self?.mainView.setCollectionView(self!.FolderscollectionView)
                    self?.disableSegmented?(true)
                    self!.mainView.setCountLabel("\(self!.viewModel.foldersCount) папок")
                }else{
                    self?.mainView.removeCollectionView()
                    self?.mainView.setCollectionView(self!.myNotescollectionView!)
                    self?.disableSegmented?(false)
                    self!.mainView.setCountLabel("\(self!.viewModel.notesCount) заметок")
                }
            }
            .store(in: &subscriptions)
        
        viewModel.$foldersCount
            .sink{  [weak self] in
                if self!.viewModel.isPressed {
                    self!.mainView.setCountLabel("\($0) папок")
                }
            }
            .store(in: &subscriptions)
        
        viewModel.$notesCount
            .sink{  [weak self] in
                if !(self!.viewModel.isPressed) {
                    self!.mainView.setCountLabel("\($0) заметок")
                }
            }
            .store(in: &subscriptions)
        
        
        
        
        viewModel.$notesCount
            .sink{  [weak self] in
                self!.mainView.emptyMessage.isHidden = $0 != 0
            }
            .store(in: &subscriptions)
    }
    
    @objc func newNotePressed() {
        let editNoteScreen = NoteViewControllerFactory.makeNoteController(.privateNote)
        editNoteScreen.setNoteData(noteData: nil)
        
        navigationController?.pushViewController(editNoteScreen, animated: true)
    }
}



// MARK: CollectionView Methods
extension MyNoteListViewController: UICollectionViewDelegate {
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == myNotescollectionView {
            let editNoteScreen = NoteViewControllerFactory.makeNoteController(.privateNote)
            editNoteScreen.setNoteData(noteData: viewModel.notes[indexPath.row])
            
            navigationController?.pushViewController(editNoteScreen, animated: true)
        }
        
        if collectionView == FolderscollectionView {
            let folderNotes = NotesInFolderViewController(folder: viewModel.folders[indexPath.row] )
            navigationController?.pushViewController(folderNotes, animated: true)
        }
    }
}

extension MyNoteListViewController: NotesCollectionViewDelegate {
    
    func noteCellProvider(colectionView: UICollectionView, indexPath: IndexPath, note: NoteData) -> UICollectionViewCell? {
        guard let cell = colectionView.dequeueReusableCell(withReuseIdentifier: NoteCellPrivate.reuseIdentifier, for: indexPath) as? NoteCellPrivate else {
            fatalError("could not dequeue an ImageCell")
        }
        cell.noteObject = note
        cell.delegate = self
        return cell
    }
}

extension MyNoteListViewController: NoteCellPrivateDelegate {
    func makePublic(_ note: NoteData) {
        viewModel.makePublic(note)
    }
    
    func makePrivate(_ note: NoteData) {
        viewModel.makePrivate(note)
    }
    
    
    func deleteNote(_ note: NoteData) {
        viewModel.deleteNote(note: note)
    }
    
    func moveFolder(_ note: NoteData) {
        let dialogMessage = UIAlertController(title: "Выбрете папку", message: "", preferredStyle: .alert)
        
        let tableViewController = FolderPicker(data: viewModel.folders)
        tableViewController.preferredContentSize = CGSize(width: 272, height: 176) // 4 default cell heights.
        
        dialogMessage.setValue(tableViewController, forKey: "contentViewController")
        
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default)
        dialogMessage.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            if let selectedRow = tableViewController.tableView.indexPathForSelectedRow?.row {
                let selectedFolder = self.viewModel.folders[selectedRow]
                
                NotesManager.shared.changeFolder(note, folder: selectedFolder)
            }
        }
        
        dialogMessage.addAction(okAction)
        
        self.present(dialogMessage, animated: true)
    }
    
}

