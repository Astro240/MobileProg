import UIKit

// MARK: - BadgeComplete Struct
struct BadgeComplete {
    var title: String
    var currentLevel: Int
}

// Function to calculate badge title and level for completed badges
func calculateCompletedBadgeTitle(for events: Int, baseTitle: String) -> BadgeComplete {
    let level: Int
    switch events {
    case 5...9:
        level = 1
    case 10...14:
        level = 2
    case 11...15:
        level = 3
    default:
        return BadgeComplete(title: "", currentLevel: 0)
    }
    let title = "\(baseTitle) - Level \(level)"
    return BadgeComplete(title: title, currentLevel: level)
}

var badgesComplete: [BadgeComplete] = []

// Function to update badges based on event counts
func updateBadgesComplete() {
    badgesComplete = []

    let sportsBadge = calculateCompletedBadgeTitle(for: currentUser.totalSportsEvents, baseTitle: "Sports Event")
    if !sportsBadge.title.isEmpty {
        badgesComplete.append(sportsBadge)
    }

    let comicsBadge = calculateCompletedBadgeTitle(for: currentUser.totalComicsEvents, baseTitle: "Comics Event")
    if !comicsBadge.title.isEmpty {
        badgesComplete.append(comicsBadge)
    }

    let foodBadge = calculateCompletedBadgeTitle(for: currentUser.totalFoodEvents, baseTitle: "Food Event")
    if !foodBadge.title.isEmpty {
        badgesComplete.append(foodBadge)
    }

    let motorsportsBadge = calculateCompletedBadgeTitle(for: currentUser.totalMotorsportsEvents, baseTitle: "Motorsports Event")
    if !motorsportsBadge.title.isEmpty {
        badgesComplete.append(motorsportsBadge)
    }

    let socialBadge = calculateCompletedBadgeTitle(for: currentUser.totalSocialEvents, baseTitle: "Social Event")
    if !socialBadge.title.isEmpty {
        badgesComplete.append(socialBadge)
    }
}

// Initial update for badges
