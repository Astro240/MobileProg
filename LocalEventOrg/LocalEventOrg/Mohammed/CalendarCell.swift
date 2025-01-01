//
//  CalendarCell.swift
//  LocalEventOrg
//
//  Created by oskar alk-wer on 26/12/2024.
//


import UIKit
class CalendarCell: UICollectionViewCell {
    @IBOutlet weak var dayOfMonth: UILabel!
    // Label to display the day of the month within the calendar cell.
    
    var selectionCircle: UIView!
    // A circle view used to indicate a selected day.

    override func awakeFromNib() {
        super.awakeFromNib()
        // Called when the cell is loaded from the nib file. Used for one-time setup.
        
        // Create the selection circle
        selectionCircle = UIView()
        selectionCircle.translatesAutoresizingMaskIntoConstraints = false
        selectionCircle.backgroundColor = .lightGray
        selectionCircle.layer.cornerRadius = 20 // Adjust to desired size
        selectionCircle.isHidden = true // Hidden by default
        contentView.addSubview(selectionCircle)
        // A circular view is created and added to the content view, hidden initially.

        // Set constraints for the circle (centered and square)
        NSLayoutConstraint.activate([
            selectionCircle.widthAnchor.constraint(equalToConstant: 40), // Circle width
            selectionCircle.heightAnchor.constraint(equalToConstant: 40), // Circle height
            selectionCircle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectionCircle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        // Constraints ensure the circle is 40x40 in size, centered within the cell.
        
        // Bring the label to the front
        contentView.bringSubviewToFront(dayOfMonth)
        // Ensures the day label is visible above the selection circle.
    }
}

  

