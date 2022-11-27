import Foundation
import UserNotifications

final class TimeViewModel {

    private var timer = Timer()
    private(set) var timerIsRunning = Observable<Bool>()
    private var seconds: Int {
        didSet {
            formatedSeconds.value = seconds.formatSeconds()
            if seconds == 0 {
                saveTimeInDatabase(
                    seconds: getTimeByTimeType(timeType: activeTimeType.value ?? .pomodoro),
                    timeType: activeTimeType.value ?? .pomodoro
                )
                timerIsCompleted.value = true
                timerIsCompleted.value = false
            }
        }
    }

    private(set) var activeTimeType = Observable<TimeType>()
    private(set) var formatedSeconds = Observable<String>()
    private(set) var isResetTimer = Observable<Bool>()
    private(set) var timerIsCompleted = Observable<Bool>()
    private let database: PomodoroDatabaseProtocol

    // MARK: - init
    init(database: PomodoroDatabaseProtocol = PomodoroCoreDataDatabase()) {
        self.database = database
        self.seconds = Global.pomodoroInterval
        self.formatedSeconds.value = seconds.formatSeconds()
        self.activeTimeType.value = .pomodoro
        self.timerIsRunning.value = false
        self.isResetTimer.value = false
    }

    // MARK: - Public Methods
    func startTimer() {
        timerIsRunning.value = true
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(timerCounter),
            userInfo: nil,
            repeats: true
        )
    }

    func stopTimer() {
        timerIsRunning.value = false
        timer.invalidate()
    }

    func finishtimer() {
        guard let timeType = activeTimeType.value else { return }

        let elapseTime = getTimeByTimeType(timeType: timeType) - seconds
        saveTimeInDatabase(seconds: elapseTime, timeType: timeType)

        isResetTimer.value = true
        seconds = getTimeByTimeType(timeType: timeType)
        isResetTimer.value = false
    }

    func assignTime(timeType: TimeType) {
        stopTimer()
        activeTimeType.value = timeType
        seconds = getTimeByTimeType(timeType: timeType)
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

    // MARK: - Private Methods
    @objc private func timerCounter() {
        seconds -= 1
        if seconds == 0 {
            timerIsRunning.value = false
            timer.invalidate()
            database.saveTime(
                time: getTimeByTimeType(timeType: activeTimeType.value ?? .pomodoro),
                timeType: activeTimeType.value ?? .pomodoro
            )
        }
    }

    private func getTimeByTimeType(timeType: TimeType) -> Int {
        switch timeType {
        case .pomodoro:
            return Global.pomodoroInterval
        case .longBreak:
            return Global.longBreakInterval
        case .shortBreak:
            return Global.shortBreakInterval
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
            return NSLocalizedString(
                "nowItIsTimeToRest",
                comment: "It's notification message when completed one pomodoro."
            )
        case .longBreak:
            return  NSLocalizedString(
                "takeADeepBreathAndGetToWork",
                comment: "It's notification message when completed long break."
            )
        case .shortBreak:
            return NSLocalizedString(
                "dontGiveUpAndKeepWorking",
                comment: "It's notification message when completed short break"
            )
        }
    }

    private func saveTimeInDatabase(seconds: Int, timeType: TimeType) {
        database.saveTime(time: seconds, timeType: timeType)
    }
}
