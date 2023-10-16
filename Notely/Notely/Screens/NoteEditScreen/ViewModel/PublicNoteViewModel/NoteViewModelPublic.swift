import Foundation
import Combine
import FirebaseFirestore
import UIKit

final class NoteViewModelPublic: NoteViewModelProtocol {
    
    //MARK: - Properties
    @Published var noteData: NotePublic
    
    private let db = Firestore.firestore()
    
    //MARK: - Lifecycle methods
    init(noteData: NoteData?) {
        self.noteData = NotePublic.empty
        parseNoteData(noteData: noteData)
    }
    
    //MARK: - Private methods
    private func parseNoteData(noteData: NoteData?) {
        if let noteData = noteData {
            self.noteData.id = noteData.id
            self.noteData.noteText = noteData.noteText ?? ""
            self.noteData.title = noteData.title ?? ""
            self.noteData.dateOfCreation = noteData.dateOfCreation?.dateValue() ?? Date()
            self.noteData.firstName = noteData.userFirstName ?? ""
            self.noteData.lastName = noteData.userLastName ?? ""
        }
    }
}
