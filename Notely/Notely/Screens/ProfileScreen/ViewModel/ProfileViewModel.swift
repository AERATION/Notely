import Firebase
import Combine
import Foundation

protocol ProfileViewModelProtocol {
    func viewLoaded()
}

class ProfileViewModel: ProfileViewModelProtocol, FirestoreProtocol{

    @Published var surname = ""
    @Published var name = ""
    @Published var aboutMyself = ""
    
    @Published var profileState: ProfileState = .none
    
    var isSurnameValid: AnyPublisher<Bool, Never> {
        $surname
            .map { $0.isText() }
            .eraseToAnyPublisher()
    }
    
    var isNameValid: AnyPublisher<Bool, Never> {
        $name
            .map { $0.isText()  }
            .eraseToAnyPublisher()
    }
    
    var isAboutMyselfValid: AnyPublisher<Bool, Never> {
        $aboutMyself
            .map {  $0.isText()  }
            .eraseToAnyPublisher()
    }
    
    var isDataValidate: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isSurnameValid, isNameValid, isAboutMyselfValid)
            .map({$0 && $1 && $2})
            .eraseToAnyPublisher()
    }
    
    //MARK: - Methods
    func onSaveButtonPressed() {
        profileState = .loading
        let profileData: ProfileDataStruct = ProfileDataStruct(firstName: name, lastName: surname, aboutMe: aboutMyself)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.profileState = .success
            self.saveToFirestore(profileData: profileData)
        }
    }
    
    //MARK: - Logic to fetch data from database
    func viewLoaded() {
        FirestoreManager.shared.getUserProfile { [self] result in
            switch result {
                case .success(let profileData):
                    self.name = profileData.firstName
                    self.surname = profileData.lastName
                    self.aboutMyself = profileData.aboutMe
                case .failure(let error):
                    ErrorOutput.shared.errorOutput(error: error)
            }
        }
    }
}
