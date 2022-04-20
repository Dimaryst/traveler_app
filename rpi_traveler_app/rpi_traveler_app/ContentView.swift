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
    @State var configured_network: Network
    var body: some View {
        VStack() {
                        List {
                            Section(header: Text("Configured Network"), footer: Text("Current configured network on Pi Traveler.")){
                                HStack (alignment: .lastTextBaseline) {
                                    Text("SSID")
                                    Text(configured_network.ssid)
                            }.swipeActions {
                                Button("Remove") {
                                    //
                                }
                                .tint(.red)
                            }
                            }
                            Section(header: Text("Available Networks")){
                                ForEach(networks, id: \.id) {
                                    nw in
                                    HStack{
                                        Label(nw.ssid, systemImage: "\(encryptionTypeToImage(encryptionType: nw.encryption))")
                                    }
                                        }
                                HStack{
                                    Label("Other...", systemImage: "eye.slash")
                                }
                                    }
                                }
                        .listStyle(.grouped)
                        .refreshable {
                            await getConfiguredNetwork()
                            await getNetworks()
                        }
                }
    }
    private func disconnectCurrentNetwork() async {
        do {
            try await URLSession.shared.data(from: URL(string: "http://192.168.26.1:5000/wifi/reset_configuration")!)
        } catch {
            // pass
        }
        
    }
    private func getNetworks() async {
        do {
            let url = URL(string: "http://192.168.26.1:5000/api/available_networks")!
            let (data, _) = try await URLSession.shared.data(from: url)
            networks = try JSONDecoder().decode([Network].self, from: data)
        } catch {
            self.networks = []
        }
        // print(networks)
        }
    
    private func getConfiguredNetwork() async {
        do {
            let url = URL(string: "http://192.168.26.1:5000/api/configured_network")!
            let (data, _) = try await URLSession.shared.data(from: url)
            configured_network = try JSONDecoder().decode(Network.self, from: data)
        } catch {
            // pass
        }
        // print(configured_network.ssid)
        }

    private func encryptionTypeToImage(encryptionType: String) -> String {
            var img = "lock.open"
            if encryptionType != "off" {img = "lock"}
            return img
        }
}

struct HotspotView: View {
    @State private var isSecured: Bool = true
    @State var hotspot: Hotspot
    
    var body: some View {
        
        List {
                Section(header: Text("Hotspot"), footer: Text("Current Pi Traveler WiFi SSID and Password. You must be connected to the network to receive this data.")){
                    HStack (alignment: .lastTextBaseline) {
                    Text("SSID")
                    Text(hotspot.ssid)
                }
                    HStack (alignment: .lastTextBaseline) {
                    Text("Password")
                    Text(hotspot.password)
                }
                }
        }
        .listStyle(.grouped)
        .refreshable {
            await getHotspot()
        }
    }
    private func getHotspot() async {
        do {
            let url = URL(string: "http://192.168.26.1:5000/api/self_hotspot")!
            let (data, _) = try await URLSession.shared.data(from: url)
            hotspot = try JSONDecoder().decode(Hotspot.self, from: data)
        } catch {
            // pass
        }
        }
}

struct MainView: View {
    var body: some View {
        TabView {
            HotspotView(hotspot: Hotspot(ssid: "", password: ""))
                .tabItem {
                    Label("Hotspot", systemImage: "personalhotspot")
                }

            NetworksView(configured_network: Network(ssid: "", mac: "", signal_quality: 0, encryption: "off"))
                .tabItem {
                    Label("Networks", systemImage: "wifi")
                }
        }
    }
}

