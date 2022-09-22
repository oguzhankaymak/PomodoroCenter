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
    
    var onRunningTime: ((String) -> Void)? = nil
    var onCompleteTime: ((TimeType) -> Void)? = nil
    var onFinishTimer: ((String) -> Void)? = nil
    var onSetTimer: ((String) -> Void)? = nil
    
    // MARK: - init

    init() {
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
            print("complete : \(activeTimeType)")
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
        timerIsRunning = false
        setTime(timeType: activeTimeType)
        onFinishTimer?(formatedSeconds)
    }
    
    func setTime(timeType: TimeType) {
        stopTimer()
        if(timeType == .pomodoro){
            seconds = 1500
            activeTimeType = .pomodoro
        }
        else if(timeType == .longBreak) {
            seconds = 900
            activeTimeType = .longBreak
        }
        else if(timeType == .shortBreak){
            seconds = 300
            activeTimeType = .shortBreak
        }
        onSetTimer?(formatedSeconds)
    }
    
}
