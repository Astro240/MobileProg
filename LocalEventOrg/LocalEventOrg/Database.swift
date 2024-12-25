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

