import UIKit
import FirebaseAuth
import FirebaseDatabaseInternal

class HomeViewController: UIViewController, UICollectionViewDelegate, UISearchBarDelegate {
    
    // MARK: Section Definitions
    enum Section: Hashable {
        case promoted
        case standard(String)
        case categories
    }
    
    enum SupplementaryViewKind {
        static let header = "header"
        static let topLine = "topLine"
        static let bottomLine = "bottomLine"
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item.ID>!
    
    var sections = [Section]()
    var searchController: UISearchController!
    var arr: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = Auth.auth().currentUser?.uid else {
            return
        }
        
        populateInterests(id: id) { interests in
            // This closure will be called when the Firebase query is completed
            if !interests.isEmpty {
                self.arr = interests
            } else {
                print("No interests found for the user.")
            }
        }
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Events"
        Item.Search = []
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.delegate = self // Set delegate
        
        // MARK: Collection View Setup
        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
        collectionView.delegate = self
        setupBottomButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let itemID = dataSource.itemIdentifier(for: indexPath)
        
        switch section {
        case .promoted:
            if let app = Item.promotedApps.first(where: { $0.id == itemID })?.app {
                handleItemTap(app)
            }
        case .standard:
            var apps = Item.essentialApps + Item.popularApps
            for item in Item.categoryEvents {
                apps += item.value
            }
            if let app = apps.first(where: { $0.id == itemID })?.app {
                handleItemTap(app)
            }
        case .categories:
            if let category = Item.categories.first(where: { $0.id == itemID })?.category {
                handleCategoryTap(category)
            }
        }
    }
    
    func handleItemTap(_ app: App) {
        let eventViewController = EventViewController()
        eventViewController.App = app // Pass the App object to the EventViewController

        navigationController?.pushViewController(eventViewController, animated: true)
        print(app.title)
    }

