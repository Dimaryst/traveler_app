//
//  ContentView.swift
//  rpi_traveler_app
//
//  Created by Dmitry K on 30.03.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var networks: [Network] = []
    var body: some View {
        NavigationView {
            List (networks)
            { nw in
                Text(nw.ssid)
            }
            .onAppear {
                Api().getNetworks { (networks) in
                    self.networks = networks
                }
            }
        }
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
