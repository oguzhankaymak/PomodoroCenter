import Foundation
@testable import PomodoroCenter


class PomodoroDatabaseSpy: PomodoroDatabaseProtocol {
    func saveTime(time: Int, timeType: TimeType) {}
    
    func getSavedTimesByType(type: TimeType) -> [Time] {
        return []
    }
    
}
