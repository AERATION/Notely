import Foundation
import Combine
import FirebaseFirestore

class PublicNoteListViewModel: ObservableObject {
    @Published var notes: [NoteData] = []
    
    var notesListener: ListenerRegistration?
    
    func startListenPublicNotes() {
        if notesListener != nil {
            stopListenPublicNotes()
        }
        
        notesListener = NotesManager.shared.startListenPublicNotes { arr in
            self.notes = arr
        }
    }
    
    func stopListenPublicNotes() {
        notesListener?.remove()
        notesListener = nil
    }
}
