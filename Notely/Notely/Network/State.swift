import Foundation

enum AuthState {
    case loading
    case success
    case failed
    case none
}

enum RegistrationState {
    case loading
    case success
    case failed
    case emailAlreadyExist
    case none
}

enum ProfileState {
    case loading
    case success
    case failed
    case none
}
