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

class Api {
    func getNetworks(completion: @escaping ([Network]) -> ()) {
        guard let url = URL(string: "http://192.168.26.1:5000/api/available_networks") else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            
            let networks = try! JSONDecoder().decode([Network].self, from: data!)
            DispatchQueue.main.async {
                completion(networks)
            }
        }
        .resume()
    }
}
