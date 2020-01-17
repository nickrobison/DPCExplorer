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
import DPCKit

struct ProviderView: View {
    @EnvironmentObject var client: DPCClient
    
    @State private var showAdd = false
    
    @FetchRequest(
        entity: ProviderEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ProviderEntity.family, ascending: true)]
    )
    var providers: FetchedResults<ProviderEntity>
    var body: some View {
        NavigationView {
            List {
                ForEach(providers, id:\.id) { provider in
                    NavigationLink(destination: ProviderDetailView(provider: provider)) {
                        PersonCellView(person: provider)
                    }
                    .isDetailLink(true)
                }
                .onDelete(perform: self.remove)
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
            .navigationViewStyle(StackNavigationViewStyle()) // Temporary hack found via Reddit: https://www.reddit.com/r/SwiftUI/comments/ds5ku3/navigationview_rotation_bug_portrait_to_landscape/
    }
    
    private func submitProvider(provider: FHIR.Practitioner) {
        self.client.addProvider(provider: provider)
    }
    
    private func remove(at offsets: IndexSet) {
        for index in offsets {
            let provider = self.providers[index]
            self.client.delete(provider: provider)
        }
    }
}

struct ProviderView_Previews: PreviewProvider {
    static var previews: some View {
        ProviderView()
    }
}
