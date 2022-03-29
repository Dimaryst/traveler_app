//
//  rpi_traveler_appApp.swift
//  rpi_traveler_app
//
//  Created by Dmitry K on 30.03.2022.
//

import SwiftUI

@main
struct rpi_traveler_appApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
