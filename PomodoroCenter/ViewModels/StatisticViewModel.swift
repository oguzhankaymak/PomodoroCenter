import Foundation

final class StatisticViewModel {
    
    private var pomodoroMinutesByDay: [TimeByDay] = []
    private var pomodoroHoursByMonth: [TimeByMonth] = []
    private let database: PomodoroDatabaseProtocol
    
    var getPomodoroTimesByDay:(([TimeByDay]) -> Void)? = nil
    var getPomodoroTimesByMonth:(([TimeByMonth]) -> Void)? = nil
    
    // MARK: - init
    
    init(database: PomodoroDatabaseProtocol = PomodoroCoreDataDatabase()) {
        self.database = database
    }
    
    // MARK: - Private Methods
    private func findDataIndexInPomodoroMinutesByDay(day: String) -> Int {
        return pomodoroMinutesByDay.firstIndex(where: {$0.dayOfWeek == day}) ?? -1
    }
    
    private func findDataIndexInPomodoroHoursByMonth(month: String) -> Int {
        return pomodoroHoursByMonth.firstIndex(where: {$0.monthOfYear == month}) ?? -1
    }
    
    private func addTimeInPomodoroTimesByDay(day: String, saveDate: Time){
        let index = findDataIndexInPomodoroMinutesByDay(day: day)
        
        if index != -1 {
            pomodoroMinutesByDay[index].minutes = pomodoroMinutesByDay[index].minutes + Double(saveDate.time) / 60.0
        }
        else {
            pomodoroMinutesByDay.append(TimeByDay(dayOfWeek: day, minutes: Double(saveDate.time) / 60.0))
        }
    }
    
    private func addTimeInPomodoroTimesByMonth(month: String, saveDate: Time){
        let index = findDataIndexInPomodoroHoursByMonth(month: month)
        
        if index != -1 {
            pomodoroHoursByMonth[index].hours = pomodoroHoursByMonth[index].hours + Double(saveDate.time) / 120.0
        }
        else {
            pomodoroHoursByMonth.append(TimeByMonth(monthOfYear: month, hours: Double(saveDate.time) / 120.0))
        }
    }
    
    // MARK: - Public Methods
    
    func getSavedPomodoroTimesByDay(){
        let savedTimes = database.getSavedTimesByType(type: .pomodoro)
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -6, to: Date())
        
        
        guard let oneWeekAgo = oneWeekAgo else {
            return
        }
        
        var tempDate = oneWeekAgo
        var isDatePassed = false
        
        while !isDatePassed {
            let dayStr = dayOfWeek(date: tempDate)
            
            let filterDataByToday = savedTimes.filter { time in
                return Calendar.current.compare(tempDate,
                                                to: time.date,
                                                toGranularity: .day) == .orderedSame
            }
            
            if(filterDataByToday.isEmpty) {
                pomodoroMinutesByDay.append(
                    TimeByDay(
                        dayOfWeek: dayStr,
                        minutes: 0
                    )
                )
            }
            
            else {
                for time in filterDataByToday {
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
        getPomodoroTimesByDay?(pomodoroMinutesByDay)
        
    }
    
    func getSavedPomodoroTimesByMonth(){
        let savedTimes = database.getSavedTimesByType(type: .pomodoro)
        let sixMonthAgo = Calendar.current.date(byAdding: .month, value: -6, to: Date())
        
        
        guard let sixMonthAgo = sixMonthAgo else {
            return
        }
        
        var tempDate = sixMonthAgo
        var isDatePassed = false
        
        while !isDatePassed {
            let monthStr = monthOfYear(date: tempDate)
            
            let filterDataByMonth = savedTimes.filter { time in
                return Calendar.current.compare(tempDate,
                                                to: time.date,
                                                toGranularity: .month) == .orderedSame
            }
            
            if(filterDataByMonth.isEmpty) {
                pomodoroHoursByMonth.append(
                    TimeByMonth(
                        monthOfYear: monthStr,
                        hours: 0
                    )
                )
            }
            
            else {
                for time in filterDataByMonth {
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
        getPomodoroTimesByMonth?(pomodoroHoursByMonth)
    }
    
}
