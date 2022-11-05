import Foundation

struct TimeByMonth {
    var month: String
    var hours: Double
}

extension TimeByMonth: Equatable {
    static func == (lhs: TimeByMonth, rhs: TimeByMonth) -> Bool {
        return lhs.month == rhs.month
        && lhs.hours == rhs.hours
    }
}
