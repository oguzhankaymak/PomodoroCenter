import XCTest
@testable import PomodoroCenter

class StatisticsViewModelTests: XCTestCase {

    func testModelTriggersOnGetPomodoroTimesByDaysWhenCallGetSavedPomodoroTimesByDays() {
        let model = StatisticViewModel(database: PomodoroDatabaseSpy())

        model.pomodoroHoursByDays.bind { pomodoroHoursByDays in
            XCTAssertEqual(pomodoroHoursByDays?.count, 7, "Model didn't return Hours data by days")
        }

        model.getSavedPomodoroTimesByDays()
    }

    func testModelReturnCorrectDataWhenTriggersOnGetPomodoroTimesByDays() {
        let mockPomodoroHoursByDaysData: [TimeByDay] = createMockPomodoroHoursByDaysData()

        let model = StatisticViewModel(database: PomodoroDatabaseSpy())

        model.pomodoroHoursByDays.bind { pomodoroHoursByDays in
            pomodoroHoursByDays?.indices.forEach { index in
                if pomodoroHoursByDays?[index] != mockPomodoroHoursByDaysData[index] {
                    return XCTFail("Model didn't correctly return hours data by days!")
                }
            }
        }

        model.getSavedPomodoroTimesByDays()
    }

    func testModelTriggersOnGetPomodoroTimesByMonthsWhenCallGetSavedPomodoroTimesByMonths() {
        let model = StatisticViewModel(database: PomodoroDatabaseSpy())

        model.pomodoroHoursByMonths.bind { pomodoroHoursByMonths in
            XCTAssertEqual(pomodoroHoursByMonths?.count, 7, "Model didn't return hours data by months!")
        }

        model.getSavedPomodoroTimesByMonths()
    }

    func testModelReturnCorrectDataWhenTriggersOnGetPomodoroTimesByMonths() {
        let mockPomodoroHoursByMonthsData: [TimeByMonth] = createMockPomodoroHoursByMonthsData()

        let model = StatisticViewModel(database: PomodoroDatabaseSpy())

        model.pomodoroHoursByMonths.bind { pomodoroHoursByMonths in
            pomodoroHoursByMonths?.indices.forEach { index in
                if pomodoroHoursByMonths?[index] != mockPomodoroHoursByMonthsData[index] {
                    return XCTFail("Model didn't correctly return hours data by months!")
                }
            }
        }

        model.getSavedPomodoroTimesByMonths()
    }

}
