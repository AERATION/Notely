import Foundation
import UIKit
import Combine
import FirebaseFirestore

class PublicNoteListViewController: UIViewController {
    var viewModel = PublicNoteListViewModel()
    
    var notesCollectionView: NotesCollectionView?
    private var subscriptions = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesCollectionView = NotesCollectionView(cellProviderDelegate: self)
        
        self.view.backgroundColor = UR.Color.white
        self.view.addSubview(notesCollectionView!)
        setupConstraints()
        
        notesCollectionView!.backgroundColor = .none
        notesCollectionView?.delegate = self
        
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.startListenPublicNotes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.stopListenPublicNotes()
    }
    
    private func setupBindings() {
        viewModel.$notes
            .sink{ [weak self] (notes) in
                self?.notesCollectionView!.updateNotesSnapshot(with: notes)
            }
            .store(in: &subscriptions)
    }
    
    private func setupConstraints() {
        notesCollectionView!.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

extension PublicNoteListViewController: UICollectionViewDelegate {
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let editNoteScreen = NoteViewControllerFactory.makeNoteController(.publicNote)
        editNoteScreen.setNoteData(noteData: viewModel.notes[indexPath.row])
        
        navigationController?.pushViewController(editNoteScreen, animated: true)
    }
}


extension PublicNoteListViewController: NotesCollectionViewDelegate {
    func noteCellProvider(colectionView: UICollectionView, indexPath: IndexPath, note: NoteData) -> UICollectionViewCell? {
        guard let cell = colectionView.dequeueReusableCell(withReuseIdentifier: NoteCellPublic.reuseIdentifier, for: indexPath) as? NoteCellPublic else {
            fatalError("could not dequeue an ImageCell")
        }
        
        cell.noteObject = note
        
        cell.delegate = self
        return cell
    }
}

extension PublicNoteListViewController: NoteCellPublicDelegate {
    func profilePressed(_ profileId: String?) {
        let profile = PublicProfileViewController(userId: profileId!)
        navigationController?.pushViewController(profile, animated: true)
    }
    
}
