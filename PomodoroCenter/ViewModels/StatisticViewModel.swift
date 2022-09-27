import Foundation

final class StatisticViewModel {
    
    private var pomodoroMinutesByDay: [TimeByDay] = []
    private let database: PomodoroDatabaseProtocol
    
    var getPomodoroTimesByDay:(([TimeByDay]) -> Void)? = nil
    
    // MARK: - init
    
    init(database: PomodoroDatabaseProtocol = PomodoroCoreDataDatabase()) {
        self.database = database
    }
    
    // MARK: - Private Methods
    private func findIndexByDay(day: String) -> Int {
        return pomodoroMinutesByDay.firstIndex(where: {$0.dayOfWeek == day}) ?? -1
    }
    
    private func addTimeInPomodoroTimes(day: String, saveDate: Time){
        let index = findIndexByDay(day: day)
        
        if index != -1 {
            pomodoroMinutesByDay[index].minutes = pomodoroMinutesByDay[index].minutes + Double(saveDate.time) / 60.0
        }
        else {
            pomodoroMinutesByDay.append(TimeByDay(dayOfWeek: day, minutes: Double(saveDate.time) / 60.0))
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
                    addTimeInPomodoroTimes(
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
    
}
