import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class NotesManager {
    static let firestore = Firestore.firestore()
    static let shared = NotesManager()
    
    func changeFolder(_ note: NoteData, folder: Folder) {
    

        let newFolderRef = NotesManager.firestore.collection("folders").document(folder.id!)
        let noteRef = NotesManager.firestore.collection("notes").document(note.id!)
        
        NotesManager.firestore.runTransaction({ (transaction, errorPointer) -> Any? in
            let noteDoc: DocumentSnapshot
            let newFolderDoc: DocumentSnapshot
            let oldFolderDoc: DocumentSnapshot
          
            do {
                try noteDoc = transaction.getDocument(noteRef)
                try newFolderDoc = transaction.getDocument(newFolderRef)
                
                guard let d = noteDoc.data()?["folder_ref"] as? DocumentReference else { return }
                try oldFolderDoc = transaction.getDocument(d)
                
        
            } catch _ as NSError {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1
                )
                errorPointer?.pointee = error
                return nil
            }
            
            if oldFolderDoc.documentID == newFolderDoc.documentID {
                return nil
            }
            
            guard let newFolderOldValue = newFolderDoc.data()?["notes_counter"] as? Int else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1
                )
                errorPointer?.pointee = error
                return nil
            }
            
            guard let currFolderOldValue = oldFolderDoc.data()?["notes_counter"] as? Int else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1
                )
                errorPointer?.pointee = error
                return nil
            }
            
            transaction.updateData(["notes_counter": currFolderOldValue - 1], forDocument:  noteDoc.data()?["folder_ref"] as! DocumentReference)
            transaction.updateData(["notes_counter": newFolderOldValue + 1], forDocument: newFolderRef)
            transaction.updateData(["folder_ref": newFolderRef], forDocument: noteRef)
            transaction.updateData(["name_of_storage": folder.name], forDocument: noteRef)
            
            return nil
        }) { (object, error) in
            if error != nil {
                //TODO: обработка ошибок
                //print("Transaction failed: \(error)")
            }
        }
    }
    
    
    func makePublic(_ noteId: String) {
        NotesManager.firestore.collection("notes").document(noteId).updateData(["is_public":true])
    }
    
    func makePrivate(_ noteId: String) {
        NotesManager.firestore.collection("notes").document(noteId).updateData(["is_public":false])
    }
    
    func deleteDevNote(_ noteId: String) {
        
        let noteRef =  NotesManager.firestore.collection("notes").document(noteId)
     
        NotesManager.firestore.runTransaction({ (transaction, errorPointer) -> Any? in
          
            let noteDoc: DocumentSnapshot
            let folderDoc: DocumentSnapshot
        
            do {
                try noteDoc = transaction.getDocument(noteRef)
            } catch _ as NSError {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1
                )
                errorPointer?.pointee = error
                return nil
            }
            guard let folderRef = noteDoc.data()?["folder_ref"] as? DocumentReference else { return }
            do {
    
                try folderDoc =  transaction.getDocument(folderRef)
                
            } catch _ as NSError {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1
                )
                errorPointer?.pointee = error
                return nil
            }
            
            guard let oldFolderCounter = folderDoc.data()?["notes_counter"] as? Int else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1
                )
                errorPointer?.pointee = error
                return nil
            }

            transaction.updateData(["notes_counter": oldFolderCounter - 1], forDocument: folderRef)
            transaction.deleteDocument(noteRef)
      
            return nil
        }) { (object, error) in
            if error != nil {
                //TODO: обработка ошибок
                //print("Transaction failed: \(error)")
            }
        }
    }
    
    func addDevNoteToBaseFolder(_ newNote: NoteData) {
    
        let baseFodlerRef = DeviceManager.shared.getBaseFolderReference()!
        let noteRef = try! NotesManager.firestore.collection("notes").addDocument(from: newNote)
     
        NotesManager.firestore.runTransaction({ (transaction, errorPointer) -> Any? in
            let baseFolderDoc: DocumentSnapshot
            do {
                try baseFolderDoc = transaction.getDocument(baseFodlerRef)
           
            } catch _ as NSError {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1
                )
                errorPointer?.pointee = error
                return nil
            }
            
            guard let baseFolderOldValue = baseFolderDoc.data()?["notes_counter"] as? Int else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1
                )
                errorPointer?.pointee = error
                return nil
            }

            transaction.updateData(["notes_counter": baseFolderOldValue + 1], forDocument: baseFodlerRef)
            transaction.updateData(["folder_ref": baseFodlerRef], forDocument: noteRef)
      
            
            return nil
        }) { (object, error) in
            if error != nil {
                //TODO: обработка ошибок
                //print("Transaction failed: \(error)")
            }
        }
        
    }
    
    func updateDevNote(note: NoteData, noteId: String) {
        do {
            try NotesManager.firestore.collection("notes").document(noteId).setData(from: note)
        }
        catch {
            //TODO: обработка ошибок
            //print(error.localizedDescription)
        }
    }
    
    func startListenMyNotes(comp: @escaping ([NoteData])->()) -> ListenerRegistration? {
        if let userRef = DeviceManager.shared.getUserReference() {
            return NotesManager.firestore.collection("notes")
                .whereField("user", isEqualTo: userRef)
                .addSnapshotListener { snapshot, error in
                    if error != nil {
                        return
                    }
                    
                    guard let snapshot = snapshot else {
                        return
                    }
                    
                    var notes = [NoteData]()
                    snapshot.documents.forEach { document in
                        if let note = try? document.data(as: NoteData.self) {
                            
                            notes.append(note)
                        }
                    }
                    
                    comp(notes)
                }
        } else if let deviceRef = DeviceManager.shared.getDeviceReference() {
            return NotesManager.firestore.collection("notes")
                .whereField("device", isEqualTo: deviceRef)
                .addSnapshotListener { snapshot, error in
                    if error != nil {
                        return
                    }
                    
                    guard let snapshot = snapshot else {
                        return
                    }
                    
                    var notes = [NoteData]()
                    snapshot.documents.forEach { document in
                        if let note = try? document.data(as: NoteData.self) {
                            
                            notes.append(note)
                        }
                    }
                    
                    comp(notes)
                }
        } else {
            return nil
        }
    }
    
    func startListenUserNotes(deviceRef: DocumentReference, comp: @escaping ([NoteData])->()) -> ListenerRegistration {
      
        return NotesManager.firestore.collection("notes")
            .whereField("device_ref", isEqualTo: deviceRef)
            .addSnapshotListener { snapshot, _ in
                
                guard let snapshot = snapshot else {
                    return
                }
                
                var notes = [NoteData]()
                snapshot.documents.forEach { document in
                    if let note = try? document.data(as: NoteData.self) {
                        
                        notes.append(note)
                    }
                }
                
                comp(notes)
            }
    }
    
    func startListenUserNotes(userId: String, comp: @escaping ([NoteData])->()) -> ListenerRegistration {
      
        let userRef = NotesManager.firestore.collection("users").document(userId)
        
        return NotesManager.firestore.collection("notes")
            .whereField("is_public", isEqualTo: true)
            .whereField("user", isEqualTo: userRef)
            .addSnapshotListener { snapshot, _ in
                
                guard let snapshot = snapshot else {
                    return
                }
                
                var notes = [NoteData]()
                snapshot.documents.forEach { document in
                    if let note = try? document.data(as: NoteData.self) {
                        
                        notes.append(note)
                    }
                }
                
                comp(notes)
            }
    }
    
    
    func startListenPublicNotes(comp: @escaping ([NoteData])->()) -> ListenerRegistration {
        return NotesManager.firestore.collection("notes")
            .whereField("is_public", isEqualTo: true)
            .addSnapshotListener { snapshot, error in
                if error != nil {
                    return
                }
                
                guard let snapshot = snapshot else {
                    return
                }
                
                var notes = [NoteData]()
                snapshot.documents.forEach { document in
                    if let note = try? document.data(as: NoteData.self) {
                        notes.append(note)
                    }
                }
                
                comp(notes)
            }
    }
    
    func startListenFolderNotes(folderId: String, comp: @escaping ([NoteData])->()) -> ListenerRegistration {
        
        let path = NotesManager.firestore.collection("folders").document(folderId)
        return NotesManager.firestore.collection("notes")
            .whereField("folder_ref", isEqualTo: path)
            .addSnapshotListener { snapshot, error in
                if error != nil {
                    return
                }
                
                guard let snapshot = snapshot else {
                    return
                }
                
                var notes = [NoteData]()
                snapshot.documents.forEach { document in
                    if let note = try? document.data(as: NoteData.self) {
                        notes.append(note)
                    }
                }
                
                comp(notes)
            }
    }
    
    func synchronize() {
        guard let deviceRef = DeviceManager.shared.getDeviceReference() else { return }
        guard let userRef = DeviceManager.shared.getUserReference() else { return }
        let userName = DeviceManager.shared.getNameAndSurnameOfCurrentUser()
        NotesManager.firestore.collection("notes")
            .whereField("device", isEqualTo: deviceRef)
            .getDocuments { querySnapshot, error in
                if error != nil {
                    //TODO: обработка ошибок
                    return
                } else if let querySnapshot = querySnapshot {
                    for document in querySnapshot.documents {
                        document.reference.updateData([
                            "user": userRef,
                            "user_first_name": userName.0,
                            "user_last_name": userName.1
                        ])
                    }
                }
            }
        NotesManager.firestore.collection("folders")
            .whereField("device_ref", isEqualTo: deviceRef)
            .getDocuments { querySnapshot, error in
                if error != nil {
                    //TODO: обработка ошибок
                    return
                } else if let querySnapshot = querySnapshot {
                    for document in querySnapshot.documents {
                        document.reference.updateData(["user_ref": userRef])
                    }
                }
            }
    }
}
