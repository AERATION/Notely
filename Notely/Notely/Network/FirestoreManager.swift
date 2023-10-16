import Firebase
import FirebaseAuth
import FirebaseFirestore

class FirestoreManager {
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    
    func updateUserProfile(profileData: ProfileDataStruct, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: nil)))
            return
        }
        
        let userRef = db.collection("users").document(currentUser.uid)
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(profileData)
            
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                userRef.setData(json, merge: true) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        DeviceManager.shared.addUserReference(userRef: userRef)
                        NotesManager.shared.synchronize()
                        completion(.success(()))
                    }
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func getUserProfile(completion: @escaping (Result<ProfileDataStruct, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: nil)))
            return
        }
        
        let userRef = db.collection("users").document(currentUser.uid)
        
        userRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                // Документ не найден, пользователь не имеет профиля в Firestore
                completion(.failure(NSError(domain: "", code: 404, userInfo: nil)))
                return
            }
            
            if let profileData = try? document.data(as: ProfileDataStruct.self) {
                completion(.success(profileData))
            } else {
                // Не удалось преобразовать данные из Firestore в JSON
                completion(.failure(NSError(domain: "", code: 500, userInfo: nil)))
            }
        }
    }

    
    func getUserProfile(userId: String, completion: @escaping (Result<ProfileDataStruct, Error>) -> Void) {
            let userRef = db.collection("users").document(userId)

            userRef.getDocument { (document, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let document = document, document.exists else {
                    // Документ не найден, пользователь не имеет профиля в Firestore
                    completion(.failure(NSError(domain: "", code: 404, userInfo: nil)))
                    return
                }

                if let profileData = try? document.data(as: ProfileDataStruct.self) {
                    completion(.success(profileData))
                } else {
                    // Не удалось преобразовать данные из Firestore в JSON
                    completion(.failure(NSError(domain: "", code: 500, userInfo: nil)))
                }
            }
        }
}

