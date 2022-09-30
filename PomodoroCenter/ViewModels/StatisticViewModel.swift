import Foundation

final class StatisticViewModel {
    
    private var pomodoroMinutesByDays: [TimeByDay] = []
    private var pomodoroHoursByMonths: [TimeByMonth] = []
    private let database: PomodoroDatabaseProtocol
    
    var onGetPomodoroTimesByDays:(([TimeByDay]) -> Void)? = nil
    var onGetPomodoroTimesByMonths:(([TimeByMonth]) -> Void)? = nil
    
    // MARK: - init
    
    init(database: PomodoroDatabaseProtocol = PomodoroCoreDataDatabase()) {
        self.database = database
    }
    
    // MARK: - Private Methods
    private func findDataIndexInPomodoroMinutesByDay(day: String) -> Int {
        return pomodoroMinutesByDays.firstIndex(where: {$0.dayOfWeek == day}) ?? -1
    }
    
    private func findDataIndexInPomodoroHoursByMonth(month: String) -> Int {
        return pomodoroHoursByMonths.firstIndex(where: {$0.monthOfYear == month}) ?? -1
    }
    
    private func addTimeInPomodoroTimesByDay(day: String, saveDate: Time){
        let index = findDataIndexInPomodoroMinutesByDay(day: day)
        
        if index != -1 {
            pomodoroMinutesByDays[index].minutes = pomodoroMinutesByDays[index].minutes + (Double(saveDate.time) / 60.0)
        }
        else {
            pomodoroMinutesByDays.append(TimeByDay(dayOfWeek: day, minutes: Double(saveDate.time) / 60.0))
        }
    }
    
    private func addTimeInPomodoroTimesByMonth(month: String, saveDate: Time){
        let index = findDataIndexInPomodoroHoursByMonth(month: month)
        
        if index != -1 {
            pomodoroHoursByMonths[index].hours = pomodoroHoursByMonths[index].hours + (Double(saveDate.time) / 120.0)
        }
        else {
            pomodoroHoursByMonths.append(TimeByMonth(monthOfYear: month, hours: Double(saveDate.time) / 120.0))
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
                pomodoroMinutesByDays.append(
                    TimeByDay(
                        dayOfWeek: dayStr,
                        minutes: 0
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
        
        onGetPomodoroTimesByDays?(pomodoroMinutesByDays)
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
                        monthOfYear: monthStr,
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
