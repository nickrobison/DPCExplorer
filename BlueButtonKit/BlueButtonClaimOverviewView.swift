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
    
    private let dateFormat = "YYYY-MM-dd"
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter
    }
    
    @Binding var isExpanded: Bool
    let eob: ExplanationOfBenefit
    var body: some View {
        Section(header: buildHeader()) {
            if (self.isExpanded) {
                EOBDetailView(eob: eob)
            }
        }
        .padding()
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
        HStack {
            Text("Date: \(self.format(eob.date))")
            Text("Diagnosis: \(eob.primaryDiagnosis!.icd9Code)")
            Spacer()
            Image(systemName: "chevron.right.circle")
                .foregroundColor(.accentColor)
                .rotationEffect(Angle(degrees: self.isExpanded ? 90 : 0))
        }
    }
    
    private func format(_ date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        
        return self.formatter.string(from: date)
    }
}

struct BlueButtonOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["true", "false"], id: \.self) {
            BlueButtonOverviewView(isExpanded: .constant(Bool.init($0)!), eob: testEOB)
        }
    }
}
