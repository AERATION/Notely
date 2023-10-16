import Foundation
import FirebaseFirestoreSwift

struct NotePublic {
    @DocumentID var id: String?
    var title: String
    var noteText: String
    var dateOfCreation: Date
    var firstName: String
    var lastName: String
}

extension NotePublic {
    static var empty: NotePublic {
        NotePublic(title: "",
             noteText: "",
             dateOfCreation: Date(),
             firstName: "",
             lastName: "")
    }
}
