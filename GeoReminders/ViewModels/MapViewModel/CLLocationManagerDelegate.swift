//
//  CLLocationManagerDelegate.swift
//  GeoReminders
//
//  Created by Developer on 15/03/2025.
//

import CoreLocation
import UserNotifications
import CoreData

extension MapViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        triggerNotification(title: "Entered Area", body: "You are near \(reminders.first(where: { $0.id?.uuidString == region.identifier })?.name ?? "a location").")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        triggerNotification(title: "Exited Area", body: "You have left \(reminders.first(where: { $0.id?.uuidString == region.identifier })?.name ?? "a location").")
    }
    
    private func triggerNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error)")
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted {
            // Show alert
            NotificationCenter.default.post(name: NSNotification.Name("ShowPermissionAlert"), object: nil)
        } else if manager.authorizationStatus == .authorizedAlways {
            registerGeofences()
        }
    }
}
