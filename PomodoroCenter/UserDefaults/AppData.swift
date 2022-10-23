import Foundation

struct AppData {
    @Storage(key: "isAppOpenedBefore", defaultValue: false)
    static var isAppOpenedBefore: Bool
}
