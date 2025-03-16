//
//  LocationAnnotation.swift
//  GeoReminders
//
//  Created by Developer on 15/03/2025.
//

import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    let location: Location
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(location: Location) {
        self.location = location
        self.coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)
        self.title = location.name
        super.init()
    }
}

class ReminderAnnotation: NSObject, MKAnnotation {
    let reminder: Reminder
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(reminder: Reminder) {
        self.reminder = reminder
        self.coordinate = CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude)
        self.title = reminder.name
        super.init()
    }
}
