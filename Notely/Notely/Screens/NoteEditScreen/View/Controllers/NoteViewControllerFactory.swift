import UIKit

enum NoteViewControllerType {
    case privateNote, publicNote
}

class NoteViewControllerFactory {
    static func makeNoteController(_ type: NoteViewControllerType) -> NoteViewControllerProtocol {
        switch type {
        case .privateNote:
            return NoteViewControllerPrivate()
        case .publicNote:
            return NoteViewControllerPublic()
        }
    }
}
