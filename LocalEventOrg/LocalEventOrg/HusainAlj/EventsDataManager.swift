import Foundation

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
    func getUpcomingEvents() -> [Event] {
        return [
            Event(name: "ComicCon", imageName: "comic"),
            Event(name: "Food Festival", imageName: "food"),
        ]
    }
    
    /// Returns an array of dummy 'Event' objects for "Past Events."
    func getPastEvents() -> [Event] {
        return [
            Event(name: "Jazz Fest", imageName: "jazz"),
            Event(name: "Formula 1", imageName: "f1")
        ]
    }
}
