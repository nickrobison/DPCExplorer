//
//  ContentView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/27/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @State private var selection = 0
    @EnvironmentObject var client: DPCClient
 
    var body: some View {
        TabView(selection: $selection){
            OrganizationView(o: testOrg)
                .tabItem {
                    VStack {
                        Image("first")
                        Text("Organization")
                    }
            }
            .tag(0)
            ProviderView(providers: testProviders)
                .tabItem {
                    VStack {
                        Image("first")
                        Text("Providers")
                    }
                }
                .tag(1)
            PatientView(patients: nickPatients)
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Patients")
                    }
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            ContentView()
                .environmentObject(DPCClient(baseURL: "http://localhost:3002/v1/api"))
    }
}
