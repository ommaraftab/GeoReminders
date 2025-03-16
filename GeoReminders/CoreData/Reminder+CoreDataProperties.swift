//
//  Reminder+CoreDataProperties.swift
//  GeoReminders
//
//  Created by Developer on 16/03/2025.
//
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var radius: Double

}

extension Reminder : Identifiable {

}
