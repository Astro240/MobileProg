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
    ref.child("Events").observeSingleEvent(of: .value, with: { (snapshot) in
        let value = snapshot.value as? NSDictionary
        print(value?["Name"] as? String ?? "no work")
    })
}

import FirebaseDatabase

// Fetches all events from the Firebase Realtime Database
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


