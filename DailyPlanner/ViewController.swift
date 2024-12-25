import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var tableView: UITableView!
        
    private let taskService = TaskService()
    private var tasks: [Task] = []
    private var selectedDate = Date()
    private let hours = Array(0...23)
    private var totalSquares = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    private func setupUI() {
        setupCollectionView()
        setupTableView()
        setMonthView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        setCellsView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventCell.self, forCellReuseIdentifier: "cellID")
    }
    
    private func loadData() {
        taskService.loadTasks { [weak self] tasks in
            self?.tasks = tasks
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func setCellsView() {
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2) / 8
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    private func setMonthView() {
        totalSquares.removeAll()
        
        let daysInMonth = CalendarFormatter().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarFormatter().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarFormatter().weekDay(date: firstDayOfMonth)
        
        var count: Int = 1
        
        while(count <= 42) {
            if(count <= startingSpaces || count - startingSpaces > daysInMonth) {
                totalSquares.append("")
            } else {
                totalSquares.append(String(count - startingSpaces))
            }
            count += 1
        }
        
        monthLabel.text = CalendarFormatter().monthString(date: selectedDate)
            + " " + CalendarFormatter().yearString(date: selectedDate)
        collectionView.reloadData()
    }
    
        @IBAction private func previousMonth(_ sender: Any) {
        selectedDate = CalendarFormatter().minusMonth(date: selectedDate)
        setMonthView()
        tableView.reloadData()
    }
    
    @IBAction private func nextMonth(_ sender: Any) {
        selectedDate = CalendarFormatter().plusMonth(date: selectedDate)
        setMonthView()
        tableView.reloadData()
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
        
        let dayString = totalSquares[indexPath.item]
        cell.dayOfMonth.text = dayString
        cell.backgroundColor = .clear
        
        if let dayInt = Int(dayString) {
            let components = Calendar.current.dateComponents([.year, .month], from: selectedDate)
            var dayComponents = DateComponents()
            dayComponents.year = components.year
            dayComponents.month = components.month
            dayComponents.day = dayInt
            
            if let cellDate = Calendar.current.date(from: dayComponents),
               Calendar.current.isDate(cellDate, inSameDayAs: selectedDate) {
                cell.dayOfMonth.textColor = .blue
            } else {
                cell.dayOfMonth.textColor = .black
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dayString = totalSquares[indexPath.item]
        guard !dayString.isEmpty else { return }
        
        if let day = Int(dayString) {
            var components = Calendar.current.dateComponents([.year, .month], from: selectedDate)
            components.day = day
            if let newDate = Calendar.current.date(from: components) {
                selectedDate = newDate
                tableView.reloadData()
            }
        }
    }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! EventCell
        
        let hour = hours[indexPath.row]
        let hourString = String(format: "%02d:00-%02d:00", hour, hour + 1)
        
        if let task = taskService.getTasksForHour(date: selectedDate, hour: hour).first {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            _ = timeFormatter.string(from: Date(timeIntervalSince1970: task.dateStart))
            
            cell.eventLabel.text = "\(hourString)\n\(task.name)"
            cell.backgroundColor = UIColor.lightGray
        } else {
            cell.eventLabel.text = hourString
            cell.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hour = hours[indexPath.row]
        
        if let task = taskService.getTasksForHour(date: selectedDate, hour: hour).first {
            if let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
                detailVC.task = task
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
