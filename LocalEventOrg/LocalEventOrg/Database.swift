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

func populateEvents() {
    let ref = Database.database().reference()
    ref.child("Events").observeSingleEvent(of: .value, with: { (snapshot) in
        if let eventsDict = snapshot.value as? [String: Any] {
            for (eventID, eventData) in eventsDict {
                if let eventDetails = eventData as? [String: Any],
                   let eventName = eventDetails["Name"] as? String,
                   let eventDate = eventDetails["Date"] as? String,
                   let eventLocation = eventDetails["Location"] as? String,
                   let eventCategories = eventDetails["Categories"] as? [String] {
                    Item.promotedApps.append(.app(App(promotedHeadline: "Recommended For You", title: eventName, subtitle: "", price: 3.99,color:UIImage(named: "ComicCon"))))
                    print("Event ID: \(eventID)")
                    print("Event Name: \(eventName)")
                    print("Date: \(eventDate)")
                    print("Location: \(eventLocation)")
                    print("Categories: \(eventCategories.joined(separator: ", "))")
                    print("\n") // New line for better readability
                }
            }
        } else {
            print("No data found")
        }
    }, withCancel: { error in
        print("Error fetching data: (error.localizedDescription)")
    })
}
