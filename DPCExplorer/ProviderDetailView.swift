//
//  PractitionerView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/27/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct ProviderDetailView: View {
    @EnvironmentObject var client: DPCClient
    
    let provider: ProviderEntity
    var body: some View {
        VStack {
            ProviderBioView(provider: provider)
            .padding()
            Divider()
            if (provider.patientRelationship!.count > 0) {
                List(provider.patientRelationship!.allObjects as! [PatientEntity], id: \.self) {
                    patient in
                    NavigationLink(destination: PatientDetailView(patient: patient)) {
                        PersonCellView(person: patient)
                        .font(.body)
                    }
                }
            } else {
                /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
            }
            Spacer()
            }
        .onAppear() {
            self.client.fetchPatientsForProvider(provider: self.provider)
        }
    }
}

//struct ProviderDefailtView_Previews: PreviewProvider {
//
//
//    static var previews: some View {
//        ForEach(testProviders, id: \.name) {
//            provider in
//            ProviderDetailView(provider: provider)
//        }
//
//    }
//}
