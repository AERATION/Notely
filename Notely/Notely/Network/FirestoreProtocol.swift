public protocol FirestoreProtocol {
    func saveToFirestore(profileData: ProfileDataStruct)
}

public extension FirestoreProtocol {
    func saveToFirestore(profileData: ProfileDataStruct) {
        FirestoreManager.shared.updateUserProfile(profileData: profileData) { [] result in
            switch result {
            case .success:
                break
            case .failure(let error):
                ErrorOutput.shared.errorOutput(error: error)
            }
        }
    }
}
