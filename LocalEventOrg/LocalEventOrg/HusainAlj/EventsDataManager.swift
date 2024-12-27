import Foundation

/// Represents a single event in our app.
struct Event {
    let name: String
    let imageName: String
}

/// Manages storing and fetching dummy data for upcoming events.
class EventsDataManager {
    
    // Singleton instance (optional, but useful for shared data).
    static let shared = EventsDataManager()
    private init() {}
    
    /// Returns an array of dummy 'Event' objects to display in our app.
    func getUpcomingEvents() -> [Event] {
        return [
            Event(name: "Rock Concert at Sunset Park", imageName: "concert"),
            Event(name: "Community Bake-Off", imageName: "bakeoff"),
            Event(name: "City Charity Marathon", imageName: "marathon"),
            Event(name: "Summer Night Movie Screening", imageName: "movie"),
            Event(name: "Farmers' Market Special", imageName: "farmersmarket")
        ]
    }
}
