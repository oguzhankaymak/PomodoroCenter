import Foundation
import UIKit
import CoreData

protocol PomodoroDatabaseProtocol {
    func saveTime(time: Int, timeType: TimeType)
    func getSavedTimesByType (type: TimeType) -> [Time]
}

class PomodoroCoreDataDatabase: PomodoroDatabaseProtocol {
    let coreDataHelper = CoreDataHelper()

    func saveTime(time: Int, timeType: TimeType) {
        coreDataHelper.saveTime(time: time, timeType: timeType)
    }

    func getSavedTimesByType(type: TimeType) -> [Time] {
        coreDataHelper.getSavedTimesByType(type: type)
    }
}
