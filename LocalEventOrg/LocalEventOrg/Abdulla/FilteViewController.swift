import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func applyFilters(categories: [String], priceRange: ClosedRange<Float>, rating: Int)
}

class FilterViewController: UIViewController {
    
    weak var delegate: FilterViewControllerDelegate?

    // UI Components
    var categoryPicker: UIPickerView!
    var priceSlider: UISlider!
    var ratingSegmentedControl: UISegmentedControl!

    // Filter options
    let categories = ["All", "Comic", "Music", "Social", "Sports", "Gaming", "Festival", "Food", "Pop Culture", "Motor Sport"]
    var selectedCategories: [String] = []
    var selectedPriceRange: ClosedRange<Float> = 0...100
    var selectedRating: Int = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        title = "Filter Options"
        
        setupUI()
    }

    private func setupUI() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        // Category Picker
        let categoryLabel = createSectionLabel(with: "Select Category")
        stackView.addArrangedSubview(categoryLabel)
        
        categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
        categoryPicker.layer.cornerRadius = 8
        categoryPicker.layer.borderWidth = 1
        categoryPicker.layer.borderColor = UIColor.systemGray4.cgColor
        stackView.addArrangedSubview(categoryPicker)
        
        // Price Slider
        let priceLabel = createSectionLabel(with: "Select Price Range")
        stackView.addArrangedSubview(priceLabel)
        
        let priceValueLabel = UILabel()
        priceValueLabel.text = "Up to: $\(Int(priceSlider?.value ?? 50))"
        priceValueLabel.tag = 1001
        priceValueLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        priceValueLabel.textColor = .secondaryLabel
        stackView.addArrangedSubview(priceValueLabel)
        
        priceSlider = UISlider()
        priceSlider.minimumValue = 0
        priceSlider.maximumValue = 100
        priceSlider.value = 50
        priceSlider.addTarget(self, action: #selector(priceSliderChanged), for: .valueChanged)
        stackView.addArrangedSubview(priceSlider)
        
        // Rating Segmented Control
        let ratingLabel = createSectionLabel(with: "Select Minimum Rating")
        stackView.addArrangedSubview(ratingLabel)
        
        ratingSegmentedControl = UISegmentedControl(items: ["1", "2", "3", "4", "5"])
        ratingSegmentedControl.selectedSegmentIndex = 2
        ratingSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        ratingSegmentedControl.addTarget(self, action: #selector(ratingChanged), for: .valueChanged)
        stackView.addArrangedSubview(ratingSegmentedControl)
        
        // Buttons
        setupButtons(stackView: stackView)
    }
    
    private func setupButtons(stackView: UIStackView) {
        // Apply Button
        let applyButton = UIButton(type: .system)
        applyButton.setTitle("Apply Filters", for: .normal)
        applyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        applyButton.backgroundColor = UIColor.systemBlue
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.layer.cornerRadius = 8
        applyButton.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
        stackView.addArrangedSubview(applyButton)

        // Reset Button
        let resetButton = UIButton(type: .system)
        resetButton.setTitle("Reset Filters", for: .normal)
        resetButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        resetButton.backgroundColor = UIColor.systemGray
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.layer.cornerRadius = 8
        resetButton.addTarget(self, action: #selector(resetFilters), for: .touchUpInside)
        stackView.addArrangedSubview(resetButton)
    }

    private func createSectionLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.label
        return label
    }
    
    @objc func priceSliderChanged() {
        if let priceValueLabel = view.viewWithTag(1001) as? UILabel {
            priceValueLabel.text = "Up to: $\(Int(priceSlider.value))"
        }
        selectedPriceRange = 0...priceSlider.value
    }
    
    @objc func ratingChanged() {
        selectedRating = ratingSegmentedControl.selectedSegmentIndex + 1
    }
    
    @objc func resetFilters() {
        // Reset all filter values to default
        selectedCategories = []
        selectedPriceRange = 0...100
        selectedRating = 3
        
        // Reset UI components
        categoryPicker.selectRow(0, inComponent: 0, animated: true)
        priceSlider.value = 50
        if let priceValueLabel = view.viewWithTag(1001) as? UILabel {
            priceValueLabel.text = "Up to: $50"
        }
        ratingSegmentedControl.selectedSegmentIndex = 2
        
        // Log reset action
        print("Filters reset to default values.")
    }
    
    @objc func applyFilters() {
        let selectedCategory = categories[categoryPicker.selectedRow(inComponent: 0)]
        
        // Log the filters
        print("Selected Filters:")
        print("Category: \(selectedCategory)")
        print("Price Range: \(selectedPriceRange)")
        print("Rating: \(selectedRating)")
        
        // Notify the delegate
        delegate?.applyFilters(
            categories: [selectedCategory],
            priceRange: selectedPriceRange,
            rating: selectedRating
        )
        
        // Dismiss the view controller
        dismiss(animated: true, completion: nil)
    }
}

extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
}
