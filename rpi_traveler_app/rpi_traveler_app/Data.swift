//
//  Data.swift
//  rpi_traveler_app
//
//  Created by Dmitry K on 30.03.2022.
//

import SwiftUI

struct Network: Codable, Identifiable {
    let id = UUID()
    var ssid: String
    var mac: String
    var signal_quality: Int32
    var encryption: String
}

struct Hotspot: Codable {
    var ssid: String
    var password: String
}