    func handleCategoryTap(_ category: StoreCategory) {
        guard let query = category.name, !query.isEmpty else {
            return
        }
        
        // Navigate to a new view controller
        let searchResultsVC = SearchViewController() // Replace with your destination view controller
        searchResultsVC.searchQuery = query // Pass the search query to the next view controller
        Item.Search = []
        navigationController?.pushViewController(searchResultsVC, animated: true)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let section = self.sections[sectionIndex]
            switch section {
            case .promoted, .standard:
                // Shared layout for promoted and standard sections
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.65))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(44))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryViewKind.header, alignment: .top)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.boundarySupplementaryItems = [headerItem]
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 20, trailing: 8) // Added left/right insets for space
                
                return section

            case .categories:
                // Adjust the item size for a larger image with label below
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(160)) // Adjust the height to fit both the image and label
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
                
                // Create a vertical stack for the item: image on top, label below
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(160)) // Adjust the height accordingly
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                // Add spacing between items in the horizontal direction
                group.interItemSpacing = .fixed(8) // 8 points of spacing between items
                
                let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryViewKind.header, alignment: .top)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [headerItem]
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 20, trailing: 16)
                
                return section
            }
        }
        return layout
    }

    func configureDataSource() {
        // MARK: Data Source Initialization
        let promotedAppCellRegistration = UICollectionView.CellRegistration<PromotedAppCollectionViewCell, Item.ID> { cell, indexPath, itemIdentifier in
            guard let item = Item.promotedApps.first(where: { $0.id == itemIdentifier }) else { return }
            cell.configureCell(item.app!)
        }
        let standardAppCellRegistration = UICollectionView.CellRegistration<StandardAppCollectionViewCell, Item.ID> { cell, indexPath, itemIdentifier in
            var possibleApps = Item.essentialApps + Item.popularApps
            for item in Item.categoryEvents {
                possibleApps += item.value
            }
            guard let item = possibleApps.first(where: { $0.id == itemIdentifier }) else { return }
            cell.configureCell(item.app!)
        }
        let categoryCellRegistration = UICollectionView.CellRegistration<CategoryCollectionViewCell, Item.ID> {  cell, indexPath, itemIdentifier in
            guard let item = Item.categories.first(where: { $0.id == itemIdentifier }) else { return }
            cell.configureCell(item.category!, hideBottomLine: false)
        }
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier -> UICollectionViewCell? in
            let section = self.sections[indexPath.section]
            switch section {
            case .promoted:
                return collectionView.dequeueConfiguredReusableCell(using: promotedAppCellRegistration, for: indexPath, item: itemIdentifier)
            case .standard:
                return collectionView.dequeueConfiguredReusableCell(using: standardAppCellRegistration, for: indexPath, item: itemIdentifier)
            case .categories:
                return collectionView.dequeueConfiguredReusableCell(using: categoryCellRegistration, for: indexPath, item: itemIdentifier)
            }
        })
        
        // MARK: Supplementary View Provider
        let sectionHeaderRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>(elementKind: SupplementaryViewKind.header) { [weak self] headerView, elementKind, indexPath in
            guard let self else { return }
            let section = sections[indexPath.section]
            let sectionName: String
            switch section {
            case .promoted:
                sectionName = "Recommended"
            case .standard(let name):
                sectionName = name
            case .categories:
                sectionName = "Top Categories"
            }
            headerView.setTitle(sectionName)
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView? in
            guard self != nil else { return nil }
            if kind == SupplementaryViewKind.header {
                return collectionView.dequeueConfiguredReusableSupplementary(using: sectionHeaderRegistration, for: indexPath)
            }
            return nil
        }
        
        // MARK: Snapshot Definition
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item.ID>()
        snapshot.appendSections([.categories])
        snapshot.appendItems(Item.categories.map(\.id), toSection: .categories)
        snapshot.appendSections([.promoted])

        populateEvents { categoryEvents in
            // Loop through the category events and append them to the snapshot
            for (category, items) in Item.categoryEvents {
                if !items.isEmpty {
                    let popularSection = Section.standard(category)
                    snapshot.appendSections([popularSection]) // Append the section first
                    snapshot.appendItems(items.map(\.id), toSection: popularSection)
                }
            }

            // After populating, append the promoted apps to the snapshot
            snapshot.appendItems(Item.promotedApps.map(\.id), toSection: .promoted)

            // Update the sections and apply the snapshot
            self.sections = snapshot.sectionIdentifiers
            self.dataSource.apply(snapshot)
        }
        
        self.updateSnapshot() // Update the collection view
    }
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item.ID>()
        
        snapshot.appendSections([.promoted])
        snapshot.appendItems(Item.promotedApps.map(\.id), toSection: .promoted)
        
        snapshot.appendSections([.categories])
        snapshot.appendItems(Item.categories.map(\.id), toSection: .categories)
        
        populateEvents { categoryEvents in
            // Loop through the category events and append them to the snapshot
            for (category, items) in Item.categoryEvents {
                if !items.isEmpty {
                    let popularSection = Section.standard(category)
                    snapshot.appendSections([popularSection]) // Append the section first
                    snapshot.appendItems(items.map(\.id), toSection: popularSection)
                }
            }
        }
        
        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }

    func populateEvents(completion: @escaping ([String: [Item]]) -> Void) {
        let ref = Database.database().reference()
        guard let id = Auth.auth().currentUser?.uid else {
            return
        }
        
        populateInterests(id: id) { interests in
            if !interests.isEmpty {
                self.arr = interests
                print("Interests updated: \(self.arr)")
            } else {
                print("No interests found for the user.")
            }

            // Now that self.arr is populated, you can check its length
            let lenNow = self.arr.count
            print("Number of interests: \(lenNow)")

            ref.child("Events").observeSingleEvent(of: .value, with: { snapshot in
                if let eventsDict = snapshot.value as? [String: Any] {
                    for (eventId, eventData) in eventsDict {
                        if let eventDetails = eventData as? [String: Any],
                           let eventName = eventDetails["Name"] as? String,
                           let eventImageURL = eventDetails["Image"] as? String,
                           let categories = eventDetails["Categories"] as? [String],
                           let desc = eventDetails["Description"] as? String,
                           let location = eventDetails["Location"] as? String,
                           let rating = eventDetails["Rating"] as? Int, let date = eventDetails["Date"] as? String,
                           let eventCat = categories.first {
                            
                            var minAmm = 100.0
                            // Process tickets
                            var tickets: [String: Double] = [:]
                            if let ticketsData = eventDetails["Tickets"] as? [String: [String: Any]] {
                                for (_, ticketInfo) in ticketsData {
                                    if let ticketName = ticketInfo["Name"] as? String,
                                       let ticketPrice = ticketInfo["Price"] as? Double {
                                        tickets[ticketName] = ticketPrice
                                        if (ticketPrice <= minAmm) {
                                            minAmm = ticketPrice
                                        }
                                    }
                                }
                            }

                            // Fetch and process image
                            guard let img: UIImage = GetImage(string: eventImageURL) else {
                                print("Failed to load image for event: \(eventName)")
                                continue
                            }
                            
                            if self.arr.contains(eventCat) {
                                Item.promotedApps.append(.app(App(promotedHeadline: "", title: eventName, subtitle: "", price: tickets, color: img, date: date, desc: desc, eventcategories: categories, location: location, rating: rating, leastPrice: minAmm,eventID: eventId)))
                                
                                if lenNow < 2 && Item.promotedApps.count >= 3 {
                                    if let index = self.arr.firstIndex(of: eventCat) {
                                        self.arr.remove(at: index)
                                    }
                                } else if lenNow >= 2 {
                                    if let index = self.arr.firstIndex(of: eventCat) {
                                        self.arr.remove(at: index)
                                    }
                                }
                            } else {
                                if Item.categoryEvents.keys.contains(eventCat) {
                                    Item.categoryEvents[eventCat]?.append(.app(App(promotedHeadline: "", title: eventName, subtitle: "", price: tickets, color: img, date: date, desc: desc, eventcategories: categories, location: location, rating: rating, leastPrice: minAmm,eventID: eventId)))
                                }
                            }

                            Item.popularApps.append(.app(App(promotedHeadline: "", title: eventName, subtitle: "", price: tickets, color: img, date: date, desc: desc, eventcategories: categories, location: location, rating: rating, leastPrice: minAmm,eventID: eventId)))
                            Item.essentialApps.append(.app(App(promotedHeadline: "", title: eventName, subtitle: "", price: tickets, color: img, date: date, desc: desc, eventcategories: categories, location: location, rating: rating, leastPrice: minAmm,eventID: eventId)))
                        }
                    }
                    completion(Item.categoryEvents)
                } else {
                    print("No data found")
                    completion(Item.categoryEvents)
                }
            }, withCancel: { error in
                print("Error fetching data: \(error.localizedDescription)")
                completion(Item.categoryEvents)
            })
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        
        // Navigate to a new view controller
        let searchResultsVC = SearchViewController() // Replace with your destination view controller
        searchResultsVC.searchQuery = query // Pass the search query to the next view controller
        Item.Search = []
        navigationController?.pushViewController(searchResultsVC, animated: true)
    }
    
    func setupBottomButton() {
        let bottomButton = UIButton(type: .system) // Create a UIButton
        bottomButton.setTitle("Feeling Adventurous?", for: .normal) // Set the button title
        bottomButton.setTitleColor(.white, for: .normal) // Set the title color
        bottomButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18) // Set bold font style

        // Apply rounded corners
        bottomButton.layer.cornerRadius = 25
        bottomButton.clipsToBounds = true

        // Add gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor] // Gradient colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 50)
        gradientLayer.cornerRadius = 25
        bottomButton.layer.insertSublayer(gradientLayer, at: 0)

        // Add shadow
        bottomButton.layer.shadowColor = UIColor.black.cgColor
        bottomButton.layer.shadowOpacity = 0.3
        bottomButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        bottomButton.layer.shadowRadius = 5

        bottomButton.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside) // Add action for tap

        bottomButton.translatesAutoresizingMaskIntoConstraints = false // Use Auto Layout
        view.addSubview(bottomButton)

        // Set constraints
        NSLayoutConstraint.activate([
            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16), // Add padding from the left
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16), // Add padding from the right
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16), // Add padding from the bottom
            bottomButton.heightAnchor.constraint(equalToConstant: 50) // Set button height
        ])
    }

    @objc func bottomButtonTapped() {
        guard !Item.popularApps.isEmpty else {
            print("No apps available in Item.popularApps")
            return
        }

        // Generate a random index
        let randomIndex = Int.random(in: 0..<Item.popularApps.count)
        // Retrieve the item at the random index
        let randomApp = Item.popularApps[randomIndex]

        let eventViewController = EventViewController()
        eventViewController.App = randomApp.app // Pass the App object to the EventViewController

        navigationController?.pushViewController(eventViewController, animated: true)
    }
}
