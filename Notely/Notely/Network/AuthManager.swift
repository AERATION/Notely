import Firebase
import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()
        private let auth = Auth.auth()

        func registerUser(loginData: LoginDataStruct, completion: @escaping (Result<Void, Error>) -> Void) {
            auth.createUser(withEmail: loginData.email, password: loginData.password) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }

        func signIn(loginData: LoginDataStruct, completion: @escaping (Result<Void, Error>) -> Void) {
            auth.signIn(withEmail: loginData.email, password: loginData.password) { [weak self] authResult, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let db = Firestore.firestore()
                    let userRef = db.collection("users").document(self?.auth.currentUser?.uid ?? "")
                    DeviceManager.shared.addUserReference(userRef: userRef)
                    NotesManager.shared.synchronize()
                    completion(.success(()))
                }
            }
        }

        func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
            do {
                try auth.signOut()
                completion(.success(()))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }

        func isUserLoggedIn() -> Bool {
            return auth.currentUser != nil
        }

}

