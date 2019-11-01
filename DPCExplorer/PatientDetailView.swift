//
//  PatientDetailView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct PatientDetailView: View {
    let patient: Patient
    var body: some View {
        VStack {
            PatientBioView(patient: patient)
            .padding()
            Divider()
            Text("More to come")
            Spacer()
        }
    }
}

struct PatientDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PatientDetailView(patient: blythe)
    }
}
