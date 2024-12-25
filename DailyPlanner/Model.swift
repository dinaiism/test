import Foundation

var tasksList = [Task]()

struct Task: Codable {
    let id: Int
    let dateStart: TimeInterval
    let dateFinish: TimeInterval
    let name: String
    let description: String
}
    
