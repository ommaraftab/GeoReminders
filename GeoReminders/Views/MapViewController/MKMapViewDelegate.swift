//
//  MKMapViewDelegate.swift
//  GeoReminders
//
//  Created by Developer on 15/03/2025.
//

import UIKit
import MapKit

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let identifier = "Pin"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view?.canShowCallout = true
            view?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            view?.annotation = annotation
        }
        
        if annotation is LocationAnnotation {
            view?.pinTintColor = .blue
        } else if annotation is ReminderAnnotation {
            view?.pinTintColor = .red
        }
        return view
    }
    
    /// Handles tap on detail disclosure button for both blue and red pins
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let locationAnnotation = view.annotation as? LocationAnnotation {
            let detailVC = DetailViewController(location: locationAnnotation.location, viewModel: viewModel)
            let navController = UINavigationController(rootViewController: detailVC)
            present(navController, animated: true)
        } else if let reminderAnnotation = view.annotation as? ReminderAnnotation {
            // Create a temporary Location object for the reminder
            let location = Location(
                id: "", // ID not needed here
                name: reminderAnnotation.reminder.name ?? "",
                lat: reminderAnnotation.reminder.latitude,
                lon: reminderAnnotation.reminder.longitude,
                category: ""
            )
            let detailVC = DetailViewController(location: location, reminder: reminderAnnotation.reminder, viewModel: viewModel)
            let navController = UINavigationController(rootViewController: detailVC)
            present(navController, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circle = overlay as? MKCircle {
            let renderer = MKCircleRenderer(circle: circle)
            renderer.fillColor = UIColor.red.withAlphaComponent(0.2)
            renderer.strokeColor = .red
            renderer.lineWidth = 1
            return renderer
        }
        return MKOverlayRenderer()
    }
}
