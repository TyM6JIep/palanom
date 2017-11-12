import UIKit
import KeychainSwift

class Settings {
    
    class var instance: Settings {
        struct Static {
            static let instance = Settings()
        }
        return Static.instance
    }
    
    var token: String? {
        set {
            let keychain = KeychainSwift()
            if let value = newValue {
                keychain.set(value, forKey: Constants.token)
            } else {
                keychain.delete(Constants.token)
            }
        }
        
        get {
            let keychain = KeychainSwift()
            guard let _ = keychain.get(Constants.token) else {
                return ""
            }
            return keychain.get(Constants.token)
        }
    }
}
