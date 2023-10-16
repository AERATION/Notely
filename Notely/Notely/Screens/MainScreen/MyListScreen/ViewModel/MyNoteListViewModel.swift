import Foundation
import Combine
import FirebaseFirestore

class MyNoteListViewModel: ObservableObject {
    
    var notesListener: ListenerRegistration?
    var foldersListener: ListenerRegistration?
    
    @Published var notes: [NoteData] = []
    @Published var folders: [Folder] = []
    var count = 0
    @Published var notesCount = 0
    @Published var foldersCount = 0
    @Published var isPressed: Bool = false
    
    private var subscriptions = Set<AnyCancellable> ()
    
    
    
    var isEnabled: AnyPublisher<Bool,Never> {
        $notes
            .map ({ $0.count != 0 })
            .eraseToAnyPublisher ()
    }
    
    
    init() {
        $notes
            .sink{  [weak self] in
                self!.notesCount = $0.count
            }.store(in: &subscriptions)
        $folders
            .sink{  [weak self] in
                self!.foldersCount = $0.count
            }.store(in: &subscriptions)
        
    }
    
    
    func deleteNote(note: NoteData) {
        if let id = note.id {
            NotesManager.shared.deleteDevNote(id)
        }
    }
    
    func makePublic(_ note: NoteData) {
        if let id = note.id {
            NotesManager.shared.makePublic(id)
        }
    }
    
    func makePrivate(_ note: NoteData) {
        if let id = note.id {
            NotesManager.shared.makePrivate(id)
        }
    }
    
    func switchView(){
        isPressed = !isPressed
    }
    
    func startListenNotes() {
        if notesListener != nil {
            stopListenNotes()
        }
        
        notesListener = NotesManager.shared.startListenMyNotes { arr in
            self.notes = arr
        }
    }
    
    
    func stopListenNotes() {
        notesListener?.remove()
        notesListener = nil
    }
    
    func startListenFolders() {
        if foldersListener != nil {
            stopListenFolders()
        }
        
        foldersListener = FolderManager.shared.startListenFolders { arr in
            self.folders = arr
        }
    }
    
    
    func stopListenFolders() {
        foldersListener?.remove()
        foldersListener = nil
    }
}
