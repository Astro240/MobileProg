import Foundation
import FirebaseDatabase
import FirebaseAuth

class EventsDataManager {
    static let shared = EventsDataManager()
    private init() {}

    func getUpcomingEvents(completion: @escaping ([Item]) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }

        let ref = Database.database().reference()
        var items: [Item] = []
        var uniqueEventIDs = Set<String>()
        let currentDate = Date()

        ref.child("Booking").observeSingleEvent(of: .value) { snapshot in
            guard let eventsDict = snapshot.value as? [String: Any] else {
                completion([])
                return
            }

            for (_, eventData) in eventsDict {
                guard let eventDetails = eventData as? [String: Any],
                      let userEventID = eventDetails["UserID"] as? String,
                      let eventID = eventDetails["EventID"] as? String,
                      userEventID == userID else {
                    continue
                }

                for app in Item.popularApps {
                    guard let dateString = app.app?.date,
                          let eventDate = self.parseDate(from: dateString) else {
                        continue
                    }

                    if eventDate > currentDate,
                       app.app?.eventID == eventID,
                       !uniqueEventIDs.contains(eventID) {
                        items.append(app)
                        uniqueEventIDs.insert(eventID)
                    }
                }
            }
            completion(items)
        }
    }

    func getPastEvents(completion: @escaping ([Item]) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }

        let ref = Database.database().reference()
        var items: [Item] = []
        var uniqueEventIDs = Set<String>()
        let currentDate = Date()

        ref.child("Booking").observeSingleEvent(of: .value) { snapshot in
            guard let eventsDict = snapshot.value as? [String: Any] else {
                completion([])
                return
            }

            for (_, eventData) in eventsDict {
                guard let eventDetails = eventData as? [String: Any],
                      let userEventID = eventDetails["UserID"] as? String,
                      let eventID = eventDetails["EventID"] as? String,
                      userEventID == userID else {
                    continue
                }

                for app in Item.popularApps {
                    guard let dateString = app.app?.date,
                          let eventDate = self.parseDate(from: dateString) else {
                        continue
                    }

                    if eventDate <= currentDate,
                       app.app?.eventID == eventID,
                       !uniqueEventIDs.contains(eventID) {
                        items.append(app)
                        uniqueEventIDs.insert(eventID)
                    }
                }
            }
            completion(items)
        }
    }

    // Helper function to parse date strings
    private func parseDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd/MM/yyyy"

        if dateString.contains(" - ") {
            // Handle date range
            let components = dateString.split(separator: "-").map { $0.trimmingCharacters(in: .whitespaces) }
            guard let firstDate = components.first,
                  let startDate = dateFormatter.date(from: firstDate) else {
                print("Error parsing date range: \(dateString)")
                return nil
            }
            return startDate
        } else {
            // Handle single date
            guard let singleDate = dateFormatter.date(from: dateString) else {
                print("Error parsing single date: \(dateString)")
                return nil
            }
            return singleDate
        }
    }
}
