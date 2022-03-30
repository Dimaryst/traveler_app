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
            VStack(alignment: .leading) {
                List {
                    Section(header: Text("Available Networks")){
                        ForEach(networks, id: \.id) {
                            nw in
                            HStack{
                                Label("", systemImage: "\(encryptionTypeToImage(encryptionType: nw.encryption))")
                                Text(nw.ssid)
                            }
                                }
                            }
                        }
            // .listStyle(GroupedListStyle())
            .navigationTitle("Pi Traveler")
            .toolbar {
                ToolbarItem {
                    Button(action: getNetworks) {
                        Label("Scan", systemImage: "arrow.clockwise")
                    }
                }
            }
        }
        }
    }
    
    private func getNetworks() {
        networks = []
        Api().getNetworks { (networks) in
            self.networks = networks
        }
    }
    private func encryptionTypeToImage(encryptionType: String) -> String {
        var img = "lock.open"
        if encryptionType != "off" {img = "lock"}
        return img
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
