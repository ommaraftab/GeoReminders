//
//  Location.swift
//  GeoReminders
//
//  Created by Developer on 15/03/2025.
//

import Foundation

struct Location: Codable {
    let id: String
    let name: String
    let lat: Double
    let lon: Double
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, lat, lon, category
    }
}
