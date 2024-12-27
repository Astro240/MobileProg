//
//  ViewController.swift
//  collectionView
//
//  Created by hussain ali on 15/12/2024.
//

import UIKit

class ViewControllerBadge: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
        currentUser.updateBadges()
    }
}

extension ViewControllerBadge: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCollectionViewCell", for: indexPath) as! BadgeCollectionViewCell
        cell.setup(with: badges[indexPath.row])
        return cell
    }
    
}
