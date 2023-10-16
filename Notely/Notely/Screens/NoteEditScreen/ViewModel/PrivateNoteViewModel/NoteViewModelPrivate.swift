import Foundation
import Combine
import FirebaseFirestore
import UIKit

final class NoteViewModelPrivate: NoteViewModelProtocol {
    
    //MARK: - Properties
    @Published var noteData: NotePrivate
    
    private let db = Firestore.firestore()
    private var folderRef: DocumentReference?
    
    //MARK: - Lifecycle methods
    init(noteData: NoteData?) {
        self.noteData = NotePrivate.empty
        parseNoteData(noteData: noteData)
    }
    
    var isTextViewEmpty: AnyPublisher<Bool, Never> {
        $noteData
            .map { noteData in
                if noteData.noteText == "" {
                    return true
                }
                return false
            }
            .eraseToAnyPublisher()
    }
    
    //MARK: - Private methods
    private func parseNoteData(noteData: NoteData?) {
        if let noteData = noteData {
            self.folderRef = noteData.folder
            self.noteData.id = noteData.id
            self.noteData.nameOfStorage = noteData.nameOfStorage ?? ""
            self.noteData.noteText = noteData.noteText ?? ""
            self.noteData.title = noteData.title ?? ""
            self.noteData.dateOfCreation = noteData.dateOfCreation?.dateValue() ?? Date()
        }
    }
    
    private func makeNewNote() -> NoteData {
        let userName = DeviceManager.shared.getNameAndSurnameOfCurrentUser()
        let newNote = NoteData(title: noteData.title,
                               noteText: noteData.noteText,
                               dateOfCreation: Timestamp(date: noteData.dateOfCreation),
                               nameOfStorage: noteData.nameOfStorage,
                               user: DeviceManager.shared.getUserReference(),
                               device: DeviceManager.shared.getDeviceReference(),
                               folder: folderRef,
                               userFirstName: userName.0,
                               userLastName: userName.1)
        return newNote
    }
    
    private func checkTitleForEmpty() -> Bool {
        deleteLeadingWhitespaces()
        if noteData.title != "" {
            return true
        } else if noteData.noteText != "" {
            noteData.title = String(noteData.noteText.prefix(50))
            return true
        } else {
            return false
        }
    }
    
    private func deleteLeadingWhitespaces() {
        if let index = noteData.noteText.firstIndex(where: { character in !character.isWhitespace }) {
            noteData.noteText = String(noteData.noteText[index...])
        }
        if let index = noteData.title.firstIndex(where: { character in !character.isWhitespace }) {
            noteData.title = String(noteData.title[index...])
        } else {
            noteData.title = ""
        }
    }
    
    private func updateOrAddNote() {
        let note = makeNewNote()
        if let documentId = noteData.id {
            NotesManager.shared.updateDevNote(note: note, noteId: documentId)
        }
        else {
            NotesManager.shared.addDevNoteToBaseFolder(note)
        }
    }
    
    private func removeNote() {
        if let documentId = noteData.id {
            NotesManager.shared.deleteDevNote(documentId)
        }
    }
    
    //MARK: - Methods
    func saveData() {
        if checkTitleForEmpty() {
            updateOrAddNote()
        }
    }
    
    func removeData() {
        removeNote()
    }
}
