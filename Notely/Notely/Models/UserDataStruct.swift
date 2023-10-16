public struct UserDataStruct {
    let loginData: LoginDataStruct
    let profileData: ProfileDataStruct
}

public struct LoginDataStruct {
    let email: String
    let password: String
}

public struct ProfileDataStruct: Codable {
    let firstName: String
    let lastName: String
    let aboutMe: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "firstName"
        case lastName = "lastName"
        case aboutMe = "aboutMe"
    }
}
