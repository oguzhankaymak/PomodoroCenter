import XCTest

class PomodoroCenterUITests: XCTestCase {

    func testShowOnBoardViewControllerWhenIsAppFirstOpen() throws {
        let app = XCUIApplication()
        app.setIsAppOpenedBefore(false)
        app.launch()

        let scrollViewsQuery = XCUIApplication().scrollViews
        let element = scrollViewsQuery.children(matching: .other).element.children(matching: .other).element

        element.swipeLeft()
        element.swipeLeft()
        element.swipeLeft()
        scrollViewsQuery.otherElements.buttons["skip".localized].tap()

        app.terminate()
        app.setIsAppOpenedBefore(true)
        app.launch()

        let actionButton = app.buttons["actionButton"]
        XCTAssertTrue(actionButton.exists, "Home view controller isn't open when app opened second")
    }

    func testChangeTimeToShortBreakTimer() throws {
        let app = XCUIApplication()
        app.setIsAppOpenedBefore(true)
        app.launch()
        app.buttons["break".localized].tap()

        let timerValue = app.staticTexts["timeLabel"].label
        XCTAssertEqual(timerValue, "05 : 00", "Timer is not correct")
    }

    func testChangeTimeToLongBreakTimer() throws {
        let app = XCUIApplication()
        app.setIsAppOpenedBefore(true)
        app.launch()
        app.buttons["break".localized].tap()
        app.buttons["15"].tap()

        let timerValue = app.staticTexts["timeLabel"].label
        XCTAssertEqual(timerValue, "15 : 00", "Timer is not correct")
    }

    func testShowAlertMessageIfChangeTimerTypeDuringTimerIsRunning() throws {
        let app = XCUIApplication()
        app.setIsAppOpenedBefore(true)
        app.launch()
        app.buttons["actionButton"].tap()
        app.buttons["break".localized].tap()
        app.alerts["warning".localized].scrollViews.otherElements.buttons["okay".localized].tap()

        let timerValue = app.staticTexts["timeLabel"].label
        XCTAssertNotEqual(timerValue, "25 : 00", "Timer is not correct")
        XCTAssertNotEqual(timerValue, "15 : 00", "Timer is not correct")
        XCTAssertNotEqual(timerValue, "05 : 00", "Timer is not correct")
    }

    func testShowAlertMessageIfChangeTimerTypeWhenUserStoppedTimer() throws {
        let app = XCUIApplication()
        app.setIsAppOpenedBefore(true)
        app.launch()
        app.buttons["actionButton"].tap()
        app.buttons["actionButton"].tap()
        app.buttons["break".localized].tap()
        app.alerts["warning".localized].scrollViews.otherElements.buttons["okay".localized].tap()

        let timerValue = app.staticTexts["timeLabel"].label
        XCTAssertNotEqual(timerValue, "15 : 00", "Timer is not correct")
        XCTAssertNotEqual(timerValue, "05 : 00", "Timer is not correct")
    }

    func testExistsEmptyDataLabelIfNoDataForThisWeekInStatisticsViewController() throws {
        let app = XCUIApplication()
        app.setIsAppOpenedBefore(true)
        app.launch()
        app.navigationBars["PomodoroCenter.HomeView"].buttons["calendar"].tap()

        let emptyDataLabel = app.staticTexts["noDataForThisWeek".localized]
        XCTAssertTrue(emptyDataLabel.exists, "Empty data label is not exists in statistics view controller")
    }

    func testExistsEmptyDataLabelIfNoDataForThisMonthInStatisticsViewController() throws {
        let app = XCUIApplication()
        app.setIsAppOpenedBefore(true)
        app.launch()
        app.navigationBars["PomodoroCenter.HomeView"].buttons["calendar"].tap()
        app.buttons["monthly".localized].tap()

        let emptyDataLabel = app.staticTexts["noDataForThisMonth".localized]
        XCTAssertTrue(emptyDataLabel.exists, "Empty data label is not exists in statistics view controller")
    }
}
