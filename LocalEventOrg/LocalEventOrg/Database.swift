//
//  Database.swift
//  LocalEventOrg
//
//  Created by Hasan Abdulrazaq on 21/12/2024.
//

import Foundation
import FirebaseDatabase
import UIKit

func populateDatabase(){
    let ref = Database.database().reference()
    ref.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
        let value = snapshot.value as? NSDictionary
        print(value?["Name"] as? String ?? "no work")
    })
}

func populateInterests(id: String, completion: @escaping ([String]) -> Void) {
    let ref = Database.database().reference()
    var arr: [String] = []
    
    // Query the Users node for a specific user by their id
    ref.child("Users").child(id).observeSingleEvent(of: .value, with: { snapshot in
        // Check if the snapshot exists (this means the user with the given id exists)
        if snapshot.exists() {
            // User exists, proceed with your logic (e.g., populating interests)
            let userData = snapshot.value as? [String: Any]
            if let interest1 = userData?["Interest1"] as? Int, interest1 == 1 {
                arr.append("Comic")
            }
            if let interest2 = userData?["Interest2"] as? Int, interest2 == 1 {
                arr.append("Music")
            }
            if let interest3 = userData?["Interest3"] as? Int, interest3 == 1 {
                arr.append("Social")
            }
            if let interest4 = userData?["Interest4"] as? Int, interest4 == 1 {
                arr.append("Sports")
            }
            if let interest5 = userData?["Interest5"] as? Int, interest5 == 1 {
                arr.append("Gaming")
            }
            if let interest6 = userData?["Interest6"] as? Int, interest6 == 1 {
                arr.append("Festival")
            }
            if let interest7 = userData?["Interest7"] as? Int, interest7 == 1 {
                arr.append("Food")
            }
            if let interest8 = userData?["Interest8"] as? Int, interest8 == 1 {
                arr.append("Pop Culture")
            }
            if let interest9 = userData?["Interest9"] as? Int, interest9 == 1 {
                arr.append("Motor Sport")
            }
        } else {
            // User doesn't exist in the database
            print("User does not exist with id: \(id)")
        }
        // Call the completion handler once the data is fetched
        completion(arr)
        
    }) { error in
        print("Error retrieving user data: \(error.localizedDescription)")
        // In case of an error, return an empty array
        completion([])
    }
}

func populateEventsForCalendar(completion: @escaping ([[String: Any]]) -> Void) {
    let ref = Database.database().reference()
    ref.child("Events").observeSingleEvent(of: .value, with: { (snapshot) in
        var fetchedEvents: [[String: Any]] = []
        
        // Parse the snapshot data
        if let eventsDict = snapshot.value as? [String: Any] {
            for (_, eventData) in eventsDict {
                if let eventDetails = eventData as? [String: Any] {
                    fetchedEvents.append(eventDetails)
                }
            }
        }
        
        // Debugging logs to verify fetched data
        print("Fetched events: \(fetchedEvents)")
        
        // Return the fetched events
        completion(fetchedEvents)
    }, withCancel: { error in
        print("Error fetching data: \(error.localizedDescription)")
        completion([]) // Return an empty array on error
    })
}
