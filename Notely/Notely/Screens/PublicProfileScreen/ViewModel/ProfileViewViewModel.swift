import Combine
import FirebaseFirestore

class ProfileViewViewModel {
    
    var notesListener: ListenerRegistration?
    
    var userId: String
    @Published var notes: [NoteData] = []
    @Published var user: ProfileDataStruct?
    @Published var noteCount = 0
    
    private var subscriptions = Set<AnyCancellable> ()
    
    init(userId: String) {
        self.userId = userId
        
        $notes
            .sink{  [weak self] in
                self!.noteCount = $0.count
            }.store(in: &subscriptions)
        
        FirestoreManager.shared.getUserProfile(userId: userId) { result in
            result.publisher
                .sink( 
                    receiveCompletion: { completion in
                        switch completion {
                        case .failure:
                            //TODO: обработка ошибок
                            break
                        case .finished:
                            break
                        }
                    },
                    receiveValue: { usr in
                        self.user = usr
                    }).store(in: &self.subscriptions)
        }
    }
    
    func startListenNotes() {
        if notesListener != nil {
            stopListenNotes()
        }
        
        notesListener = NotesManager.shared.startListenUserNotes(userId: userId) { arr in
            self.notes = arr
        }
    }
    
    func stopListenNotes() {
        notesListener?.remove()
        notesListener = nil
    }
}
