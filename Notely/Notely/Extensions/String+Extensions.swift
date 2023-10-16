import Foundation

extension String {
    struct EmailValidation {
        private static let firstPart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        private static let secondPart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        private static let emailRegex = firstPart + "@" + secondPart + "[A-Za-z]{2, 8}"
        static let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    }
    
    func isText() -> Bool {
        return !self.isEmpty
    }
    
    func isEmail() -> Bool {
        return invalidEmail(self) && !self.isEmpty && countEmail(self)
    }
    
    func isPassword() -> Bool {
        return containsDigit(self) && containsSpecialCharacter(self) && self.count > 6 && self.count < 12 && !self.isEmpty
    }
    
    private func countEmail(_ value: String) -> Bool {
        return value.count >= 4 && value.count <= 40
    }
    
    private func invalidEmail(_ value: String) -> Bool {
        
        let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return predicate.evaluate(with: value)
    }
    
    private func containsDigit(_ value: String) -> Bool
    {
        let reqularExpression = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return predicate.evaluate(with: value)
    }
    
    private func containsSpecialCharacter(_ value: String) -> Bool
    {
        let reqularExpression = ".*(?=.*[!@#$&*()?^%></]).*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return predicate.evaluate(with: value)
    }
}


