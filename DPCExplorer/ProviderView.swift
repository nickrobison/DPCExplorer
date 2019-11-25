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
import FHIR

struct ProviderView: View {
    @EnvironmentObject var client: DPCClient
    
    @State private var showAdd = false
    
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
            .navigationBarItems(trailing:
                Button(action: {
                    debugPrint("clicked")
                    self.showAdd = true
                }, label: { Image(systemName: "plus")}))
                .onAppear() {
                    debugPrint("Here are the providers")
                    self.client.fetchProviders()
            }
            .sheet(isPresented: $showAdd, content: {
                ProviderAdd(completionHandler: self.submitProvider)
            })
        }
    }
    
    private func submitProvider(provider: FHIR.Practitioner) {
        self.client.addProvider(provider: provider)
    }
}

struct ProviderView_Previews: PreviewProvider {
    static var previews: some View {
        ProviderView()
    }
}
