//
//  ProviderView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import Foundation
import CoreData

struct ProviderView: View {
    @EnvironmentObject var client: DPCClient
    
    @FetchRequest(
        entity: ProviderEntity.entity(),
        sortDescriptors: []
    )
    var providers: FetchedResults<ProviderEntity>
    var body: some View {
        NavigationView {
            List(providers, id:\.id) { provider in
                NavigationLink(destination: ProviderDetailView(provider: provider)) {
                        PersonCellView(person: provider)
                }
            }
            .navigationBarTitle("Providers")
            .onAppear() {
                debugPrint("Here are the providers")
                self.client.fetchProviders()
            }
    }
    }
}

struct ProviderView_Previews: PreviewProvider {
    static var previews: some View {
        ProviderView()
    }
}
