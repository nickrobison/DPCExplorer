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
            Image(systemName: "person.fill")
                .imageScale(.large)
            VStack(alignment: .leading) {
                HStack {
                    nameFormatter(name: patient.getFirstName)
                        .font(.title)
                }
                Text(patient.getFirstID.value!)
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
