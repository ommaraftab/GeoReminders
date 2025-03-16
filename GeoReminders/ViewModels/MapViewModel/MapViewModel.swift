//
//  MapViewModel.swift
//  GeoReminders
//
//  Created by Developer on 15/03/2025.
//

import UIKit
import CoreLocation
import UserNotifications
import CoreData

class MapViewModel: NSObject {
    private let networkingService = NetworkingService()
    private let locationManager = CLLocationManager()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var locations: [Location] = []
    var reminders: [Reminder] = []
    var onLocationsUpdated: (() -> Void)?
    var onRemindersUpdated: (() -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        fetchReminders()
        registerGeofences()
    }
    
    func fetchLocations() {
        networkingService.fetchLocations { [weak self] result in
            switch result {
            case .success(let locations):
                self?.locations = locations
                self?.onLocationsUpdated?()
            case .failure(let error):
                print("Failed to fetch locations: \(error)")
                self?.onLocationsUpdated?() // Show persisted reminders if offline
            }
        }
    }
    
    /// Saves or updates a reminder for a given location, ensuring only one reminder per location
    func saveReminder(location: Location, radius: Double, note: String) {
        // Check if a reminder already exists for this location
        let request: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        request.predicate = NSPredicate(format: "latitude == %f AND longitude == %f", location.lat, location.lon)
        
        do {
            let existingReminders = try context.fetch(request)
            let reminder: Reminder
            if let existingReminder = existingReminders.first {
                // Update existing reminder
                reminder = existingReminder
            } else {
                // Create new reminder
                reminder = Reminder(context: context)
                reminder.id = UUID()
                reminder.latitude = location.lat
                reminder.longitude = location.lon
            }
            reminder.name = location.name
            reminder.radius = radius
            reminder.note = note
            
            try context.save()
            fetchReminders() // Refresh reminders list to trigger UI update
            startMonitoring(reminder: reminder)
        } catch {
            print("Failed to save reminder: \(error)")
        }
    }
    
    /// Fetches all reminders from Core Data
    func fetchReminders() {
        let request: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        do {
            reminders = try context.fetch(request)
            print("Fetched \(reminders.count) reminders") // Debug output
            onRemindersUpdated?()
        } catch {
            print("Failed to fetch reminders: \(error)")
        }
    }
    
    /// Registers geofences for all reminders
    func registerGeofences() {
        for reminder in reminders {
            startMonitoring(reminder: reminder)
        }
    }
    
    /// Starts monitoring a geofence for a reminder
    private func startMonitoring(reminder: Reminder) {
        guard locationManager.authorizationStatus == .authorizedAlways else { return }
        guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else { return }
        
        if locationManager.monitoredRegions.count >= 20 {
            print("Geofence limit reached")
            return
        }
        
        let region = CLCircularRegion(
            center: CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude),
            radius: reminder.radius,
            identifier: reminder.id!.uuidString
        )
        region.notifyOnEntry = true
        region.notifyOnExit = true
        locationManager.startMonitoring(for: region)
    }
    
    func requestLocationPermissions() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
}
