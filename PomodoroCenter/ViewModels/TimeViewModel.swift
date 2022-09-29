import Foundation

final class TimeViewModel {
    
    var timer = Timer()
    var timerIsRunning: Bool = false
    
    private var seconds: Int {
        didSet {
            formatedSeconds = formatSeconds(seconds: seconds)
        }
    }
    
    private var activeTimeType: TimeType
    private var formatedSeconds: String
    private let database: PomodoroDatabaseProtocol
    
    var onRunningTimer: ((String) -> Void)? = nil
    var onCompleteTimer: ((TimeType) -> Void)? = nil
    var onFinishTimer: ((String) -> Void)? = nil
    var onAssignTimer: ((String) -> Void)? = nil
    
    // MARK: - init

    init(database: PomodoroDatabaseProtocol = PomodoroCoreDataDatabase()) {
        self.database = database
        self.seconds = 1500
        self.formatedSeconds = formatSeconds(seconds: self.seconds)
        self.activeTimeType = .pomodoro
    }
    
    // MARK: - Private Methods
    
    @objc private func timerCounter(){
        seconds = seconds - 1
        
        if seconds == 0 {
            timerIsRunning = false
            timer.invalidate()
            
            database.saveTime(
                time: getTimeByTimeType(timeType: activeTimeType),
                timeType: activeTimeType)
            
            onCompleteTimer?(activeTimeType)
        }
        onRunningTimer?(formatedSeconds)
    }

    
    private func getTimeByTimeType(timeType: TimeType) -> Int {
        switch timeType {
            case .pomodoro:
                return 1500
            case .longBreak:
                return 900
            case .shortBreak:
                return 300
        }
    }
    
    //MARK: - Public Methods
    
    func startTimer() {
        timerIsRunning = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timerIsRunning = false
        timer.invalidate()
    }
    
    func finishtimer(){
        let elapseTime = getTimeByTimeType(timeType: activeTimeType) - seconds
        database.saveTime(time: elapseTime, timeType: activeTimeType)
        
        assignTime(timeType: activeTimeType)
        onFinishTimer?(formatedSeconds)
    }
    
    func assignTime(timeType: TimeType) {
        stopTimer()
        activeTimeType = timeType
        seconds = getTimeByTimeType(timeType: timeType)
        onAssignTimer?(formatedSeconds)
    }
    
    func getFormattedSeconds() -> String {
        return formatedSeconds
    }
    
}
