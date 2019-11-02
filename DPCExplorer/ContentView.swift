//
//  ContentView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/27/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    
    @EnvironmentObject var client: DPCClient
    @State private var loaded = false
 
    var body: some View {
        VStack {
            if (client.organization != nil) {
                MainView(organization: client.organization!)
            } else {
                VStack {
                    Button(action: {self.client.fetchOrganization()}){
                        Text("Load data")
                    }
                    .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            ContentView()
                .environmentObject(DPCClient(baseURL: "http://localhost:3002/v1/api"))
    }
}
