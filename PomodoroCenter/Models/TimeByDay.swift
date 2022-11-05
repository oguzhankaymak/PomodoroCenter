import Foundation

struct TimeByDay {
    var day: String
    var hours: Double
}

extension TimeByDay: Equatable {
    static func == (lhs: TimeByDay, rhs: TimeByDay) -> Bool {
        return lhs.day == rhs.day
        && lhs.hours == rhs.hours
    }
}
