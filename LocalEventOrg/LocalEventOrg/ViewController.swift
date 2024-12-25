//
//  ViewController.swift
//  LocalEventOrg
//
//  Created by BP-36-201-06 on 25/11/2024.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Banner Image
        let bannerImageView = UIImageView()
        bannerImageView.image = UIImage(named: "comiccon")
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.clipsToBounds = true
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = "Bahrain Comic Con"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Date Label
        let dateLabel = UILabel()
        dateLabel.text = "25th April 2024"
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        dateLabel.textColor = .darkGray
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Tag Stack
        let tags = ["Comic", "Gaming", "Social", "Festival"]
        let tagStackView = UIStackView()
        tagStackView.axis = .horizontal
        tagStackView.distribution = .equalSpacing
        tagStackView.alignment = .center
        tagStackView.spacing = 10
        tagStackView.translatesAutoresizingMaskIntoConstraints = false
        tags.forEach { tag in
            let label = UILabel()
            label.text = tag
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = .white
            label.backgroundColor = .systemBlue
            label.textAlignment = .center
            label.layer.cornerRadius = 12
            label.layer.masksToBounds = true
            label.widthAnchor.constraint(equalToConstant: 80).isActive = true
            label.heightAnchor.constraint(equalToConstant: 24).isActive = true
            tagStackView.addArrangedSubview(label)
        }
        
        // Description Label
        let descriptionLabel = UILabel()
        descriptionLabel.text = """
        Comic Con Bahrain is a vibrant celebration of comics, anime, gaming, and pop culture, featuring special guests, panels, cosplay contests, gaming zones, and exclusive merchandise.
        
        It’s the ultimate fan experience for enthusiasts of all ages.
        """
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Venue Section
        let venueLabel = UILabel()
        venueLabel.text = "Venue Location"
        venueLabel.font = UIFont.boldSystemFont(ofSize: 18)
        venueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let locationLabel = UILabel()
        locationLabel.text = "📍 Bahrain International Circuit, Zallaq"
        locationLabel.font = UIFont.systemFont(ofSize: 16)
        locationLabel.textColor = .darkGray
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let directionsButton = UIButton(type: .system)
        directionsButton.setTitle("Get Directions", for: .normal)
        directionsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        directionsButton.backgroundColor = .systemBlue
        directionsButton.setTitleColor(.white, for: .normal)
        directionsButton.layer.cornerRadius = 10
        directionsButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Reviews Section
        let reviewsLabel = UILabel()
        reviewsLabel.text = "Overall Rating"
        reviewsLabel.font = UIFont.boldSystemFont(ofSize: 18)
        reviewsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let starsLabel = UILabel()
        starsLabel.text = "★★★★★"
        starsLabel.font = UIFont.systemFont(ofSize: 24)
        starsLabel.textColor = .systemYellow
        starsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let reviewsButton = UIButton(type: .system)
        reviewsButton.setTitle("Reviews →", for: .normal)
        reviewsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        reviewsButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Pricing Button
        let pricingButton = UIButton(type: .system)
        pricingButton.setTitle("From 10.000 BD | Book Now", for: .normal)
        pricingButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        pricingButton.backgroundColor = .systemBlue
        pricingButton.setTitleColor(.white, for: .normal)
        pricingButton.layer.cornerRadius = 10
        pricingButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add Subviews
        view.addSubview(bannerImageView)
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(tagStackView)
        view.addSubview(descriptionLabel)
        view.addSubview(venueLabel)
        view.addSubview(locationLabel)
        view.addSubview(directionsButton)
        view.addSubview(reviewsLabel)
        view.addSubview(starsLabel)
        view.addSubview(reviewsButton)
        view.addSubview(pricingButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bannerImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            
            titleLabel.topAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tagStackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            tagStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: tagStackView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            venueLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            venueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            locationLabel.topAnchor.constraint(equalTo: venueLabel.bottomAnchor, constant: 10),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            directionsButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
            directionsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            directionsButton.widthAnchor.constraint(equalToConstant: 150),
            directionsButton.heightAnchor.constraint(equalToConstant: 40),
            
            reviewsLabel.topAnchor.constraint(equalTo: directionsButton.bottomAnchor, constant: 30),
            reviewsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            starsLabel.centerYAnchor.constraint(equalTo: reviewsLabel.centerYAnchor),
            starsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            reviewsButton.topAnchor.constraint(equalTo: reviewsLabel.bottomAnchor, constant: 10),
            reviewsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            pricingButton.topAnchor.constraint(equalTo: reviewsButton.bottomAnchor, constant: 30),
            pricingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pricingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pricingButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

