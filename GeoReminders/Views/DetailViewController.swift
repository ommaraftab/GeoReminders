//
//  DetailViewController.swift
//  GeoReminders
//
//  Created by Developer on 15/03/2025.
//

import UIKit

class DetailViewController: UIViewController {
    private let location: Location
    private let reminder: Reminder? // Optional for editing existing reminders
    private let viewModel: MapViewModel
    private let radiusSlider = UISlider()
    private let radiusLabel = UILabel()
    private let noteTextField = UITextField()
    private let saveLabel = UILabel()
    private let nameLabel = UILabel()
    
    init(location: Location, reminder: Reminder? = nil, viewModel: MapViewModel) {
        self.location = location
        self.reminder = reminder
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configureInitialValues()
    }
    
    private func setupUI() {
        let labelFont = UIFont.systemFont(ofSize: 17)
        let textAlignment: NSTextAlignment = .left
        
        saveLabel.text = "Save the geofence reminder"
        saveLabel.font = labelFont
        saveLabel.textAlignment = textAlignment
        
        radiusLabel.font = labelFont
        radiusLabel.textAlignment = textAlignment
        
        nameLabel.text = "Name of reminder:"
        nameLabel.font = labelFont
        nameLabel.textAlignment = textAlignment
        
        let stackView = UIStackView(arrangedSubviews: [
            saveLabel,
            radiusLabel,
            radiusSlider,
            nameLabel,
            noteTextField
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
        
        radiusSlider.minimumValue = 100
        radiusSlider.maximumValue = 1000
        radiusSlider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        
        noteTextField.placeholder = "Enter a note"
        noteTextField.borderStyle = .roundedRect
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveReminder))
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.title = location.name
    }
    
    private func configureInitialValues() {
        if let reminder = reminder {
            radiusSlider.value = Float(reminder.radius)
            radiusLabel.text = "Radius: \(Int(reminder.radius))m"
            noteTextField.text = reminder.note
        } else {
            radiusSlider.value = 500
            radiusLabel.text = "Radius: 500m"
        }
    }
    
    @objc private func sliderChanged() {
        let radius = Int(radiusSlider.value)
        radiusLabel.text = "Radius: \(radius)m"
    }
    
    @objc private func saveReminder() {
        let radius = Double(radiusSlider.value)
        let note = noteTextField.text ?? ""
        viewModel.saveReminder(location: location, radius: radius, note: note)
        dismiss(animated: true)
    }
}
