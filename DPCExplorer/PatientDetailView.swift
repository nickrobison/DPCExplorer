//
//  PatientDetailView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct PatientDetailView: View {
    let patient: PatientEntity
    var body: some View {
        VStack {
            PatientBioView(patient: patient)
            .padding()
            Divider()
            List(patient.providerRelationship?.allObjects as! [ProviderEntity], id: \.self) { provider in
                PersonCellView(person: provider)
            }
            Divider()
            if (patient.eob != nil) {
                Text("Fetched EOBs")
            } else {
                EmptyView()
            }
            Spacer()
            
        }
    }
}

struct PatientDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PatientDetailView(patient: blythe)
    }
}
