import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import UIKit

struct Device: Codable, Identifiable {
    
    @DocumentID var id: String?
    var user: DocumentReference?
    var baseFolderId: DocumentReference?
    
    enum CodingKeys: String, CodingKey {
        case user = "user_ref"
        case baseFolderId = "base_folder_id"
    }
    
    init(id: String?, user: DocumentReference?) {
        self.id = id
        self.user = user
    }
}

