import UIKit

struct Badge {
    var title: String
    var progress: Float
    var currentLevel: Int
}

func calculateBadgeTitle(for events: Int, baseTitle: String) -> Badge {
    let level: Int
    let progress: Float
    switch events {
    case 0...4:
        level = 1
        progress = Float(events) / 5.0
    case 5...9:
        level = 2
        progress = Float(events - 5) / 5.0
    case 10...14:
        level = 3
        progress = Float(events - 10) / 5.0
    case 15...29:
        level = 4
        progress = Float(events - 15) / 15.0
    default:
        return Badge(title: "", progress: 0.0, currentLevel: 0)
    }
    let title = "\(baseTitle) - Level \(level)"
    return Badge(title: title, progress: progress, currentLevel: level)
}

struct User {
    var totalSportsEvents: Int {
        didSet {
            updateBadges()
        }
    }
    var totalComicsEvents: Int {
        didSet {
            updateBadges()
        }
    }
    var totalFoodEvents: Int {
        didSet {
            updateBadges()
        }
    }
    var totalMotorsportsEvents: Int {
        didSet {
            updateBadges()
        }
    }
    var totalSocialEvents: Int {
        didSet {
            updateBadges()
        }
    }

    mutating func updateBadges() {
        badges = []
        let sportsBadge = calculateBadgeTitle(for: totalSportsEvents, baseTitle: "Sports Event")
        if !sportsBadge.title.isEmpty {
            badges.append(sportsBadge)
        }

        let comicsBadge = calculateBadgeTitle(for: totalComicsEvents, baseTitle: "Comics Event")
        if !comicsBadge.title.isEmpty {
            badges.append(comicsBadge)
        }

        let foodBadge = calculateBadgeTitle(for: totalFoodEvents, baseTitle: "Food Event")
        if !foodBadge.title.isEmpty {
            badges.append(foodBadge)
        }

        let motorsportsBadge = calculateBadgeTitle(for: totalMotorsportsEvents, baseTitle: "Motorsports Event")
        if !motorsportsBadge.title.isEmpty {
            badges.append(motorsportsBadge)
        }

        let socialBadge = calculateBadgeTitle(for: totalSocialEvents, baseTitle: "Social Event")
        if !socialBadge.title.isEmpty {
            badges.append(socialBadge)
        }
    }
}

var badges: [Badge] = []


