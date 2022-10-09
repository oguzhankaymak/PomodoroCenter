import Foundation

extension String {
    var localized: String {
        let uiTestBundle = Bundle(for: PomodoroCenterUITests.self)
        return NSLocalizedString(self, bundle: uiTestBundle, comment: "")
    }
}
