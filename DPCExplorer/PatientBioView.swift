//
//  PatientBioView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct PatientBioView: View {
    let patient: Patient
    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .imageScale(.large)
            VStack(alignment: .leading) {
                HStack {
                    nameFormatter(name: patient.name[0])
                        .font(.title)
                }
                Text(patient.mbi)
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
