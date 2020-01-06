//
//  SettingsView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 12/26/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var settings: ApplicationSettings
    
    @State private var toggled = false
    
    var body: some View {
        Form {
            Section(header: Text("Connection")) {
                HStack {
                    Text("Host:")
                    Spacer()
                    Text(self.settings.url.absoluteString)
                }
                HStack {
                    Text("Public Key ID:")
                    Spacer()
                    Text(self.settings.keyID)
                }
            }
            Section(header: Text("Query Options")) {
                Toggle(isOn: $toggled) {
                    Text("Since parameter")
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settings: .constant(ApplicationSettings(url: URL.init(string: "http://test.local")!, clientToken: "", keyID: "This is not a key")))
    }
}
