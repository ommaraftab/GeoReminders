//
//  RemindersViewModel.swift
//  GeoReminders
//
//  Created by Developer on 15/03/2025.
//

import UIKit
import CoreData

class RemindersViewModel {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let locationManager = CLLocationManager()
    
    func deleteReminder(_ reminder: Reminder) {
        if let id = reminder.id?.uuidString {
            locationManager.stopMonitoring(for: CLCircularRegion(center: CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude), radius: reminder.radius, identifier: id))
        }
        context.delete(reminder)
        try? context.save()
    }
}
