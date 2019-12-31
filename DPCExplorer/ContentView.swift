//
//  ContentView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/27/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import DPCKit

struct ContentView: View {
    
    @EnvironmentObject var preferences: PreferencesManager
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var client: DPCClient?
 
    var body: some View {
        VStack {
            if (client != nil) {
                MainView()
                    .environmentObject(client!)
            } else {
                MainOnboardingView(handler: self.updateSettings, publicKey: self.preferences.publicKey)
            }
        }
        .onAppear() {
            self.buildClient()
        }
    }
    
    private func updateSettings(_ settings: ApplicationSettings) {
        debugPrint("From the completion handler")
        self.preferences.saveSettings(settings)
        self.buildClient()
    }
    
    private func buildClient() {
        debugPrint("Building client")
        guard let settings = self.preferences.settings else {
            return
        }
        let client = DPCClient(baseURL: settings.url.absoluteString, context: managedObjectContext)
        client.fetchOrganization(handler: {
            debugPrint("From org completion handler")
            self.client = client
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView()
        .environmentObject(PreferencesManager())
    }
}
