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
        VStack() {
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
                                HStack{
                                    Label("", systemImage: "eye.slash")
                                    Text("Other...")
                                }
                                    }
                                }
                }
    }
    private func getNetworks() {
            self.scanButtonDisabled = true
            Api().getNetworks { (networks) in
                self.networks = []
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
    @State var ssid_ap: String = "Not available"
    @State var password_ap: String = ""
    
    var body: some View {
        
        List {
                Section(header: Text("Traveler Hotspot")){
                HStack{
                    Label("SSID:", systemImage: "wifi")
                    Text(self.ssid_ap)
                }
                HStack{
                    Label("Password:", systemImage: "key")
                    Text(self.password_ap)
                }
                    Button(action: getHotspot) {
                        Label("Update", systemImage: "arrow.clockwise")
                    }
                }
        }
    }
    private func getHotspot() {
            Api().getHotspot { (hotspot) in
                self.ssid_ap = hotspot.ssid
                self.password_ap = hotspot.password
            }
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

