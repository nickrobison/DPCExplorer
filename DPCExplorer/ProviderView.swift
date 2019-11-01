//
//  PractitionerView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/27/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct ProviderView: View {
    let provider: Provider
    var body: some View {
        VStack {
            ProviderBioView(provider: provider)
            .padding()
            Spacer()
        }
    }
}

struct ProviderView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        ForEach(testProviders, id: \.name) {
            provider in
            ProviderView(provider: provider)
        }
            
    }
}
