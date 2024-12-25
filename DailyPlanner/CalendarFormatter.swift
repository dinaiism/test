import Foundation

class CalendarFormatter {
    let calendar = Calendar.current
    
    private let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL"
        return formatter
    }()
    
    private let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    func plusMonth(date: Date) -> Date {
        return calendar.date(byAdding: .month, value: 1, to: date) ?? date
    }
    

    func minusMonth(date: Date) -> Date {
        return calendar.date(byAdding: .month, value: -1, to: date) ?? date
    }
    

    func monthString(date: Date) -> String {
        return monthFormatter.string(from: date)
    }
    
    func yearString(date: Date) -> String {
        return yearFormatter.string(from: date)
    }
    

    func daysInMonth(date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    

    func firstOfMonth(date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components) ?? date
    }
    
    func weekDay(date: Date) -> Int {
        let components = calendar.dateComponents([.weekday], from: date)
        return (components.weekday ?? 1) - 1
    }
}
