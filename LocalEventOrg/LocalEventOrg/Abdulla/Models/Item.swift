
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
    
    static let essentialApps: [Item] = [
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", price: 0.99,color: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", price: nil,color: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", price: 3.99,color: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", price: 0.99,color: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", price: 4.99,color: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", price: 0.99,color: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title", subtitle: "Game Description", price: 0.99,color: nil)),
    ]
    
    static let categories: [Item] = [
        .category(StoreCategory(name: "AR Games")),
        .category(StoreCategory(name: "Indie")),
        .category(StoreCategory(name: "Strategy")),
        .category(StoreCategory(name: "Racing")),
        .category(StoreCategory(name: "Puzzle")),
        .category(StoreCategory(name: "Board")),
        .category(StoreCategory(name: "Family")),
    ]
}
