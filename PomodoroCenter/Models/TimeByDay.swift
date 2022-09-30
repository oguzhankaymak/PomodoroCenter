import Foundation

struct TimeByDay {
    var dayOfWeek: String
    var minutes: Double
}


extension TimeByDay: Equatable {
    static func ==(lhs: TimeByDay, rhs: TimeByDay) -> Bool {
        return lhs.dayOfWeek == rhs.dayOfWeek
        && lhs.minutes == rhs.minutes
    }
}
