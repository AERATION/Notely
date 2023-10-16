import Foundation
import Combine
import FirebaseFirestore
import UIKit

protocol NoteViewModelProtocol {

    //MARK: - Lifecycle methods
    init(noteData: NoteData?)
}
