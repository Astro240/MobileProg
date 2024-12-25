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

func populateEvents() -> [Item] {
    var items: [Item] = []
    let ref = Database.database().reference()
    ref.child("Events").observeSingleEvent(of: .value, with: { (snapshot) in
        
        if let eventsDict = snapshot.value as? [String: Any] {
            for (eventID, eventData) in eventsDict {
                if let eventDetails = eventData as? [String: Any],
                   let eventName = eventDetails["Name"] as? String,
                   let eventDescription = eventDetails["Description"] as? String,
                   let ticketsDict = eventDetails["Tickets"] as? [String: Any] {

                    print("Event ID: \(eventID)")
                    print("Event Name: \(eventName)")
                    print("Description: \(eventDescription)")
                    let appitem = App(promotedHeadline: "Recommended For You", title: eventName, subtitle: "", price: 3.99,color:UIImage(named: "ComicCon"))
                    items.append(.app(appitem))
                    // Loop through tickets
                    for (ticketID, ticketData) in ticketsDict {
                        if let ticketDetails = ticketData as? [String: Any],
                           let ticketName = ticketDetails["Name"] as? String,
                           let ticketPrice = ticketDetails["Price"] as? Double,
                           let ticketBenefits = ticketDetails["Benefits"] as? String {
                            print("  Ticket ID: \(ticketID)")
                            print("  Ticket Name: \(ticketName)")
                            print("  Price: \(ticketPrice)")
                            print("  Benefits: \(ticketBenefits.isEmpty ? "None" : ticketBenefits)")
                        }
                    }
                    print("\n") // New line for better readability
                }
            }
        } else {
            print("No data found")
        }
    })
    return items
}
