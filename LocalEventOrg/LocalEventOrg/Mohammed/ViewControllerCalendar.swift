import UIKit

class ViewControllerCalendar: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedDate = Date()
    var totalSquares = [String]()
    var selectedIndexPath: IndexPath? // Track the selected cell

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        setCellsView()
        setMonthView()
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
        
        // Show or hide the selection circle
        if indexPath == selectedIndexPath {
            cell.selectionCircle.isHidden = false // Show the circle for the selected cell
        } else {
            cell.selectionCircle.isHidden = true // Hide the circle for other cells
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Update the selected index
        selectedIndexPath = indexPath
        
        // Reload the collection view to update the appearance
        collectionView.reloadData()
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

    @IBAction func nextMonth(_ sender: Any) {
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        selectedIndexPath = nil // Clear the selected date
        setMonthView()
    }
    
    @IBAction func previousMonth(_ sender: Any) {
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        selectedIndexPath = nil // Clear the selected date
        setMonthView()
    }
}

