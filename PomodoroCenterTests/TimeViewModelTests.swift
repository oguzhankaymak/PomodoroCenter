import XCTest
@testable import PomodoroCenter

class TimeViewModelTests: XCTestCase {

    func testModelRunTimerWhenStartedTimer() {
        let model = TimeViewModel()
        model.startOrStopTimer()
        guard let timerIsRunning = model.timerIsRunning.value else { return XCTFail("Model didn't timer start!") }
        XCTAssertTrue(timerIsRunning, "Model didn't timer start!")
    }

    func testModelStopTimerDuringRunningTimer() {
        let model = TimeViewModel()
        model.startOrStopTimer()
        model.startOrStopTimer()
        guard let timerIsRunning = model.timerIsRunning.value else { return XCTFail("Model didn't timer start!") }
        XCTAssertFalse(timerIsRunning, "Model didn't timer stop!")
    }

    func testModelTimeChangeWhenAssignPomodoroTime() {
        let formatedPomodoroTime = "25 : 00"
        let model = TimeViewModel()

        model.formatedSeconds.bind { seconds in
            XCTAssertEqual(formatedPomodoroTime, seconds, "Model didn't assign pomodoro time!")
        }

        model.activeTimeType.bind { activeTimeType in
            guard let timeType = activeTimeType else { return }
            XCTAssertTrue(timeType == .pomodoro, "Model didn't assign pomodoro time!")
        }

        model.assignTime(timeType: .pomodoro)
    }

    func testModelTimeChangeWhenAssignShortBreakTime() {
        let formatedShortBreakTime = "05 : 00"
        let model = TimeViewModel()

        model.formatedSeconds.bind { seconds in
            XCTAssertEqual(formatedShortBreakTime, seconds, "Model didn't assign short break time!")
        }

        model.activeTimeType.bind { activeTimeType in
            guard let timeType = activeTimeType else { return }
            XCTAssertTrue(timeType == .shortBreak, "Model didn't assign short break time!")

        }

        model.assignTime(timeType: .shortBreak)
    }

    func testModelTimeChangeWhenAssignLongBreakTime() {
        let formatedLongBreakTime = "15 : 00"
        let model = TimeViewModel()

        model.formatedSeconds.bind { seconds in
            XCTAssertEqual(formatedLongBreakTime, seconds, "Model didn't assign long break time!")
        }

        model.activeTimeType.bind { activeTimeType in
            guard let timeType = activeTimeType else { return }
            XCTAssertTrue(timeType == .longBreak, "Model didn't assign long break time!")

        }

        model.assignTime(timeType: .longBreak)
    }

    func testModelResetTimerWhenUserWantsTimeToEnd() {
        let formatedPomodoroTime = "25 : 00"
        let model = TimeViewModel(database: PomodoroDatabaseSpy())

        model.startOrStopTimer()
        model.finishtimer()
        XCTAssertEqual(
            formatedPomodoroTime,
            model.formatedSeconds.value,
            "Model didn't trigger on finish timer!"
        )
    }

}
