//
//  PatientView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct PatientView: View {
    let patients: [Patient]
    var body: some View {
            List(patients, id: \.mbi) {patient in
                NavigationLink(destination: PatientDetailView(patient: patient)) {
                    PersonCellView(person: patient)
                }
            }
        .navigationBarTitle("Patients")
    }
}

struct PatientView_Previews: PreviewProvider {
    static var previews: some View {
        PatientView(patients: nickPatients)
    }
}
