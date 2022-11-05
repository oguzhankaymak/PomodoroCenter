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

    func testChangePomodoroTimerToBreakTimer() throws {
        let app = XCUIApplication()
        app.setIsAppOpenedBefore(true)
        app.launch()
        app.buttons["break".localized].tap()

        let timerValue = app.staticTexts["timeLabel"].label
        XCTAssertEqual(timerValue, "05 : 00", "Timer is not correct")
    }

    func testChangeShortBreakTimerToLongBreakTimer() throws {
        let app = XCUIApplication()
        app.setIsAppOpenedBefore(true)
        app.launch()
        app.buttons["break".localized].tap()
        app.buttons["15"].tap()

        let timerValue = app.staticTexts["timeLabel"].label
        XCTAssertEqual(timerValue, "15 : 00", "Timer is not correct")

    }

    func testShowAlertMessageIfChangeTimerTypeWhenTimerIsRunningAndTimeDontChangeIfUserSelectCancel() throws {
        let app = XCUIApplication()
        app.setIsAppOpenedBefore(true)
        app.launch()
        app.buttons["actionButton"].tap()
        app.buttons["break".localized].tap()
        app.alerts["warning".localized].scrollViews.otherElements.buttons["cancel".localized].tap()

        let timerValue = app.staticTexts["timeLabel"].label
        XCTAssertNotEqual(timerValue, "25 : 00", "Timer is not correct")
        XCTAssertNotEqual(timerValue, "15 : 00", "Timer is not correct")
        XCTAssertNotEqual(timerValue, "05 : 00", "Timer is not correct")
    }

    func testShowAlertMessageIfChangeTimerTypeWhenTimerIsRunningAndTimeMustBeChangeIfUserSelectOkay() throws {
        let app = XCUIApplication()
        app.setIsAppOpenedBefore(true)
        app.launch()
        app.buttons["actionButton"].tap()
        app.buttons["break".localized].tap()
        app.alerts["warning".localized].scrollViews.otherElements.buttons["okay".localized].tap()

        let timerValue = app.staticTexts["timeLabel"].label
        XCTAssertEqual(timerValue, "05 : 00", "Timer is not correct")
    }

    func testExistsBarChartViewOnStatisticsViewController() throws {
        let app = XCUIApplication()
        app.setIsAppOpenedBefore(true)
        app.launch()
        app.navigationBars["PomodoroCenter.HomeView"].buttons["calendar"].tap()

        let barChartView = app.otherElements["barChartView"]
        XCTAssertTrue(barChartView.exists, "Bar chart view is not exists on statistics view controller")
    }

    func testExistsLineChartViewOnStatisticsViewController() throws {
        let app = XCUIApplication()
        app.setIsAppOpenedBefore(true)
        app.launch()
        app.navigationBars["PomodoroCenter.HomeView"].buttons["calendar"].tap()
        app.buttons["monthly".localized].tap()

        let lineChartView = app.otherElements["lineChartView"]
        XCTAssertTrue(lineChartView.exists, "Line chart view is not exists on statistics view controller")
    }
}
