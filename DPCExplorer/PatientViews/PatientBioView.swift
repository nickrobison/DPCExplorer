//
//  PatientBioView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import DPCKit

struct PatientBioView: View {
    let patient: PatientEntity
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    InitialsView(name: patient.getFirstName)
                    NameView(name: patient.getFirstName)
                        .font(.title)
                }
                .padding()
                Text("MBI: \(patient.getFirstID.value!)")
                    .font(.subheadline)
            }
            Spacer()
        }
    }
}

struct PatientBioView_Previews: PreviewProvider {
    static var previews: some View {
        PatientBioView(patient: blythe)
    }
}
