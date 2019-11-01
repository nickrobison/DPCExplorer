//
//  ProviderBio.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct ProviderBioView: View {
    let provider: Provider
    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .imageScale(.large)
            VStack(alignment: .leading) {
                HStack {
                    Text(provider.name)
                        .font(.title)
                    Text("-")
                    Text(provider.npi)
                        .font(.subheadline)
                }
                Text(provider.specialty)
                    .font(.subheadline)
            }
            Spacer()
        }
    }
}

struct ProviderBioView_Previews: PreviewProvider {
    static var previews: some View {
        ProviderBioView(provider: testProviders[0])
    }
}
