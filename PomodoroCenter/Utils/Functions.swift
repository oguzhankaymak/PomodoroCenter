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

func secondsToMinutes(seconds: Int) -> (Int, Int) {
    return ((seconds/60),(seconds%60))
}

func formatSeconds(seconds: Int) -> String {
    let minutesAndSeconds = secondsToMinutes(seconds: seconds)
    return "\(String(format: "%02d", minutesAndSeconds.0)) : \(String(format: "%02d", minutesAndSeconds.1))"
}
