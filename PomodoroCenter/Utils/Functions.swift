import Foundation


func dayOfWeek(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    
    let weekDay = dateFormatter.string(from: date)
    return weekDay
}

func monthOfYear(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "LLLL"
    
    let yearMonth = dateFormatter.string(from: date)
    return yearMonth
}
