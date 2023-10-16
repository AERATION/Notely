import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FolderManager {
    private let firestore = Firestore.firestore()
    static let shared = FolderManager()
    
    public func getBaseFolder() -> DocumentReference? {
        return DeviceManager.shared.getDeviceReference()?.collection("folders").document("общие")
    }
    
    public func createFolder(folder: Folder) -> DocumentReference? {

        do {
            let ref = try firestore.collection("folders").addDocument(from: folder)
            return ref
        }
        catch {
            //TODO: обработка ошибок
        }
        
        return nil
    }
    
    public func startListenFolders(comp: @escaping ([Folder])->()) -> ListenerRegistration? {
        if let userRef = DeviceManager.shared.getUserReference() {
            return firestore.collection("folders")
                .whereField("user_ref", isEqualTo: userRef)
                .addSnapshotListener { snapshot, error in
                    if error != nil {
                        return
                    }
                    
                    guard let snapshot = snapshot else {
                        return
                    }
                    
                    var folders = [Folder]()
                    snapshot.documents.forEach { document in
                        if let note = try? document.data(as: Folder.self) {
                            folders.append(note)
                        }
                    }
                    
                    comp(folders)
                }
        }
        else if let deviceRef = DeviceManager.shared.getDeviceReference() {
            return firestore.collection("folders")
                .whereField("device_ref", isEqualTo: deviceRef)
                .addSnapshotListener { snapshot, error in
                    if error != nil {
                        return
                    }
                    
                    guard let snapshot = snapshot else {
                        return
                    }
                    
                    var folders = [Folder]()
                    snapshot.documents.forEach { document in
                        if let note = try? document.data(as: Folder.self) {
                            folders.append(note)
                        }
                    }
                    
                    comp(folders)
                }
        } else {
            return nil
        }
    }
}
