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
    
    @Binding var isExpanded: Bool
    let eob: ExplanationOfBenefit
    var body: some View {
        Section(header: buildHeader()) {
            if (self.isExpanded) {
                HStack {
                    Text("Services")
                        .font(.headline)
                    Spacer()
                }
                .padding([.leading])
                Divider()
                ForEach(eob.item!, id: \.self) { item in
                    ServiceRowItemView(item: item)
                }
            }
        }
        .animation(.easeInOut)
        //        VStack {
        //            if isExpanded {
        //                Text("Claim Details")
        //                    .font(.title)
        //                VStack {
        //                    Text("Diagnosis: \(eob.primaryDiagnosis!.icd9Code)" )
        //                    Text("Date: \(eob.date?.description ?? "None")")
        //                }
        //                .padding([.bottom])
        //                 else {
        //
        //            }
        //        }
    }
    
    private func buildHeader() -> some View {
        Text("Claim on: \(eob.date?.description ?? "None"). Diagnosis: \(eob.primaryDiagnosis!.icd9Code)")
    }
}

struct BlueButtonOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["true", "false"], id: \.self) {
            BlueButtonOverviewView(isExpanded: .constant(Bool.init($0)!), eob: testEOB)
        }
    }
}
