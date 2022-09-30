import Foundation

struct TimeByMonth {
    var monthOfYear: String
    var hours: Double
}


extension TimeByMonth: Equatable {
    static func ==(lhs: TimeByMonth, rhs: TimeByMonth) -> Bool {
        return lhs.monthOfYear == rhs.monthOfYear
        && lhs.hours == rhs.hours
    }
}
