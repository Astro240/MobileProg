//
//  ReviewViewController.swift
//  LocalEventOrg
//
//  Created by BP-36-215-02 on 01/01/2025.
//

import UIKit
import FirebaseDatabase

class ReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // UI Components
    private let addReviewLabel = UILabel()
    private let reviewTextView = UITextView()
    private var starButtons = [UIButton]()
    private let submitButton = UIButton(type: .system)
    private let overallRatingLabel = UILabel()
    private var starRatingViews = [UIImageView]()
    private let tableView = UITableView()
    
    // Data
    private var reviews: [(text: String, rating: Int)] = []
    private var currentRating = 0
    private let db = Database.database().reference()
    var eventID: String! // Event ID for filtering reviews
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Reviews"
        setupUI()
        setupConstraints()
        configureTableView()
        fetchReviews()
    }
    
    private func setupUI() {
        // Add Review Label
        addReviewLabel.text = "Add a Review"
        addReviewLabel.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(addReviewLabel)
        
        // Star Buttons for Rating
        for i in 1...5 {
            let starButton = UIButton(type: .system)
            starButton.setTitle("☆", for: .normal)
            starButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
            starButton.tag = i
            starButton.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            starButtons.append(starButton)
            view.addSubview(starButton)
        }
        
        // Review Text View
        reviewTextView.layer.borderWidth = 1
        reviewTextView.layer.borderColor = UIColor.lightGray.cgColor
        reviewTextView.layer.cornerRadius = 8
        reviewTextView.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(reviewTextView)
        
        // Submit Button
        submitButton.setTitle("Submit", for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        submitButton.backgroundColor = .systemBlue
        submitButton.tintColor = .white
        submitButton.layer.cornerRadius = 8
        submitButton.addTarget(self, action: #selector(submitReview), for: .touchUpInside)
        view.addSubview(submitButton)
        
        // Overall Rating Label
        overallRatingLabel.text = "Overall Rating"
        overallRatingLabel.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(overallRatingLabel)
        
        // Star Rating Views
        for _ in 1...5 {
            let starImageView = UIImageView()
            starImageView.image = UIImage(systemName: "star.fill")
            starImageView.tintColor = .yellow
            starRatingViews.append(starImageView)
            view.addSubview(starImageView)
        }
        
        // TableView for Reviews
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        addReviewLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewTextView.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        overallRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        starButtons.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        starRatingViews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        // Add Review Section
        NSLayoutConstraint.activate([
            addReviewLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            addReviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            starButtons[0].topAnchor.constraint(equalTo: addReviewLabel.bottomAnchor, constant: 10),
            starButtons[0].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            starButtons[1].leadingAnchor.constraint(equalTo: starButtons[0].trailingAnchor, constant: 10),
            starButtons[1].centerYAnchor.constraint(equalTo: starButtons[0].centerYAnchor),
            
            starButtons[2].leadingAnchor.constraint(equalTo: starButtons[1].trailingAnchor, constant: 10),
            starButtons[2].centerYAnchor.constraint(equalTo: starButtons[0].centerYAnchor),
            
            starButtons[3].leadingAnchor.constraint(equalTo: starButtons[2].trailingAnchor, constant: 10),
            starButtons[3].centerYAnchor.constraint(equalTo: starButtons[0].centerYAnchor),
            
            starButtons[4].leadingAnchor.constraint(equalTo: starButtons[3].trailingAnchor, constant: 10),
            starButtons[4].centerYAnchor.constraint(equalTo: starButtons[0].centerYAnchor),
            
            reviewTextView.topAnchor.constraint(equalTo: starButtons[0].bottomAnchor, constant: 10),
            reviewTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            reviewTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            reviewTextView.heightAnchor.constraint(equalToConstant: 100),
            
            submitButton.topAnchor.constraint(equalTo: reviewTextView.bottomAnchor, constant: 10),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 100),
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            
            overallRatingLabel.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            overallRatingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            tableView.topAnchor.constraint(equalTo: overallRatingLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ReviewCell")
    }
    
    @objc private func starTapped(_ sender: UIButton) {
        currentRating = sender.tag
        for (index, button) in starButtons.enumerated() {
            button.setTitle(index < currentRating ? "★" : "☆", for: .normal)
        }
    }
    
    @objc private func submitReview() {
        guard let eventID = eventID, !reviewTextView.text.isEmpty else {
            print("Event ID or review text is missing.")
            return
        }
        
        let newReviewID = UUID().uuidString
        let newReview: [String: Any] = [
            "EventID": eventID,
            "review": reviewTextView.text ?? "",
            "reviewID": newReviewID,
            "starCount": currentRating
        ]
        
        db.child("Reviews").child(newReviewID).setValue(newReview) { [weak self] error, _ in
            if let error = error {
                print("Error adding review: \(error)")
            } else {
                print("Review added successfully")
                self?.fetchReviews()
            }
        }
        
        reviewTextView.text = ""
        currentRating = 0
        for button in starButtons {
            button.setTitle("☆", for: .normal)
        }
    }
    
    private func fetchReviews() {
        guard let eventID = eventID else { return }
        
        db.child("Reviews").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else { return }
            
            self?.reviews = value.values.compactMap { data in
                guard let fetchedEventID = data["EventID"] as? String,
                      fetchedEventID == eventID,
                      let text = data["review"] as? String,
                      let rating = data["starCount"] as? Int else {
                    return nil
                }
                return (text: text, rating: rating)
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath)
        let review = reviews[indexPath.row]
        cell.textLabel?.text = "\(review.text) - \(String(repeating: "★", count: review.rating))"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
