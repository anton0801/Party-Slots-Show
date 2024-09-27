import Foundation

class User: ObservableObject {
    
    var credits = UserDefaults.standard.integer(forKey: "credits") {
        didSet {
            UserDefaults.standard.set(credits, forKey: "credits")
        }
    }
    
    var userName: String? = UserDefaults.standard.string(forKey: "user_name") {
        didSet {
            UserDefaults.standard.set(userName, forKey: "user_name")
        }
    }
    var avatar: String = UserDefaults.standard.string(forKey: "user_avatar") ?? "avatar_1"  {
        didSet {
            UserDefaults.standard.set(avatar, forKey: "user_avatar")
        }
    }
    
    init() {
        if userName == nil {
            generateUserName()
        }
        
        if credits == 0 {
            credits = 10000
        }
    }
    
    private func generateUserName() {
        userName = "User\(Int.random(in: 100...999))"
    }
    
}
