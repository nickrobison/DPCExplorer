//
//  HostSelectionView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 12/26/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct HostSelectionView: View {
    
    private let hosts = ["Local": "http://localhost:3002/v1/",
        "Dev": "https://dev.dpc.cms.gov/api/v1/",
        "Sandbox": "https://sandbox.dpc.cms.gov/api/v1/",
        "Test": "https://test.dpc.cms.gov/api/v1/",
        "Production": "https://dpc.cms.gov/api/v1/"].sorted{$0.key < $1.key}
    
    @State private var selectedHost = 1
    
    var body: some View {
        VStack {
            Spacer()
            Text("Select a host to connect to:")
            Text("Make sure you have permissions to access each environment")
            Picker(selection: $selectedHost, label: Text("")) {
                ForEach(hosts, id: \.0) { (name, env) in
                    Text(name)
                }
            }
            .labelsHidden()
            .pickerStyle(WheelPickerStyle())
        }
    }
}

struct HostSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        HostSelectionView()
    }
}
