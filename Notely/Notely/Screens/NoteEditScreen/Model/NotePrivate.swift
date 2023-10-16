import Foundation
import FirebaseFirestoreSwift

struct NotePrivate {
    @DocumentID var id: String?
    var title: String
    var noteText: String
    var dateOfCreation: Date
    var nameOfStorage: String
}

extension NotePrivate {
    static var empty: NotePrivate {
        NotePrivate(title: "",
             noteText: "",
             dateOfCreation: Date(),
             nameOfStorage: "Общие")
    }
}
