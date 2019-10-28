//
//  ContentView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/27/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct Organization {
    var name: String
    var id: String
}

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            VStack(alignment: .leading) {
                HStack {
                    OrganizationView()
                    Spacer()
                }
                Spacer()
            }
                .tabItem {
                    VStack {
                        Image("first")
                        Text("Home")
                    }
                }
                .tag(0)
            PractitionerView()
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Providers")
                    }
                }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            ContentView()
    }
}
