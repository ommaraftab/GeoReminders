//
//  DetailViewController.swift
//  GeoReminders
//
//  Created by Developer on 15/03/2025.
//

import UIKit

class DetailViewController: UIViewController {
    private let location: Location
    private let viewModel: MapViewModel
    private let radiusSlider = UISlider()
    private let radiusLabel = UILabel()
    private let noteTextField = UITextField()
    
    init(location: Location, viewModel: MapViewModel) {
        self.location = location
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
    }
    
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [radiusLabel, radiusSlider, noteTextField])
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
        radiusSlider.value = 500
        radiusSlider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        radiusLabel.text = "Radius: 500m"
        
        noteTextField.placeholder = "Enter a note"
        noteTextField.borderStyle = .roundedRect
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveReminder))
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.title = location.name
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
