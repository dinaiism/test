import UIKit
class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
        var task: Task?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
        }
        
        private func setupUI() {
            guard let task = task else { return }
            
            titleLabel.font = .boldSystemFont(ofSize: 20)
            titleLabel.text = task.name
            
            dateTimeLabel.font = .systemFont(ofSize: 16)
            let startDate = Date(timeIntervalSince1970: task.dateStart)
            let endDate = Date(timeIntervalSince1970: task.dateFinish)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let dateString = dateFormatter.string(from: startDate)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            let startTimeString = timeFormatter.string(from: startDate)
            let endTimeString = timeFormatter.string(from: endDate)
            
            dateTimeLabel.text = "\(dateString) \(startTimeString) - \(endTimeString)"
            
            descriptionLabel.font = .systemFont(ofSize: 16)
            descriptionLabel.numberOfLines = 0
            descriptionLabel.text = task.description
        }
    }
