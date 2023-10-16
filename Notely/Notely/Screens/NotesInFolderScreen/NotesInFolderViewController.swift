//
//  NotesInFolderViewController.swift
//  Notely
//
//  Created by george on 30.09.2023.
//

import UIKit
import Combine
import SnapKit
import FirebaseFirestore

class NotesInFolderViewController: UIViewController, UICollectionViewDelegate {
    var folderName: UILabel = {
        var label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UR.Font.largeTitle
        return label
    }()
    
    var folder: Folder
    var viewModel = NotesInFolderViewModel()
    
    var collectionView: NotesCollectionView?
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(folder: Folder){
        self.folder = folder
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = NotesCollectionView(cellProviderDelegate: self)
        
        self.view.backgroundColor = UR.Color.white
        self.view.addSubview(folderName)
        self.view.addSubview(collectionView!)
        self.folderName.text = folder.name
        
        collectionView!.backgroundColor = .white
        collectionView!.delegate = self
        
        setupConstraints()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.startListenNotes(folder: folder)
        viewModel.startListenFolders()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.stopListenNotes()
        viewModel.stopListenFolders()
    }
    func notesListenHandler(_ arr: [NoteData]) {
        viewModel.notes = arr
    }
    
    
    private func setupConstraints() {
        
        folderName.snp.makeConstraints{ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().offset(16)
        }
        
        collectionView!.snp.makeConstraints { make in
            make.top.equalTo(folderName.snp.bottom).offset(16)
            make.bottom.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let editNoteScreen = NoteViewControllerFactory.makeNoteController(.privateNote)
        editNoteScreen.setNoteData(noteData: viewModel.notes[indexPath.row])
        
        navigationController?.pushViewController(editNoteScreen, animated: true)
    }
    
    private func setupBindings() {
        viewModel.$notes
            .sink{ [weak self] (notes) in
                self?.collectionView!.updateNotesSnapshot(with: notes)
            }
            .store(in: &subscriptions)
    }
    
}

extension NotesInFolderViewController: NotesCollectionViewDelegate {

    func noteCellProvider(colectionView: UICollectionView, indexPath: IndexPath, note: NoteData) -> UICollectionViewCell? {
        guard let cell = colectionView.dequeueReusableCell(withReuseIdentifier: NoteCellPrivate.reuseIdentifier, for: indexPath) as? NoteCellPrivate else {
            fatalError("could not dequeue an ImageCell")
        }
        cell.noteObject = note
        cell.delegate = self
        return cell
    }
}

extension NotesInFolderViewController: NoteCellPrivateDelegate {
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
