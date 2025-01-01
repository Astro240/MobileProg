
import UIKit

struct App: Identifiable {
    
    let promotedHeadline: String?
    
    let title: String
    let subtitle: String
    let price: [String:Double]
    let color: UIImage?
    let date: String?
   
    let desc: String?
    let eventcategories: [String]
    let location: String
    let rating : Int?
    let id = UUID()
    let leastPrice : Double?
    let eventID : String?
}

