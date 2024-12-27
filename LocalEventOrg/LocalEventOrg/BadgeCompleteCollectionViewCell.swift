//
//  BadgeCollectionViewCell.swift
//  collectionView
//
//  Created by hussain ali on 15/12/2024.
//

import UIKit

class BadgeCompleteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var badgeProg: UIProgressView!
    @IBOutlet weak var badgename: UILabel!
    
    func setup(with badge: Badge) {
        badgename.text = badge.title
        badgeProg.progress = badge.progress
    }

}
