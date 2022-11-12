import Foundation

final class StatisticViewModel {

    private(set) var pomodoroHoursByDays: Observable<[TimeByDay]> = Observable()
    private(set) var pomodoroHoursByMonths: Observable<[TimeByMonth]> = Observable()
    private let database: PomodoroDatabaseProtocol

    private var tempPomodoroHoursByDays: [TimeByDay] = []
    private var tempPomodoroHoursByMonths: [TimeByMonth] = []

    // MARK: - init
    init(database: PomodoroDatabaseProtocol = PomodoroCoreDataDatabase()) {
        self.database = database
    }

    // MARK: - Public Methods
    func getSavedPomodoroTimesByDays() {
        tempPomodoroHoursByDays = pomodoroHoursByDays.value ?? []

        let savedTimes = database.getSavedTimesByType(type: .pomodoro)
        let sixDaysAgo = Calendar.current.date(byAdding: .day, value: -6, to: Date())

        guard let sixDaysAgo = sixDaysAgo else { return }

        var tempDate = sixDaysAgo
        var isDatePassed = false

        while !isDatePassed {
            let dayStr = tempDate.dayOfWeek()

            let filteredDataByTempDate = savedTimes.filter { time in
                return Calendar.current.compare(tempDate,
                                                to: time.date,
                                                toGranularity: .day) == .orderedSame
            }

            if filteredDataByTempDate.isEmpty {
                tempPomodoroHoursByDays.append(
                    TimeByDay(
                        day: dayStr,
                        hours: 0
                    )
                )
            } else {
                for time in filteredDataByTempDate {
                    addTimeInPomodoroTimesByDay(
                        day: dayStr,
                        saveDate: time
                    )
                }
            }

            tempDate = Calendar.current.date(
                byAdding: .day,
                value: 1,
                to: tempDate
            )!

            if Calendar.current.compare(Date.now, to: tempDate, toGranularity: .day) == .orderedAscending {
                isDatePassed = true
            }

        }
        pomodoroHoursByDays.value = tempPomodoroHoursByDays
    }

    func getSavedPomodoroTimesByMonths() {
        tempPomodoroHoursByMonths = pomodoroHoursByMonths.value ?? []
        let savedTimes = database.getSavedTimesByType(type: .pomodoro)
        let sixMonthAgo = Calendar.current.date(byAdding: .month, value: -6, to: Date())

        guard let sixMonthAgo = sixMonthAgo else {
            return
        }

        var tempDate = sixMonthAgo
        var isDatePassed = false

        while !isDatePassed {
            let monthStr = tempDate.monthOfYear()

            let filteredDataByTempDate = savedTimes.filter { time in
                return Calendar.current.compare(tempDate,
                                                to: time.date,
                                                toGranularity: .month) == .orderedSame
            }

            if filteredDataByTempDate.isEmpty {
                tempPomodoroHoursByMonths.append(
                    TimeByMonth(
                        month: monthStr,
                        hours: 0
                    )
                )
            } else {
                for time in filteredDataByTempDate {
                    addTimeInPomodoroTimesByMonth(
                        month: monthStr,
                        saveDate: time
                    )
                }
            }

            tempDate = Calendar.current.date(
                byAdding: .month,
                value: 1,
                to: tempDate
            )!

            if Calendar.current.compare(Date.now, to: tempDate, toGranularity: .month) == .orderedAscending {
                isDatePassed = true
            }

        }

        pomodoroHoursByMonths.value = tempPomodoroHoursByMonths
    }

    // MARK: - Private Methods
    private func findDataIndexInPomodoroHoursByDay(day: String) -> Int {
        return tempPomodoroHoursByDays.firstIndex(where: {$0.day == day}) ?? -1
    }

    private func findDataIndexInPomodoroHoursByMonth(month: String) -> Int {
        return tempPomodoroHoursByMonths.firstIndex(where: {$0.month == month}) ?? -1
    }

    private func addTimeInPomodoroTimesByDay(day: String, saveDate: Time) {
        let index = findDataIndexInPomodoroHoursByDay(day: day)

        if index != -1 {
            tempPomodoroHoursByDays[index].hours =
                tempPomodoroHoursByDays[index].hours + (Double(saveDate.time) / 3600.0)
        } else {
            tempPomodoroHoursByDays.append(
                TimeByDay(
                    day: day,
                    hours: Double(saveDate.time) / 3600.0
                )
            )
        }
    }

    private func addTimeInPomodoroTimesByMonth(month: String, saveDate: Time) {
        let index = findDataIndexInPomodoroHoursByMonth(month: month)

        if index != -1 {
            tempPomodoroHoursByMonths[index].hours =
                tempPomodoroHoursByMonths[index].hours + (Double(saveDate.time) / 3600.0)
        } else {
            tempPomodoroHoursByMonths.append(
                TimeByMonth(
                    month: month,
                    hours: Double(saveDate.time) / 3600.0
                )
            )
        }
    }
}
