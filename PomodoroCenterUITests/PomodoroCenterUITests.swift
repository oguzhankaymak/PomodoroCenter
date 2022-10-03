//
//  PomodoroCenterUITests.swift
//  PomodoroCenterUITests
//
//  Created by Oğuzhan Kaymak on 1.10.2022.
//

import XCTest

class PomodoroCenterUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testChangePomodoroTimerToBreakTimer() throws {
        let app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.buttons["Break"]/*[[".segmentedControls.buttons[\"Break\"]",".buttons[\"Break\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let timerValue = app.staticTexts["timeLabel"].label
        XCTAssertEqual(timerValue, "05 : 00", "Timer is not correct")
    }
    
    func testChangeShortBreakTimerToLongBreakTimer() throws {
        let app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.buttons["Break"]/*[[".segmentedControls.buttons[\"Break\"]",".buttons[\"Break\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["15"].tap()

        let timerValue = app.staticTexts["timeLabel"].label
        XCTAssertEqual(timerValue, "15 : 00", "Timer is not correct")
        
    }

    func testShowAlertMessageIfChangeTimerTypeWhenTimerIsRunningAndTimeDontChangeIfUserSelectCancel() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["play"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Break"]/*[[".segmentedControls.buttons[\"Break\"]",".buttons[\"Break\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Uyarı"].scrollViews.otherElements.buttons["Vazgeç"].tap()
        
        let timerValue = app.staticTexts["timeLabel"].label
        XCTAssertNotEqual(timerValue, "25 : 00", "Timer is not correct")
        XCTAssertNotEqual(timerValue, "15 : 00", "Timer is not correct")
        XCTAssertNotEqual(timerValue, "05 : 00", "Timer is not correct")
    }
    
    func testShowAlertMessageIfChangeTimerTypeWhenTimerIsRunningAndTimeMustBeChangeIfUserSelectOkay() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["play"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Break"]/*[[".segmentedControls.buttons[\"Break\"]",".buttons[\"Break\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Uyarı"].scrollViews.otherElements.buttons["Tamam"].tap()
        
        let timerValue = app.staticTexts["timeLabel"].label
        XCTAssertEqual(timerValue, "05 : 00", "Timer is not correct")
    }
    
    func testExistsBarChartViewOnStatisticsViewController() throws {
        let app = XCUIApplication()
        app.launch()
        app.navigationBars["PomodoroCenter.HomeView"].buttons["calendar"].tap()
        
        let barChartView = app.otherElements["barChartView"]
        XCTAssertTrue(barChartView.exists, "Bar chart view is not exists on statistics view controller")
    }
    
    func testExistsLineChartViewOnStatisticsViewController() throws {
        let app = XCUIApplication()
        app.launch()
        app.navigationBars["PomodoroCenter.HomeView"].buttons["calendar"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Aylık"]/*[[".segmentedControls.buttons[\"Aylık\"]",".buttons[\"Aylık\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let lineChartView = app.otherElements["lineChartView"]
        XCTAssertTrue(lineChartView.exists, "Line chart view is not exists on statistics view controller")
        
        
    }
}
