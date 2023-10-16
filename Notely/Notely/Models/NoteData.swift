import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct NoteData: Identifiable, Codable, Hashable {

    @DocumentID var id: String?
    var title: String?
    var noteText: String?
    let dateOfCreation: Timestamp?
    var nameOfStorage: String?
    let user: DocumentReference?
    let device: DocumentReference?
    var folder: DocumentReference?
    var isPublic: Bool = false
    var userFirstName: String?
    var userLastName: String?
    
    enum CodingKeys: String, CodingKey {
        case title, user, device, id
        case folder = "folder_ref"
        case noteText = "note_text"
        case dateOfCreation = "date_of_creation"
        case nameOfStorage = "name_of_storage"
        case isPublic = "is_public"
        case userFirstName = "user_first_name"
        case userLastName = "user_last_name"
    }
}

extension NoteData {
    static var empty: NoteData {
        NoteData(title: nil,
                 noteText: nil,
                 dateOfCreation: nil,
                 nameOfStorage: nil,
                 user: nil,
                 device: nil,
                 folder: nil)
    }
}
