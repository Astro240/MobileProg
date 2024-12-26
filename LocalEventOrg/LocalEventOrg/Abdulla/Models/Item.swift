
import Foundation
import UIKit

struct allEventCategory {
    let name : String
    let apps : [Item]
}

enum Item: Identifiable {
    case app(App)
    case category(StoreCategory)
    
    var id: String {
        "\(app?.id.uuidString ?? "?")-\(category?.id.uuidString ?? "?")"
    }
    
    var app: App? {
        if case .app(let app) = self {
            return app
        } else {
            return nil
        }
    }
    
    var category: StoreCategory? {
        if case .category(let category) = self {
            return category
        } else {
            return nil
        }
    }
    static var promotedApps: [Item] = [
    ]
    
    static var popularApps: [Item] = [
    ]
    
    static var essentialApps: [Item] = [
    ]
    static var categoryEvents: [String: [Item]] = [
        "Comic": [],
        "Food": [],
        "Gaming": [],
        "Motor Sport": [],
        "Pop Culture": [],
        "Music": [],
        "Festival": [],
        "Sports": [],
        "Social": []
    ]
    static let categories: [Item] = [
        .category(StoreCategory(name: "Comic",color:    UIImage(named: "Comic"))),
        .category(StoreCategory(name: "Music",color:    UIImage(named: "Music"))),
        .category(StoreCategory(name: "Social",color:    UIImage(named: "Social"))),
        .category(StoreCategory(name: "Sports",color:    UIImage(named: "Sports"))),
        .category(StoreCategory(name: "Gaming",color:    UIImage(named: "gaming"))),
        .category(StoreCategory(name: "Festival",color:    UIImage(named: "Festiv"))),
        .category(StoreCategory(name: "Food",color:    UIImage(named: "Food"))),
        .category(StoreCategory(name: "Pop Culture",color:    UIImage(named: "pop"))),
        .category(StoreCategory(name: "Motor Sports",color:    UIImage(named: "Cars"))),    ]
}
