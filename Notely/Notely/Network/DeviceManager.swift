import Foundation
import UIKit
import FirebaseFirestore

class DeviceManager {
    static let shared = DeviceManager()
    private let firestore = Firestore.firestore()
    private let deviceUUID = UIDevice.current.identifierForVendor?.uuidString
    private var userRef: DocumentReference?
    private var deviceReference: DocumentReference?
    private var baseFolderRef: DocumentReference?
    private var user: ProfileDataStruct?
}

extension DeviceManager {
    
    public func checkDeviceExistence(complition: @escaping (Result<Void, Error>) -> Void) {
        guard let deviceUUID = deviceUUID else { return }
        firestore.collection("devices").document(deviceUUID).getDocument{ [weak self] document, error in
            if let document = document, document.exists {
                self?.deviceReference = self?.firestore.collection("devices").document(deviceUUID)
                self?.baseFolderRef = try? document.data(as: Device.self).baseFolderId
                self?.userRef = try? document.data(as: Device.self).user
                if self?.userRef != nil {
                    self?.addCurrentUser()
                }
                complition(.success(()))
            } else {
                let device = Device(id: self?.deviceUUID, user: nil)
                self?.addDeviceToFirestore(device: device)
                complition(.success(()))
            }
        }
    }
    
    private func addDeviceToFirestore(device: Device) {
        guard let deviceUUID = deviceUUID else { return }
        do {
            
            let _ = try firestore.collection("devices").document(deviceUUID).setData(from: device)
            self.deviceReference = firestore.collection("devices").document(deviceUUID)
            self.baseFolderRef = FolderManager.shared.createFolder(folder: Folder(name:"общие", notes: 0))
            if let baseFolderRef = self.baseFolderRef {
                self.deviceReference?.updateData(["base_folder_id" : baseFolderRef])
            }
        }
        catch {
            //TODO: обработка ошибок
        }
    }
    
    public func addUserReference(userRef: DocumentReference) {
        guard let deviceUUID = deviceUUID else { return }
        firestore.collection("devices").document(deviceUUID).updateData([
            "user_ref": userRef,
            "auth": true
        ])
        self.userRef = userRef
        addCurrentUser()
    }
    
    private func addCurrentUser() {
        firestore.collection("users").document(userRef?.documentID ?? "").addSnapshotListener { documentSnapshot, error in
            if error != nil {
                return
            }
            if let document = documentSnapshot {
                let note = try? document.data(as: ProfileDataStruct.self)
                self.user = note
            }
        }
    }
    
    public func getNameAndSurnameOfCurrentUser() -> (String, String) {
        return (user?.firstName ?? "", user?.lastName ?? "")
    }
    
    public func getBaseFolderReference() -> DocumentReference? {
        return baseFolderRef
    }
    
    public func getDeviceReference() -> DocumentReference? {
        return deviceReference
    }
    
    public func getUserReference() -> DocumentReference? {
        return userRef
    }
}
