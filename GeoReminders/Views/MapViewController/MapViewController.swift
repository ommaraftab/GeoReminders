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
        viewModel.fetchReminders()
    }
    
    private func addBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reminders", style: .plain, target: self, action: #selector(showReminders))
    }

    @objc private func showReminders() {
        navigationController?.pushViewController(RemindersViewController(), animated: true)
    }
    
    private func setupBindings() {
        viewModel.onLocationsUpdated = { [weak self] in
            self?.updateMapAnnotations()
        }
        viewModel.onRemindersUpdated = { [weak self] in
            self?.updateReminderAnnotations()
        }
    }
    
    private func updateMapAnnotations() {
        let annotations: [LocationAnnotation] = viewModel.locations.map { location in
            let annotation = LocationAnnotation(location: location)
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)
            annotation.title = location.name
            return annotation
        }
        mapView.addAnnotations(annotations)
        zoomToFitAnnotations()
    }
    
    private func updateReminderAnnotations() {
        mapView.removeOverlays(mapView.overlays)
        let annotations: [ReminderAnnotation] = viewModel.reminders.map { reminder in
            let annotation = ReminderAnnotation(reminder: reminder)
            annotation.coordinate = CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude)
            annotation.title = reminder.name
            return annotation
        }
        mapView.addAnnotations(annotations)
        
        // Add geofence circles
        for reminder in viewModel.reminders {
                    let circle = MKCircle(
                        center: CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude),
                        radius: reminder.radius
                    )
                    mapView.addOverlay(circle)
                }
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
