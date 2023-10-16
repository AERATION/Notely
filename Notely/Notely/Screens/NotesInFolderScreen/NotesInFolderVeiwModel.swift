//
//  NotesInFolderVeiwModel.swift
//  Notely
//
//  Created by george on 30.09.2023.
//

import Foundation
import FirebaseFirestore

class NotesInFolderViewModel {
    
    var notesListener: ListenerRegistration?
    var foldersListener: ListenerRegistration?
    
    @Published var notes: [NoteData] = []
    @Published var folders: [Folder] = []
    
    func deleteNote(note: NoteData) {
        if let id = note.id {
            NotesManager.shared.deleteDevNote(id)
        }
    }
    
    func makePublic(_ note: NoteData) {
        if let id = note.id {
            NotesManager.shared.makePublic(id)
        }
    }
    
    func makePrivate(_ note: NoteData) {
        if let id = note.id {
            NotesManager.shared.makePrivate(id)
        }
    }
    
    func startListenNotes(folder: Folder) {
        if notesListener != nil {
            stopListenNotes()
        }
        
        notesListener =  NotesManager.shared.startListenFolderNotes(folderId: folder.id!) { arr in
            self.notes = arr
        }
    }

    
    func stopListenNotes() {
        notesListener?.remove()
        notesListener = nil
    }
    
    func startListenFolders() {
        if foldersListener != nil {
            stopListenFolders()
        }
        
        foldersListener = FolderManager.shared.startListenFolders { arr in
            self.folders = arr
        }
    }

    
    func stopListenFolders() {
        foldersListener?.remove()
        foldersListener = nil
    }
}
