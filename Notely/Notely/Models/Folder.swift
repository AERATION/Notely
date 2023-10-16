import FirebaseFirestore
import FirebaseFirestoreSwift

struct Folder: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var name: String
    var notesCounter: Int
    var device: DocumentReference?
    var user: DocumentReference?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case notesCounter = "notes_counter"
        case device = "device_ref"
        case user = "user_ref"
    }
    
    init(name: String, notes: Int) {
        self.name = name
        self.notesCounter = notes
        self.device = DeviceManager.shared.getDeviceReference()
        self.user = DeviceManager.shared.getUserReference()
    }
}
