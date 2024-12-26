import UIKit
import FirebaseDatabase

class ViewControllerCalendar: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView! // TableView for events
    
    var selectedDate = Date()
    var totalSquares = [String]()
    var selectedIndexPath: IndexPath? // Track the selected cell
    var filteredEvents: [[String: Any]] = [] // Events matching the selected date
    var events: [[String: Any]] = [] // All events fetched from the database

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the collection view and table view
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EventCell") // Register default cell
        
        setCellsView()
        setMonthView()
        
        // Fetch events from Firebase
        populateEventsForCalendar { fetchedEvents in
            DispatchQueue.main.async {
                self.events = fetchedEvents // Store all fetched events
                self.filterEvents(for: self.selectedDate) // Initially filter events for the current date
            }
        }
    }

    func setCellsView() {
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2) / 8
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: width, height: height)
        }
    }
    
    func setMonthView() {
        totalSquares.removeAll()
        
        let calendarHelper = CalendarHelper()
        let daysInMonth = calendarHelper.daysInMonth(date: selectedDate)
        let firstDayOfMonth = calendarHelper.firstOfMonth(date: selectedDate)
        let startingSpaces = calendarHelper.weekDay(date: firstDayOfMonth)
        
        for count in 1...42 {
            if count <= startingSpaces || count - startingSpaces > daysInMonth {
                totalSquares.append("")
            } else {
                totalSquares.append(String(count - startingSpaces))
            }
        }
        
        monthLabel.text = "\(calendarHelper.monthString(date: selectedDate)) \(calendarHelper.yearString(date: selectedDate))"
        collectionView.reloadData()
    }
    
    func filterEvents(for selectedDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" // Match the format of your event dates in the database
        
        let selectedDateString = dateFormatter.string(from: selectedDate)
        print("Filtering events for: \(selectedDateString)")
        
        filteredEvents = events.filter { event in
            if let eventDate = event["Date"] as? String {
                // Split the date range if present
                let dateComponents = eventDate.split(separator: "–").map { $0.trimmingCharacters(in: .whitespaces) }
                
                if dateComponents.count == 1 {
                    return dateComponents[0] == selectedDateString
                } else if dateComponents.count == 2 {
                    // Date range match
                    if let startDate = dateFormatter.date(from: dateComponents[0]),
                       let endDate = dateFormatter.date(from: dateComponents[1]) {
                        return selectedDate >= startDate && selectedDate <= endDate
                    }
                }
            }
            return false
        }
        
        print("Filtered events: \(filteredEvents)")
        tableView.reloadData() // Reload the table view
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as? CalendarCell else {
            fatalError("Failed to dequeue CalendarCell.")
        }
        
        let day = totalSquares[indexPath.row]
        cell.dayOfMonth.text = day
        
        // Style for the current date
        if let dayInt = Int(day), isCurrentDate(day: dayInt) {
            cell.dayOfMonth.textColor = .blue
            cell.dayOfMonth.font = UIFont.boldSystemFont(ofSize: 16)
        } else {
            cell.dayOfMonth.textColor = .black
            cell.dayOfMonth.font = UIFont.systemFont(ofSize: 14)
        }
        
        // Grey circle for selected dates
        if indexPath == selectedIndexPath {
            cell.selectionCircle.isHidden = false // Show the circle
            cell.selectionCircle.backgroundColor = .gray // Set circle color to grey
        } else {
            cell.selectionCircle.isHidden = true // Hide the circle for other cells
        }
        
        // Change text color for dates with events
        if let dayInt = Int(day) {
            var components = Calendar.current.dateComponents([.year, .month], from: selectedDate)
            components.day = dayInt
            if let date = Calendar.current.date(from: components), hasEvent(on: date) {
                cell.dayOfMonth.textColor = .red
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        collectionView.reloadData()
        
        // Get the selected date
        let dayString = totalSquares[indexPath.row]
        if let day = Int(dayString) { // Safely convert dayString to an Int
            var components = Calendar.current.dateComponents([.year, .month], from: selectedDate)
            components.day = day
            if let selectedDayDate = Calendar.current.date(from: components) {
                filterEvents(for: selectedDayDate) // Update events for the selected date
            }
        }
    }
    
    func isCurrentDate(day: Int) -> Bool {
        let calendar = Calendar.current
        let today = calendar.component(.day, from: Date())
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        
        let selectedMonth = calendar.component(.month, from: selectedDate)
        let selectedYear = calendar.component(.year, from: selectedDate)
        
        return day == today && currentMonth == selectedMonth && currentYear == selectedYear
    }
    
    func hasEvent(on date: Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" // Match the event date format
        
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
    
    @IBAction func nextMonth(_ sender: Any) {
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        selectedIndexPath = nil
        setMonthView()
        collectionView.reloadData()
    }
    
    @IBAction func previousMonth(_ sender: Any) {
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        selectedIndexPath = nil
        setMonthView()
        collectionView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents.isEmpty ? 1 : filteredEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        
        if filteredEvents.isEmpty {
            cell.textLabel?.text = "No events today!" // Default message when no events
            cell.textLabel?.textColor = .gray
            cell.textLabel?.textAlignment = .center
        } else {
            let event = filteredEvents[indexPath.row]
            
            // Get event details
            let eventName = event["Name"] as? String ?? "Unnamed Event"
            let eventLocation = event["Location"] as? String ?? "No location provided"
            
            // Display the event name and location
            cell.textLabel?.text = "\(eventName) - \(eventLocation)"
            cell.textLabel?.textColor = .black
            cell.textLabel?.textAlignment = .left
        }
        
        return cell
    }
}


