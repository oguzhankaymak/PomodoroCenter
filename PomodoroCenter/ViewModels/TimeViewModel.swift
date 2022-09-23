import Foundation

final class TimeViewModel {
    
    var timer = Timer()
    var timerIsRunning: Bool = false
    
    private var seconds: Int {
        didSet {
            formatSecondsAndSet(seconds: seconds)
        }
    }
    
    private var activeTimeType: TimeType
    private var formatedSeconds: String
    private let database: PomodoroDatabaseProtocol
    
    var onRunningTime: ((String) -> Void)? = nil
    var onCompleteTime: ((TimeType) -> Void)? = nil
    var onFinishTimer: ((String) -> Void)? = nil
    var onSetTimer: ((String) -> Void)? = nil
    
    // MARK: - init

    init(database: PomodoroDatabaseProtocol = PomodoroCoreDataDatabase()) {
        self.database = database
        self.seconds = 1500
        self.formatedSeconds = "25 : 00"
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
            
            onCompleteTime?(activeTimeType)
        }
        onRunningTime?(formatedSeconds)
    }
    
    private func secondsToMinutes(seconds: Int) -> (Int, Int) {
        return ((seconds/60),(seconds%60))
    }
    
    private func formatSecondsAndSet(seconds: Int) {
        let minutesAndSeconds = secondsToMinutes(seconds: seconds)
        formatedSeconds = "\(String(format: "%02d", minutesAndSeconds.0)) : \(String(format: "%02d", minutesAndSeconds.1))"
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
        
        setTime(timeType: activeTimeType)
        onFinishTimer?(formatedSeconds)
    }
    
    func setTime(timeType: TimeType) {
        stopTimer()
        activeTimeType = timeType
        seconds = getTimeByTimeType(timeType: timeType)
        onSetTimer?(formatedSeconds)
    }
    
}
