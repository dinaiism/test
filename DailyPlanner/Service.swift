
import Foundation

final class TaskService {
 
    private var tasks: [Task] = []
    
    func loadTasks(completion: @escaping ([Task]) -> Void) {
        guard let url = Bundle.main.url(forResource: "Tasks", withExtension: "json") else {
            print("Error: Tasks.json file not found")
            completion([])
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            self.tasks = try decoder.decode([Task].self, from: data)
            completion(self.tasks)
        } catch {
            print("Error loading tasks: \(error.localizedDescription)")
            completion([])
        }
    }
    
    func getTasks(for date: Date) -> [Task] {
        return tasks.filter { task in
            let taskDate = Date(timeIntervalSince1970: task.dateStart)
            return Calendar.current.isDate(taskDate, inSameDayAs: date)
        }
    }
    
    func getTasksForHour(date: Date, hour: Int) -> [Task] {
        return tasks.filter { task in
            let taskDate = Date(timeIntervalSince1970: task.dateStart)
            return Calendar.current.isDate(taskDate, inSameDayAs: date) &&
                   Calendar.current.component(.hour, from: taskDate) == hour
        }
    }
}



private extension TaskService {

    func isTask(_ task: Task, in date: Date, at hour: Int) -> Bool {
        let taskDate = Date(timeIntervalSince1970: task.dateStart)
        return Calendar.current.isDate(taskDate, inSameDayAs: date) &&
               Calendar.current.component(.hour, from: taskDate) == hour
    }
}
