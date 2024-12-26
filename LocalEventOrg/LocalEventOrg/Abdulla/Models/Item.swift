
import Foundation
import UIKit

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
    
    static let categories: [Item] = [
        .category(StoreCategory(name: "Comic")),
        .category(StoreCategory(name: "Music")),
        .category(StoreCategory(name: "Social")),
        .category(StoreCategory(name: "Sports")),
        .category(StoreCategory(name: "Gaming")),
        .category(StoreCategory(name: "Festival")),
        .category(StoreCategory(name: "Food")),
        .category(StoreCategory(name: "Pop Culture")),
        .category(StoreCategory(name: "Motor Sports")),    ]
}
