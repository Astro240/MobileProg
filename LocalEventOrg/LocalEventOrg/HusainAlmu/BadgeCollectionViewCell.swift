//
//  BadgeCollectionViewCell.swift
//  collectionView
//
//  Created by hussain ali on 15/12/2024.
//

import UIKit

class BadgeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var badgename: UILabel!
    
    func setup(with badge: Badge){
        badgename.text = badge.title
    }
}
