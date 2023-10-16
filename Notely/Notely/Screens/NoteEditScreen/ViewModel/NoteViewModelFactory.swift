import UIKit

enum NoteViewModelType {
    case privateViewModel, publicViewModel
}

class NoteViewModelFactory {
    static func makeNoteController(_ type: NoteViewModelType, noteData: NoteData?) -> NoteViewModelProtocol {
        switch type {
        case .privateViewModel:
            return NoteViewModelPrivate(noteData: noteData)
        case .publicViewModel:
            return NoteViewModelPublic(noteData: noteData)
        }
    }
}
