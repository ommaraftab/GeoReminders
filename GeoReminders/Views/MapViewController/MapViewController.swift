//
//  MapViewController.swift
//  GeoReminders
//
//  Created by Developer on 15/03/2025.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    let viewModel = MapViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        addBackButton()
        setupBindings()
        viewModel.fetchLocations()
        requestPermissions()
        addPermissionObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchReminders() // Refresh reminders when view appears
        updateMapAnnotations()     // Ensure map reflects latest state
    }
    
    private func addBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reminders", style: .plain, target: self, action: #selector(showReminders))
    }

    @objc private func showReminders() {
        navigationController?.pushViewController(RemindersViewController(), animated: true)
    }
    
    /// Sets up bindings to update the map when locations or reminders change
    private func setupBindings() {
        viewModel.onLocationsUpdated = { [weak self] in
            self?.updateMapAnnotations()
        }
        viewModel.onRemindersUpdated = { [weak self] in
            self?.updateMapAnnotations() // Update all annotations when reminders change
        }
    }
    
    /// Updates map annotations to reflect current locations and reminders
    private func updateMapAnnotations() {
        // Clear existing annotations and overlays
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        // Create a set of coordinates with reminders
        let reminderCoordinates = Set(viewModel.reminders.map { "\($0.latitude),\($0.longitude)" })
        
        // Add blue pins for locations without reminders
        let locationAnnotations: [LocationAnnotation] = viewModel.locations.compactMap { location in
            let coordKey = "\(location.lat),\(location.lon)"
            guard !reminderCoordinates.contains(coordKey) else { return nil }
            let annotation = LocationAnnotation(location: location)
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)
            annotation.title = location.name
            return annotation
        }
        mapView.addAnnotations(locationAnnotations)
        
        // Add red pins and geofence circles for reminders
        let reminderAnnotations: [ReminderAnnotation] = viewModel.reminders.map { reminder in
            let annotation = ReminderAnnotation(reminder: reminder)
            annotation.coordinate = CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude)
            annotation.title = reminder.name
            return annotation
        }
        mapView.addAnnotations(reminderAnnotations)
        
        for reminder in viewModel.reminders {
            let circle = MKCircle(
                center: CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude),
                radius: reminder.radius
            )
            mapView.addOverlay(circle)
        }
        
        zoomToFitAnnotations()
    }
    
    private func zoomToFitAnnotations() {
        let annotations = mapView.annotations
        guard !annotations.isEmpty else { return }
        var zoomRect = MKMapRect.null
        for annotation in annotations {
            let point = MKMapPoint(annotation.coordinate)
            let rect = MKMapRect(x: point.x - 1000, y: point.y - 1000, width: 2000, height: 2000)
            zoomRect = zoomRect.union(rect)
        }
        mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
    }
    
    private func requestPermissions() {
        viewModel.requestLocationPermissions()
        viewModel.requestNotificationPermissions()
    }
    
    private func addPermissionObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(showPermissionAlert), name: NSNotification.Name("ShowPermissionAlert"), object: nil)
    }
    
    @objc func showPermissionAlert() {
        let alert = UIAlertController(title: "Permission Required", message: "Please enable location and notification permissions in Settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
