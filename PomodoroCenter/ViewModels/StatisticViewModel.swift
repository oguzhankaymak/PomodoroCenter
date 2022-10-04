import Foundation

final class StatisticViewModel {
    
    private var pomodoroHoursByDays: [TimeByDay] = []
    private var pomodoroHoursByMonths: [TimeByMonth] = []
    private let database: PomodoroDatabaseProtocol
    
    var onGetPomodoroTimesByDays:(([TimeByDay]) -> Void)? = nil
    var onGetPomodoroTimesByMonths:(([TimeByMonth]) -> Void)? = nil
    
    // MARK: - init
    
    init(database: PomodoroDatabaseProtocol = PomodoroCoreDataDatabase()) {
        self.database = database
    }
    
    // MARK: - Private Methods
    private func findDataIndexInPomodoroHoursByDay(day: String) -> Int {
        return pomodoroHoursByDays.firstIndex(where: {$0.day == day}) ?? -1
    }
    
    private func findDataIndexInPomodoroHoursByMonth(month: String) -> Int {
        return pomodoroHoursByMonths.firstIndex(where: {$0.month == month}) ?? -1
    }
    
    private func addTimeInPomodoroTimesByDay(day: String, saveDate: Time){
        let index = findDataIndexInPomodoroHoursByDay(day: day)
        
        if index != -1 {
            pomodoroHoursByDays[index].hours = pomodoroHoursByDays[index].hours + ( Double(saveDate.time) / 3600.0 )
        }
        else {
            pomodoroHoursByDays.append(
                TimeByDay(
                    day: day,
                    hours: Double(saveDate.time) / 3600.0
                )
            )
        }
    }
    
    private func addTimeInPomodoroTimesByMonth(month: String, saveDate: Time){
        let index = findDataIndexInPomodoroHoursByMonth(month: month)
        
        if index != -1 {
            pomodoroHoursByMonths[index].hours = pomodoroHoursByMonths[index].hours + (Double(saveDate.time) / 3600.0)
        }
        else {
            pomodoroHoursByMonths.append(
                TimeByMonth(
                    month: month,
                    hours: Double(saveDate.time) / 3600.0
                )
            )
        }
    }
    
    // MARK: - Public Methods
    
    func getSavedPomodoroTimesByDays(){
        let savedTimes = database.getSavedTimesByType(type: .pomodoro)
        let sixDaysAgo = Calendar.current.date(byAdding: .day, value: -6, to: Date())
        
        
        guard let sixDaysAgo = sixDaysAgo else {
            return
        }
        
        var tempDate = sixDaysAgo
        var isDatePassed = false
        
        while !isDatePassed {
            let dayStr = dayOfWeek(date: tempDate)
            
            let filteredDataByTempDate = savedTimes.filter { time in
                return Calendar.current.compare(tempDate,
                                                to: time.date,
                                                toGranularity: .day) == .orderedSame
            }
            
            if(filteredDataByTempDate.isEmpty) {
                pomodoroHoursByDays.append(
                    TimeByDay(
                        day: dayStr,
                        hours: 0
                    )
                )
            }
            
            else {
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
            
            
            if(Calendar.current.compare(Date.now, to: tempDate, toGranularity: .day) == .orderedAscending) {
                isDatePassed = true
            }
            
        }
        
        onGetPomodoroTimesByDays?(pomodoroHoursByDays)
    }
    
    func getSavedPomodoroTimesByMonths(){
        let savedTimes = database.getSavedTimesByType(type: .pomodoro)
        let sixMonthAgo = Calendar.current.date(byAdding: .month, value: -6, to: Date())
        
        
        guard let sixMonthAgo = sixMonthAgo else {
            return
        }
        
        var tempDate = sixMonthAgo
        var isDatePassed = false
        
        while !isDatePassed {
            let monthStr = monthOfYear(date: tempDate)
            
            let filteredDataByTempDate = savedTimes.filter { time in
                return Calendar.current.compare(tempDate,
                                                to: time.date,
                                                toGranularity: .month) == .orderedSame
            }
            
            if(filteredDataByTempDate.isEmpty) {
                pomodoroHoursByMonths.append(
                    TimeByMonth(
                        month: monthStr,
                        hours: 0
                    )
                )
            }
            
            else {
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
            
            
            if(Calendar.current.compare(Date.now, to: tempDate, toGranularity: .month) == .orderedAscending) {
                isDatePassed = true
            }
            
        }
        
        onGetPomodoroTimesByMonths?(pomodoroHoursByMonths)
    }
    
}
