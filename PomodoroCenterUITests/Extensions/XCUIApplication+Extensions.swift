import Foundation
import XCTest

extension XCUIApplication {
    func setIsAppOpenedBefore(_ isAppOpenedBefore: Bool = true) {
        launchArguments += ["-isAppOpenedBefore", isAppOpenedBefore ? "true" : "false"]
    }
}
