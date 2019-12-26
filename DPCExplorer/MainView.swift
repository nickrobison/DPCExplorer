//
//  MainView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 11/1/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import DPCKit

struct MainView: View {
    @EnvironmentObject var client: DPCClient
    @EnvironmentObject var preferences: PreferencesManager
    @State private var selection = 0
    var body: some View {
        TabView(selection: $selection){
            OrganizationView(o: client.organization!)
                .tabItem {
                    VStack {
                        Image("first")
                        Text("Organization")
                    }
            }
            .tag(0)
            ProviderView()
                .tabItem {
                    VStack {
                        Image("first")
                        Text("Providers")
                    }
            }
            .tag(1)
            PatientView()
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Patients")
                    }
            }
            .tag(2)
            SettingsView(settings: .constant(preferences.settings!))
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
            .tag(3)
        }
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView(organization: tOrgEntity)
//    }
//}
