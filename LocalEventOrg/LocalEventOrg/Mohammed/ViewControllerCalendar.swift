import UIKit
import FirebaseDatabase

class ViewControllerCalendar: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView! // TableView for events
    
    // MARK: - Properties
    var selectedDate = Date() // Tracks the currently selected date
    var totalSquares = [String]() // Stores the days to display in the calendar grid
    var selectedIndexPath: IndexPath? // Tracks the selected cell in the calendar
    var filteredEvents: [[String: Any]] = [] // Events filtered to match the selected date
    var events: [[String: Any]] = [] // All events fetched from the database

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up collection view and table view delegates and data sources
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register a default UITableViewCell for the table view
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EventCell")
        
        setCellsView() // Configure the appearance of the collection view cells
        setMonthView() // Set the initial view for the calendar month
        
        // Fetch events from Firebase and initialize filtered events
        populateEventsForCalendar { fetchedEvents in
            DispatchQueue.main.async {
                self.events = fetchedEvents
                self.filterEvents(for: self.selectedDate)
            }
        }
    }

    // MARK: - UI Configuration
    func setCellsView() {
        // Calculate the size of calendar cells based on the collection view dimensions
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2) / 8
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: width, height: height)
        }
    }
    
    func setMonthView() {
        // Populate the totalSquares array with days for the current month view
        totalSquares.removeAll()
        
        let calendarHelper = CalendarHelper()
        let daysInMonth = calendarHelper.daysInMonth(date: selectedDate)
        let firstDayOfMonth = calendarHelper.firstOfMonth(date: selectedDate)
        let startingSpaces = calendarHelper.weekDay(date: firstDayOfMonth)
        
        for count in 1...42 {
            if count <= startingSpaces || count - startingSpaces > daysInMonth {
                totalSquares.append("") // Empty squares for days outside the month
            } else {
                totalSquares.append(String(count - startingSpaces)) // Days of the month
            }
        }
        
        // Update the month label and reload the collection view
        monthLabel.text = "\(calendarHelper.monthString(date: selectedDate)) \(calendarHelper.yearString(date: selectedDate))"
        collectionView.reloadData()
    }
    
    // MARK: - Event Filtering
    func filterEvents(for selectedDate: Date) {
        // Filter events that match the selected date or fall within a date range
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let selectedDateString = dateFormatter.string(from: selectedDate)
        print("Filtering events for: \(selectedDateString)")
        
        filteredEvents = events.filter { event in
            if let eventDate = event["Date"] as? String {
                let dateComponents = eventDate.split(separator: "–").map { $0.trimmingCharacters(in: .whitespaces) }
                
                if dateComponents.count == 1 {
                    return dateComponents[0] == selectedDateString
                } else if dateComponents.count == 2 {
                    if let startDate = dateFormatter.date(from: dateComponents[0]),
                       let endDate = dateFormatter.date(from: dateComponents[1]) {
                        return selectedDate >= startDate && selectedDate <= endDate
                    }
                }
            }
            return false
        }
        
        print("Filtered events: \(filteredEvents)")
        tableView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as? CalendarCell else {
            fatalError("Failed to dequeue CalendarCell.")
        }
        
        let day = totalSquares[indexPath.row]
        cell.dayOfMonth.text = day // Set the day number in the cell
        
        if let dayInt = Int(day), isCurrentDate(day: dayInt) {
            // Highlight the current date
            cell.dayOfMonth.textColor = .blue
            cell.dayOfMonth.font = UIFont.boldSystemFont(ofSize: 16)
        } else {
            // Style for non-current dates
            cell.dayOfMonth.textColor = .black
            cell.dayOfMonth.font = UIFont.systemFont(ofSize: 14)
        }
        
        if indexPath == selectedIndexPath {
            // Highlight the selected cell
            cell.selectionCircle.isHidden = false
            cell.selectionCircle.backgroundColor = .gray
        } else {
            cell.selectionCircle.isHidden = true
        }
        
        if let dayInt = Int(day) {
            // Check if the day has events and change text color
            var components = Calendar.current.dateComponents([.year, .month], from: selectedDate)
            components.day = dayInt
            if let date = Calendar.current.date(from: components), hasEvent(on: date) {
                cell.dayOfMonth.textColor = .red
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath // Track the selected cell
        collectionView.reloadData()
        
        let dayString = totalSquares[indexPath.row]
        if let day = Int(dayString) {
            // Calculate the selected date
            var components = Calendar.current.dateComponents([.year, .month], from: selectedDate)
            components.day = day
            if let selectedDayDate = Calendar.current.date(from: components) {
                filterEvents(for: selectedDayDate)
            }
        }
    }
    
    // MARK: - Helper Methods
    func isCurrentDate(day: Int) -> Bool {
        // Check if the given day matches the current day, month, and year
        let calendar = Calendar.current
        let today = calendar.component(.day, from: Date())
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        
        let selectedMonth = calendar.component(.month, from: selectedDate)
        let selectedYear = calendar.component(.year, from: selectedDate)
        
        return day == today && currentMonth == selectedMonth && currentYear == selectedYear
    }
    
    func hasEvent(on date: Date) -> Bool {
        // Check if any event matches the given date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let dateString = dateFormatter.string(from: date)
        
        return events.contains { event in
            if let eventDate = event["Date"] as? String {
                let dateComponents = eventDate.split(separator: "–").map { $0.trimmingCharacters(in: .whitespaces) }
                
                if dateComponents.count == 1 {
                    return dateComponents[0] == dateString
                } else if dateComponents.count == 2 {
                    if let startDate = dateFormatter.date(from: dateComponents[0]),
                       let endDate = dateFormatter.date(from: dateComponents[1]) {
                        return date >= startDate && date <= endDate
                    }
                }
            }
            return false
        }
    }
    
    // MARK: - Month Navigation
    @IBAction func nextMonth(_ sender: Any) {
        // Navigate to the next month
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        selectedIndexPath = nil
        setMonthView()
        collectionView.reloadData()
    }
    
    @IBAction func previousMonth(_ sender: Any) {
        // Navigate to the previous month
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        selectedIndexPath = nil
        setMonthView()
        collectionView.reloadData()
    }
    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return 1 if no events match the selected date, otherwise return the count of filtered events
        return filteredEvents.isEmpty ? 1 : filteredEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        
        if filteredEvents.isEmpty {
            // Display a placeholder message when no events are available
            cell.textLabel?.text = "No events today!"
            cell.textLabel?.textColor = .gray
            cell.textLabel?.textAlignment = .center
        } else {
            // Display event details
            let event = filteredEvents[indexPath.row]
            let eventName = event["Name"] as? String ?? "Unnamed Event"
            let eventLocation = event["Location"] as? String ?? "No location provided"
            
            cell.textLabel?.text = "\(eventName) - \(eventLocation)"
            cell.textLabel?.textColor = .black
            cell.textLabel?.textAlignment = .left
        }
        
        return cell
    }
}


