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
    
    func saveReminder(location: Location, radius: Double, note: String) {
        let reminder = Reminder(context: context)
        reminder.id = UUID()
        reminder.name = location.name
        reminder.latitude = location.lat
        reminder.longitude = location.lon
        reminder.radius = radius
        reminder.note = note
        
        do {
            try context.save()
            reminders.append(reminder)
            startMonitoring(reminder: reminder)
            onRemindersUpdated?()
        } catch {
            print("Failed to save reminder: \(error)")
        }
    }
    
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
    
    func registerGeofences() {
        for reminder in reminders {
            startMonitoring(reminder: reminder)
        }
    }
    
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
