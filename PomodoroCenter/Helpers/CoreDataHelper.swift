import UIKit

class CoreDataHelper {
    static let shared = CoreDataHelper()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func getSavedTimesByType(type: TimeType) -> [Time] {
        do {
            var historiesData: [Time] = []
            let results = try self.context.fetch(History.fetchRequest())
            if !results.isEmpty {
                for result in results {
                    let resultTimeModel = Time(
                        id: result.id ?? UUID(),
                        date: result.date ?? Date.now,
                        time: Int(result.time),
                        timeType: TimeType(rawValue: result.timeType ?? "") ?? .pomodoro
                    )
                    if type == resultTimeModel.timeType {
                        historiesData.append(resultTimeModel)
                    }
                }
            }
            return historiesData
        } catch {
            print("error: \(error.localizedDescription)")
            return []
        }
    }

    func saveTime(time: Int, timeType: TimeType) {
        let history = History(context: context)
        history.id = UUID()
        history.date = Date.now
        history.time = Int32(time)
        history.timeType = timeType.rawValue
        do {
            try self.context.save()
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
}
