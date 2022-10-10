import Foundation

extension UserDefaults {
    private enum UserDefaultsKeys: String {
        case isAppOpenedBefore
    }
    
    var isAppOpenedBefore: Bool {
        get {
            bool(forKey: UserDefaultsKeys.isAppOpenedBefore.rawValue)
        }
        
        set {
            setValue(newValue, forKey: UserDefaultsKeys.isAppOpenedBefore.rawValue)
        }
    }
}
