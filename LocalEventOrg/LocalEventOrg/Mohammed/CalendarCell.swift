//
//  CalendarCell.swift
//  LocalEventOrg
//
//  Created by oskar alk-wer on 26/12/2024.
//


import UIKit

class CalendarCell: UICollectionViewCell {
    @IBOutlet weak var dayOfMonth: UILabel!
    var selectionCircle: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Create the selection circle
        selectionCircle = UIView()
        selectionCircle.translatesAutoresizingMaskIntoConstraints = false
        selectionCircle.backgroundColor = .lightGray
        selectionCircle.layer.cornerRadius = 20 // Adjust to desired size
        selectionCircle.isHidden = true // Hidden by default
        contentView.addSubview(selectionCircle)
        
        // Set constraints for the circle (centered and square)
        NSLayoutConstraint.activate([
            selectionCircle.widthAnchor.constraint(equalToConstant: 40), // Circle width
            selectionCircle.heightAnchor.constraint(equalToConstant: 40), // Circle height
            selectionCircle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectionCircle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        // Bring the label to the front
        contentView.bringSubviewToFront(dayOfMonth)
    }
}
  

