//
//  PractitionerView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/27/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct ProviderDetailView: View {
    let provider: Provider
    var body: some View {
        VStack {
            ProviderBioView(provider: provider)
            .padding()
            Divider()
//            if (provider.patients!.count > 0) {
//                List(provider.patients!, id: \.self) {
//                    patient in
//                    NavigationLink(destination: PatientDetailView(patient: patient)) {
//                        PersonCellView(person: patient)
//                        .font(.body)
//                    }
//                }
//            } else {
//                /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
//            }
            Spacer()
            }
    }
}

struct ProviderDefailtView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        ForEach(testProviders, id: \.name) {
            provider in
            ProviderDetailView(provider: provider)
        }
            
    }
}
