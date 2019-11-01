//
//  ProviderView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct ProviderView: View {
    var providers: [Provider]
    var body: some View {
        NavigationView {
        List(providers, id: \.npi) { provider in
            NavigationLink(destination: ProviderDetailView(provider: provider)) {
                PersonCellView(person: provider)
            }
        }
        .navigationBarTitle(Text("Providers"))
    }
    }
}

struct ProviderView_Previews: PreviewProvider {
    static var previews: some View {
        ProviderView(providers: testProviders)
    }
}
