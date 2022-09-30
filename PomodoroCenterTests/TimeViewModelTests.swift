import XCTest
@testable import PomodoroCenter

class TimeViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testModelRunTimerWhenStartedTimer(){
        let model = TimeViewModel()
        model.startTimer()
        XCTAssertTrue(model.timerIsRunning, "Model didn't timer start!")
    }
    
    func testModelStopTimerDuringRunningTimer(){
        let model = TimeViewModel()
        model.startTimer()
        XCTAssertTrue(model.timerIsRunning, "Model didn't timer start!")
        model.stopTimer()
        XCTAssertFalse(model.timerIsRunning, "Model didn't timer stop!")
    }
    
    func testModelTimeChangeWhenAssignPomodoroTime(){
        let formatedPomodoroTime = "25 : 00"
        let model = TimeViewModel()
        
        model.onAssignTimer = { timeStr in
            XCTAssertEqual(timeStr, formatedPomodoroTime, "Model didn't assign pomodoro time!")
            
        }
        
        model.assignTime(timeType: .pomodoro)
    }
    
    func testModelTimeChangeWhenAssignShortBreakTime(){
        let formatedShortBreakTime = "05 : 00"
        let model = TimeViewModel()
        
        model.onAssignTimer = { timeStr in
            XCTAssertEqual(timeStr, formatedShortBreakTime, "Model didn't assign short break time!")
        }
        
        model.assignTime(timeType: .shortBreak)
    }
    
    func testModelTimeChangeWhenAssignLongBreakTime(){
        let formatedLongBreakTime = "15 : 00"
        let model = TimeViewModel()
        model.onAssignTimer = { value in
            XCTAssertEqual(value, formatedLongBreakTime, "Model didn't assign long break time!")
            
        }
        
        model.assignTime(timeType: .longBreak)
    }
    
    func testModelTriggersOnFinishTimerWhenUserWantsTimeToEnd(){
        let formatedPomodoroTime = "25 : 00"
        let model = TimeViewModel(database: PomodoroDatabaseSpy())
        
        model.onFinishTimer = { timeStr in
            XCTAssertEqual(timeStr, formatedPomodoroTime, "Model didn't trigger on finish timer!")
        }
        
        model.startTimer()
        model.stopTimer()
        model.finishtimer()
    }

}
