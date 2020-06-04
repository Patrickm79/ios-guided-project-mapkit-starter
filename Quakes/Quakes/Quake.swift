//
//  Quake.swift
//  Quakes
//
//  Created by Patrick Millet on 6/4/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import Foundation

struct QuakeResults: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case quakes = "features"
    }
    
    let quakes: [Quake]
}
// To put annotations on the map we need to conform to a protocol that requires NSObject
class Quake: NSObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case magnitude = "mag"
        case properties
        case place
        case time
        case latitude
        case longitude
        case geometry
        case coordinates
    }
    
    let magnitude: Double
    let place: String
    let time: Date
    let latitude: Double
    let longitude: Double
    
    required init(from decoder: Decoder) throws {
        // ORG: Containers, dictonaries, arrays
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let properties = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .properties)
        let geometry = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .geometry)
        var coordinates = try geometry.nestedUnkeyedContainer(forKey: .coordinates)
        
        // Pull values out
        
        magnitude = try properties.decode(Double.self, forKey: .magnitude)
        place = try properties.decode(String.self, forKey: .place)
        time = try properties.decode(Date.self, forKey: .time)
        // Longitude is first in the array
        longitude = try coordinates.decode(Double.self)
        latitude = try coordinates.decode(Double.self)
        
        super.init()
        
    }
    
}
