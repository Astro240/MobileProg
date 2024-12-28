import UIKit

// MARK: - Event Data Model
struct EventData {
    static var title: String = ""
    static var longitude: String = ""
    static var latitude: String = ""
    static var startDate: Date = Date()
    static var endDate: Date = Date()
    static var description: String = ""
    static var selectedCategories: [String] = []
    static var eventImage: UIImage? = nil
}

// MARK: - CREATE EVENT VIEW CONTROLLER
class CreateEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: ScrollView & ContentView
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = true
        sv.backgroundColor = .systemBackground
        return sv
    }()

    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()

    // MARK: UI Elements
    private let labelEventTitle: UILabel = {
        let label = UILabel()
        label.text = "Event title:"
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let textFieldEventTitle: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Event Title"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let labelEventCategory: UILabel = {
        let label = UILabel()
        label.text = "Event category:"
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let scrollViewCategories: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let stackViewCategories: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 10
        sv.distribution = .equalSpacing
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let labelLocation: UILabel = {
        let label = UILabel()
        label.text = "Location:"
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let textFieldLongitude: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Longitude"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .decimalPad
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let textFieldLatitude: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Latitude"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .decimalPad
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let buttonUploadImage: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Upload Image", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let imagePreview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 6
        iv.backgroundColor = .systemGray6
        return iv
    }()

    private let labelStartDate: UILabel = {
        let label = UILabel()
        label.text = "Start Date/Time"
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let datePickerStart: UIDatePicker = {
        let dp = UIDatePicker()
        if #available(iOS 13.4, *) {
            dp.preferredDatePickerStyle = .wheels
        }
        dp.datePickerMode = .dateAndTime
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()

    private let labelEndDate: UILabel = {
        let label = UILabel()
        label.text = "End Date/Time"
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let datePickerEnd: UIDatePicker = {
        let dp = UIDatePicker()
        if #available(iOS 13.4, *) {
            dp.preferredDatePickerStyle = .wheels
        }
        dp.datePickerMode = .dateAndTime
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()

    private let labelDescription: UILabel = {
        let label = UILabel()
        label.text = "Description:"
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let textViewDescription: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 16)
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor.systemGray4.cgColor
        tv.layer.cornerRadius = 6
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    // A wide blue rectangular "Next" button
    private let buttonNext: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Next", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // The categories as text only
    private let categories = [
        "Comic", "Music", "Sports", "Social", "Gaming",
        "Festival", "Food", "Pop Culture", "Motorsport"
    ]
    private var categoryButtons: [UIButton] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Create Event"

        setupScrollView()
        setupContentView()
        addSubviews()
        setupConstraints()
        setupCategoryButtons()

        fillFieldsFromStoredData()

        buttonNext.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        buttonUploadImage.addTarget(self, action: #selector(didTapUploadImage), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fillFieldsFromStoredData()
    }

    // MARK: - ScrollView Setup
    private func setupScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupContentView() {
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }

    private func addSubviews() {
        setupContentView()

        contentView.addSubview(labelEventTitle)
        contentView.addSubview(textFieldEventTitle)

        contentView.addSubview(labelEventCategory)
        contentView.addSubview(scrollViewCategories)
        scrollViewCategories.addSubview(stackViewCategories)

        contentView.addSubview(labelLocation)
        contentView.addSubview(textFieldLongitude)
        contentView.addSubview(textFieldLatitude)

        contentView.addSubview(buttonUploadImage)
        contentView.addSubview(imagePreview)

        contentView.addSubview(labelStartDate)
        contentView.addSubview(datePickerStart)
        contentView.addSubview(labelEndDate)
        contentView.addSubview(datePickerEnd)

        contentView.addSubview(labelDescription)
        contentView.addSubview(textViewDescription)

        contentView.addSubview(buttonNext)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelEventTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            labelEventTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            textFieldEventTitle.topAnchor.constraint(equalTo: labelEventTitle.bottomAnchor, constant: 8),
            textFieldEventTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textFieldEventTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textFieldEventTitle.heightAnchor.constraint(equalToConstant: 34),

            labelEventCategory.topAnchor.constraint(equalTo: textFieldEventTitle.bottomAnchor, constant: 20),
            labelEventCategory.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            scrollViewCategories.topAnchor.constraint(equalTo: labelEventCategory.bottomAnchor, constant: 8),
            scrollViewCategories.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            scrollViewCategories.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            scrollViewCategories.heightAnchor.constraint(equalToConstant: 60),

            stackViewCategories.topAnchor.constraint(equalTo: scrollViewCategories.topAnchor),
            stackViewCategories.bottomAnchor.constraint(equalTo: scrollViewCategories.bottomAnchor),
            stackViewCategories.leadingAnchor.constraint(equalTo: scrollViewCategories.leadingAnchor),
            stackViewCategories.trailingAnchor.constraint(equalTo: scrollViewCategories.trailingAnchor),

            labelLocation.topAnchor.constraint(equalTo: scrollViewCategories.bottomAnchor, constant: 20),
            labelLocation.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            textFieldLongitude.topAnchor.constraint(equalTo: labelLocation.bottomAnchor, constant: 8),
            textFieldLongitude.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textFieldLongitude.widthAnchor.constraint(equalToConstant: 150),
            textFieldLongitude.heightAnchor.constraint(equalToConstant: 34),

            textFieldLatitude.centerYAnchor.constraint(equalTo: textFieldLongitude.centerYAnchor),
            textFieldLatitude.leadingAnchor.constraint(equalTo: textFieldLongitude.trailingAnchor, constant: 16),
            textFieldLatitude.widthAnchor.constraint(equalToConstant: 150),
            textFieldLatitude.heightAnchor.constraint(equalToConstant: 34),

            buttonUploadImage.topAnchor.constraint(equalTo: textFieldLongitude.bottomAnchor, constant: 20),
            buttonUploadImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            imagePreview.topAnchor.constraint(equalTo: buttonUploadImage.bottomAnchor, constant: 8),
            imagePreview.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imagePreview.widthAnchor.constraint(equalToConstant: 80),
            imagePreview.heightAnchor.constraint(equalToConstant: 80),

            labelStartDate.topAnchor.constraint(equalTo: imagePreview.bottomAnchor, constant: 20),
            labelStartDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            datePickerStart.topAnchor.constraint(equalTo: labelStartDate.bottomAnchor, constant: 8),
            datePickerStart.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            datePickerStart.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            labelEndDate.topAnchor.constraint(equalTo: datePickerStart.bottomAnchor, constant: 20),
            labelEndDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            datePickerEnd.topAnchor.constraint(equalTo: labelEndDate.bottomAnchor, constant: 8),
            datePickerEnd.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            datePickerEnd.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            labelDescription.topAnchor.constraint(equalTo: datePickerEnd.bottomAnchor, constant: 20),
            labelDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            textViewDescription.topAnchor.constraint(equalTo: labelDescription.bottomAnchor, constant: 8),
            textViewDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textViewDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textViewDescription.heightAnchor.constraint(equalToConstant: 100),

            buttonNext.topAnchor.constraint(equalTo: textViewDescription.bottomAnchor, constant: 30),
            buttonNext.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonNext.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            buttonNext.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            buttonNext.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }

    private func setupCategoryButtons() {
        for cat in categories {
            let button = UIButton(type: .system)
            button.setTitle(cat, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 15)
            button.backgroundColor = .systemGray5
            button.layer.cornerRadius = 8
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            button.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)

            categoryButtons.append(button)
            stackViewCategories.addArrangedSubview(button)
        }
    }

    // Load / Save to static EventData
    private func fillFieldsFromStoredData() {
        textFieldEventTitle.text = EventData.title
        textFieldLongitude.text = EventData.longitude
        textFieldLatitude.text = EventData.latitude
        datePickerStart.date = EventData.startDate
        datePickerEnd.date = EventData.endDate
        textViewDescription.text = EventData.description

        if let chosenImg = EventData.eventImage {
            imagePreview.image = chosenImg
        } else {
            imagePreview.image = nil
        }

        for button in categoryButtons {
            let catName = button.title(for: .normal) ?? ""
            if EventData.selectedCategories.contains(catName) {
                button.isSelected = true
                button.backgroundColor = .systemBlue
                button.setTitleColor(.white, for: .normal)
            } else {
                button.isSelected = false
                button.backgroundColor = .systemGray5
                button.setTitleColor(.systemBlue, for: .normal)
            }
        }
    }

    private func saveFieldsToStoredData() {
        EventData.title = textFieldEventTitle.text ?? ""
        EventData.longitude = textFieldLongitude.text ?? ""
        EventData.latitude = textFieldLatitude.text ?? ""
        EventData.startDate = datePickerStart.date
        EventData.endDate = datePickerEnd.date
        EventData.description = textViewDescription.text ?? ""

        // Gather selected categories
        var selectedCats: [String] = []
        for button in categoryButtons {
            if button.isSelected, let catName = button.title(for: .normal) {
                selectedCats.append(catName)
            }
        }
        EventData.selectedCategories = selectedCats
    }

    // MARK: - Actions
    @objc private func categoryTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.backgroundColor = .systemBlue
            sender.setTitleColor(.white, for: .normal)
        } else {
            sender.backgroundColor = .systemGray5
            sender.setTitleColor(.systemBlue, for: .normal)
        }
    }

    @objc private func didTapUploadImage() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = false
        present(picker, animated: true)
    }

    // UIImagePickerController delegate
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let chosenImage = info[.originalImage] as? UIImage {
            // Save the chosen image
            EventData.eventImage = chosenImage
            imagePreview.image = chosenImage
        }
        dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    @objc private func didTapNext() {
        saveFieldsToStoredData()

        // Check mandatory fields
        guard
            !EventData.title.isEmpty,
            !EventData.longitude.isEmpty,
            !EventData.latitude.isEmpty,
            !EventData.description.isEmpty,
            !EventData.selectedCategories.isEmpty
        else {
            let alert = UIAlertController(
                title: "Error",
                message: "Please fill all fields and select at least one category.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        // Upload Image is now mandatory
        if EventData.eventImage == nil {
            let alert = UIAlertController(
                title: "Error",
                message: "Please upload an image for the event.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        // Check date constraints
        let now = Date()
        if EventData.startDate < now || EventData.endDate < now {
            let alert = UIAlertController(
                title: "Error",
                message: "Event timing invalid.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        let diff = EventData.endDate.timeIntervalSince(EventData.startDate)
        if diff < 3600 {
            let alert = UIAlertController(
                title: "Error",
                message: "Event duration must be an hour or longer.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        // If valid, go to Tickets
        let sb = UIStoryboard(name: "Event", bundle: nil)
        if let ticketsVC = sb.instantiateViewController(withIdentifier: "TicketsViewController") as? TicketsViewController {
            navigationController?.pushViewController(ticketsVC, animated: true)
        }
    }
}
