import XCTest
@testable import PomodoroCenter

class StatisticsViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testModelTriggersOnGetPomodoroTimesByDaysWhenCallGetSavedPomodoroTimesByDays(){
        let model = StatisticViewModel(database: PomodoroDatabaseSpy())
        
        model.onGetPomodoroTimesByDays = { pomodoroHoursByDays in
            XCTAssertEqual(pomodoroHoursByDays.count, 7, "Model didn't return Hours data by days")
        }
        
        model.getSavedPomodoroTimesByDays()
    }
    
    func testModelReturnCorrectDataWhenTriggersOnGetPomodoroTimesByDays(){
        let mockPomodoroHoursByDaysData: [TimeByDay] = createMockPomodoroHoursByDaysData()
        
        let model = StatisticViewModel(database: PomodoroDatabaseSpy())
        
        model.onGetPomodoroTimesByDays = { pomodoroHoursByDays in
            for (index, dayData) in pomodoroHoursByDays.enumerated() {
                if dayData != mockPomodoroHoursByDaysData[index] {
                    return XCTFail("Model didn't correctly return hours data by days!")
                }
            }
        }
        
        model.getSavedPomodoroTimesByDays()
    }
    
    func testModelTriggersOnGetPomodoroTimesByMonthsWhenCallGetSavedPomodoroTimesByMonths(){
        let model = StatisticViewModel(database: PomodoroDatabaseSpy())
        
        model.onGetPomodoroTimesByMonths = { pomodoroHoursByMonths in
            XCTAssertEqual(pomodoroHoursByMonths.count, 7, "Model didn't return hours data by months!")
        }
        
        model.getSavedPomodoroTimesByMonths()
    }
    
    func testModelReturnCorrectDataWhenTriggersOnGetPomodoroTimesByMonths(){
        let mockPomodoroHoursByMonthsData: [TimeByMonth] = createMockPomodoroHoursByMonthsData()
        
        let model = StatisticViewModel(database: PomodoroDatabaseSpy())
        
        model.onGetPomodoroTimesByMonths = { pomodoroHoursByMonths in
            for (index, monthData) in pomodoroHoursByMonths.enumerated() {
                if monthData != mockPomodoroHoursByMonthsData[index] {
                    return XCTFail("Model didn't correctly return hours data by months!")
                }
            }
        }
        
        model.getSavedPomodoroTimesByMonths()
    }
    
}
