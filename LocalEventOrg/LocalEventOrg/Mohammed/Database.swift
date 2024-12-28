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


func populateEventCell(cell: UITableViewCell, with event: [String: Any]) {
    // Event Image
    if let eventImageView = cell.viewWithTag(1) as? UIImageView,
       let imageUrlString = event["Image"] as? String,
       let imageUrl = URL(string: imageUrlString) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageUrl), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    eventImageView.image = image
                }
            }
        }
    }

    // Event Name
    if let eventNameLabel = cell.viewWithTag(2) as? UILabel {
        eventNameLabel.text = event["Name"] as? String
    }

    // Event Date
    if let eventDateLabel = cell.viewWithTag(3) as? UILabel {
        eventDateLabel.text = event["Date"] as? String
    }

    // Event Description
    if let eventDescriptionLabel = cell.viewWithTag(4) as? UILabel {
        eventDescriptionLabel.text = event["Description"] as? String
    }

    // Categories
    if let categoryStackView = cell.viewWithTag(5) as? UIStackView {
        categoryStackView.arrangedSubviews.forEach { $0.removeFromSuperview() } // Clear existing views

        if let categories = event["Categories"] as? [String], !categories.isEmpty {
            for category in categories {
                let label = UILabel()
                label.text = category
                label.textColor = .black // Text color
                label.font = UIFont.systemFont(ofSize: 10) // Small font size
                label.layer.cornerRadius = 5
                label.layer.masksToBounds = true
                label.textAlignment = .center

                // Add padding inside the label
                label.translatesAutoresizingMaskIntoConstraints = false
                label.heightAnchor.constraint(equalToConstant: 20).isActive = true
                label.widthAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true

                categoryStackView.addArrangedSubview(label)
            }
        } else {
            let noCategoryLabel = UILabel()
            noCategoryLabel.text = "No Categories"
            noCategoryLabel.textColor = .darkGray
            noCategoryLabel.font = UIFont.systemFont(ofSize: 10)
            noCategoryLabel.textAlignment = .center
            categoryStackView.addArrangedSubview(noCategoryLabel)
        }
        
        

    }
    
    
    
    
    
}


