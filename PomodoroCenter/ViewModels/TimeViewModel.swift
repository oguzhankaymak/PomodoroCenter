import Foundation
import UserNotifications

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
        self.seconds = Global.pomodorotime
        self.formatedSeconds = formatSeconds(seconds: self.seconds)
        self.activeTimeType = .pomodoro
    }
    
    // MARK: - Private Methods
    
    @objc private func timerCounter() {
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
            return Global.pomodorotime
        case .longBreak:
            return Global.longBreak
        case .shortBreak:
            return Global.shortBreak
        }
    }
    
    private func createNotificationTitle(completedTimeType: TimeType) -> String {
        switch completedTimeType {
        case .pomodoro:
            return NSLocalizedString("breakTime", comment: "It's notification title when completed one pomodoro.")
        case .longBreak:
            return NSLocalizedString("nowItIsTimeToWork", comment: "It's notification title when completed long break.")
        case .shortBreak:
            return NSLocalizedString("keepWorking", comment: "It's notification title when completed short break.")
        }
    }
    
    private func createNotificationBody(completedTimeType: TimeType) -> String {
        switch completedTimeType {
        case .pomodoro:
            return NSLocalizedString("nowItIsTimeToRest", comment: "It's notification message when completed one pomodoro.")
        case .longBreak:
            return  NSLocalizedString("takeADeepBreathAndGetToWork", comment: "It's notification message when completed long break.")
        case .shortBreak:
            return NSLocalizedString("dontGiveUpAndKeepWorking", comment: "It's notification message when completed short break")
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
    
    func finishtimer() {
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
    
    func sendNotification(completedTimeType: TimeType) {
        let content = UNMutableNotificationContent()
        content.title = createNotificationTitle(completedTimeType: completedTimeType)
        content.body = createNotificationBody(completedTimeType: completedTimeType)
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: "pomodoroCenter",
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
