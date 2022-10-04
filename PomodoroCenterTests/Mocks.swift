import Foundation
@testable import PomodoroCenter

func createMockPomodoroHoursByDaysData() -> [TimeByDay] {
    var mockPomodoroHoursByDaysData: [TimeByDay] = []
    
    let sixDaysAgo = Calendar.current.date(byAdding: .day, value: -6, to: Date())
    
    guard let sixDaysAgo = sixDaysAgo else {
        return []
    }
    
    var tempDate = sixDaysAgo
    var isDatePassed = false
    
    while !isDatePassed {
        let dayStr = dayOfWeek(date: tempDate)
        mockPomodoroHoursByDaysData.append(
            TimeByDay(
                day: dayStr,
                hours: 0
            )
        )
        
        tempDate = Calendar.current.date(
            byAdding: .day,
            value: 1,
            to: tempDate
        )!
        
        
        if(Calendar.current.compare(Date.now, to: tempDate, toGranularity: .day) == .orderedAscending) {
            isDatePassed = true
        }
    }
    
    return mockPomodoroHoursByDaysData
}

func createMockPomodoroHoursByMonthsData() -> [TimeByMonth] {
    var mockPomodoroHoursByMonthsData: [TimeByMonth] = []
    
    let sixMonthAgo = Calendar.current.date(byAdding: .month, value: -6, to: Date())
    
    
    guard let sixMonthAgo = sixMonthAgo else {
        return []
    }
    
    var tempDate = sixMonthAgo
    var isDatePassed = false
    
    while !isDatePassed {
        let monthStr = monthOfYear(date: tempDate)
        
        mockPomodoroHoursByMonthsData.append(
            TimeByMonth(
                month: monthStr,
                hours: 0
            )
        )
        
        tempDate = Calendar.current.date(
            byAdding: .month,
            value: 1,
            to: tempDate
        )!
        
        
        if(Calendar.current.compare(Date.now, to: tempDate, toGranularity: .month) == .orderedAscending) {
            isDatePassed = true
        }
    }
    
    return mockPomodoroHoursByMonthsData
}


