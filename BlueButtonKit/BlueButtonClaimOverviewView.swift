//
//  BlueButtonOverviewView.swift
//  BlueButtonKit
//
//  Created by Nicholas Robison on 12/18/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import FHIR

extension Patient {
    var formattedName: String {
        "\(self.name![0].family ?? ""), \(self.name![0].given![0])"
    }
}

struct BlueButtonOverviewView: View {
    
    let patient: Patient
    let eob: ExplanationOfBenefit
    var body: some View {
        VStack {
            Text("Claim Details")
                .font(.title)
            VStack {
            Text("Diagnosis: \(eob.primaryDiagnosis!.icd9Code)" )
                Text("Date: \(eob.date?.description ?? "None")")
            }
            .padding([.bottom, .top])
            Text("Services")
            Divider()
            ForEach(eob.item!, id: \.self) { item in
                ServiceRowItemView(item: item)
            }
            Spacer()
        }
    }
}

struct BlueButtonOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        BlueButtonOverviewView(patient: testPatient, eob: testEOB)
    }
}
