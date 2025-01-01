import Foundation
import FirebaseDatabase
import FirebaseAuth
/// Represents a single event in our app.
struct Event {
    let name: String
    let imageName: String
}

/// Manages storing and fetching dummy data for upcoming & past events.
class EventsDataManager {
    
    // Singleton instance (optional, but useful for shared data).
    static let shared = EventsDataManager()
    private init() {}
    
    /// Returns an array of dummy 'Event' objects for "Upcoming Events."
    func getUpcomingEvents(completion: @escaping ([Item]) -> Void) {
        let ref = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else {
            // Return an empty array if the user is not logged in
            completion([])
            return
        }
        
        var items: [Item] = []
        
        ref.child("Booking").observeSingleEvent(of: .value, with: { snapshot in
            if let eventsDict = snapshot.value as? [String: Any] {
                for (_, eventData) in eventsDict {
                    if let eventDetails = eventData as? [String: Any],
                       let UserID = eventDetails["UserID"] as? String,
                       let eventID = eventDetails["EventID"] as? String {
                        // Check if this event belongs to the current user
                        if userID == UserID {
                            // Check if the event matches any popular app
                            for app in Item.popularApps {
                                if app.app?.eventID == eventID {
                                    items.append(app)
                                }
                            }
                        }
                    }
                }
            }
            // Call the completion handler after the data is fetched
            completion(items)
        })
    }

    
    /// Returns an array of dummy 'Event' objects for "Past Events."
    func getPastEvents(completion: @escaping ([Item]) -> Void) {
        let ref = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else {
            // Return an empty array if the user is not logged in
            completion([])
            return
        }
        
        var items: [Item] = []
        
        ref.child("Booking").observeSingleEvent(of: .value, with: { snapshot in
            if let eventsDict = snapshot.value as? [String: Any] {
                for (_, eventData) in eventsDict {
                    if let eventDetails = eventData as? [String: Any],
                       let UserID = eventDetails["UserID"] as? String,
                       let eventID = eventDetails["EventID"] as? String {
                        // Check if this event belongs to the current user
                        if userID == UserID {
                            // Check if the event matches any popular app
                            for app in Item.popularApps {
                                if app.app?.eventID == eventID {
                                    items.append(app)
                                }
                            }
                        }
                    }
                }
            }
            // Call the completion handler after the data is fetched
            completion(items)
        })
    }
}
