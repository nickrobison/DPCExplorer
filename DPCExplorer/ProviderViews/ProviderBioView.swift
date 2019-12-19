//
//  ProviderBio.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import DPCKit

struct ProviderBioView: View {
    let provider: ProviderEntity
    var body: some View {
        HStack {
            InitialsView(name: provider.getFirstName)
            VStack(alignment: .leading) {
                HStack {
                    NameView(name: provider.getFirstName)
                        .font(.title)
                }
                Text(provider.getFirstID.value!)
                .font(.subheadline)
            }
            Spacer()
        }
    }
}

//struct ProviderBioView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProviderBioView(provider: testProviders[0])
//    }
//}
