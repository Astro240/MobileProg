
import UIKit

struct App: Identifiable {
    
    let promotedHeadline: String?
    
    let title: String
    let subtitle: String
    let price: Double?
    let color: UIImage?

    var formattedPrice: String {
        if let price = price {
            guard let localCurrencyCode = Locale.autoupdatingCurrent.currency?.identifier else {
                return String(price)
            }
            return price.formatted(.currency(code: localCurrencyCode))
        } else {
            return "GET"
        }
    }
    let desc: String?
    let eventcategories: [String]
    let location: String
    let id = UUID()
}

