import Foundation

extension Date {
    func dayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"

        let weekDay = dateFormatter.string(from: self)
        return weekDay
    }

    func monthOfYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"

        let yearMonth = dateFormatter.string(from: self)
        return yearMonth
    }
}
