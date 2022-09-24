import Foundation
import UIKit
import CoreData

protocol PomodoroDatabaseProtocol {
    func saveTime(time: Int, timeType: TimeType) -> Void
    func getSavedTimeByDate (date: Date) -> [Time]
}

class PomodoroCoreDataDatabase: PomodoroDatabaseProtocol {
    
    var appDelegate: AppDelegate
    var context: NSManagedObjectContext
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    func saveTime(time: Int, timeType: TimeType) {
        let history = NSEntityDescription.insertNewObject(forEntityName: "History", into: context)
        history.setValue(UUID(), forKey: "id")
        history.setValue(Date.now, forKey: "date")
        history.setValue(time, forKey: "time")
        history.setValue(timeType.rawValue, forKey: "timeType")
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func getSavedTimeByDate(date: Date) -> [Time] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        fetchRequest.returnsObjectsAsFaults = false
                
        do {
            var historiesData: [Time] = []
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    let id = result.value(forKey: "id") as! UUID
                    let date = result.value(forKey: "date") as! Date
                    let time = result.value(forKey: "time") as! Int
                    let timeType = result.value(forKey: "timeType") as! String
                    
                    historiesData.append(
                        Time(
                            id: id,
                            date: date,
                            time: time,
                            timeType: TimeType(rawValue: timeType) ?? .pomodoro
                        )
                    )
                }
            }

            return historiesData
            
        } catch {
            print(error)
            return []
        }
    }
}
