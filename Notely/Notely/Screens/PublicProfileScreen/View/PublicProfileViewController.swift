import Foundation
import UIKit
import Combine

class PublicProfileViewController: UIViewController {
    var head = ProfileHeadView()
    
    var viewModel: ProfileViewViewModel
    
    var notesCollectionView: NotesCollectionView?
    private var subscriptions = Set<AnyCancellable>()
    
    
    init(userId: String){
        viewModel =  ProfileViewViewModel(userId: userId)
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(head)
        
        notesCollectionView = NotesCollectionView(cellProviderDelegate: self)
        
        self.view.backgroundColor = UR.Color.white
        self.view.addSubview(notesCollectionView!)
        setupConstraints()
        
        notesCollectionView!.backgroundColor = .none
        notesCollectionView?.delegate = self
        
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.startListenNotes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.stopListenNotes()
    }
    
    private func setupBindings() {
        viewModel.$notes
            .sink{ [weak self] (notes) in
                self?.notesCollectionView!.updateNotesSnapshot(with: notes)
            }
            .store(in: &subscriptions)
        
        viewModel.$user
            .sink{ [weak self] (user) in
                self?.head.setName(firstName: user?.firstName ?? " ", secondName: user?.lastName ?? " ")
                self?.head.about.text = user?.aboutMe
                self?.head.avatar.setUserLabel(textFont: UR.Font.main17Semibold , userFirstName: user?.firstName ?? " ", userLastName: user?.lastName ?? " ")
            }
            .store(in: &subscriptions)
    }
    
    
    
    private func setupConstraints() {
        head.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        notesCollectionView!.snp.makeConstraints { make in
            make.top.equalTo(head.snp.bottom)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

extension PublicProfileViewController: UICollectionViewDelegate {
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let editNoteScreen = NoteViewControllerFactory.makeNoteController(.publicNote)
        editNoteScreen.setNoteData(noteData: viewModel.notes[indexPath.row])
        
        navigationController?.pushViewController(editNoteScreen, animated: true)
    }
}


extension PublicProfileViewController: NotesCollectionViewDelegate {
    func noteCellProvider(colectionView: UICollectionView, indexPath: IndexPath, note: NoteData) -> UICollectionViewCell? {
        guard let cell = colectionView.dequeueReusableCell(withReuseIdentifier: NoteCellPublic.reuseIdentifier, for: indexPath) as? NoteCellPublic else {
            fatalError("could not dequeue an ImageCell")
        }
        
        cell.noteObject = note
        return cell
    }
}
