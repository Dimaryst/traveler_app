//
//  ContentView.swift
//  rpi_traveler_app
//
//  Created by Dmitry K on 30.03.2022.
//

import SwiftUI
import CoreData

struct NetworksView: View {
    @State var networks: [Network] = []
    @State public var scanButtonDisabled = false
    
    var body: some View {
        VStack(alignment: .leading) {
                        List {
                            Button(action: getNetworks) {
                                Label("Rescan available networks", systemImage: "arrow.clockwise")
                            }
                            .disabled(scanButtonDisabled)
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
                }
    }
    private func getNetworks() {
            networks = []
            self.scanButtonDisabled = true
            Api().getNetworks { (networks) in
                self.networks = networks
                self.scanButtonDisabled = false
            }
            
        }
        private func encryptionTypeToImage(encryptionType: String) -> String {
            var img = "lock.open"
            if encryptionType != "off" {img = "lock"}
            return img
        }
}

struct HotspotView: View {
    var body: some View {
        Text("Empty")
    }
}

struct MainView: View {
    var body: some View {
        TabView {
            HotspotView()
                .tabItem {
                    Label("Hotspot", systemImage: "personalhotspot")
                }

            NetworksView()
                .tabItem {
                    Label("Networks", systemImage: "wifi")
                }
        }
    }
}

