//
//  ProviderView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct ProviderView: View {
    @EnvironmentObject var client: DPCClient
    var body: some View {
        NavigationView {
            Text("Providers here")
//            List(client.providers) { provider in
//            NavigationLink(destination: ProviderDetailView(provider: provider)) {
////                PersonCellView(person: provider)
//            }
//        }
        .navigationBarTitle(Text("Providers"))
    }
        .onAppear() {
            debugPrint("Here I am!")
            self.client.fetchProviders()
        }
    }
}

struct ProviderView_Previews: PreviewProvider {
    static var previews: some View {
        ProviderView()
    }
}
