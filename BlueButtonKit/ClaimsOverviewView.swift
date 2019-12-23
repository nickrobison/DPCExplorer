//
//  ClaimsOverviewView.swift
//  BlueButtonKit
//
//  Created by Nicholas Robison on 12/22/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import FHIR

struct ClaimsOverviewView: View {

    @State var claimState: [Int: Bool] = [:]

    let eob: [ExplanationOfBenefit]
    @Binding var boxes: [VitalRecordBox]
    
    var body: some View {
        VStack {
            HStack {
                Text("Claims history")
                    .font(.title)
                Spacer()
            }
            ForEach(RecordStatus.allCases, id: \.self){ status in
                VitalRecordBox(status: status)
                    .padding([.trailing, .leading])
            }
            HStack {
                Text("Last 10 claims")
                    .font(.headline)
                Spacer()
            }
            Divider()
            ForEach(0..<eob.count) { idx in
                BlueButtonOverviewView(isExpanded: .constant(self.isExpanded(idx)), eob: self.eob[idx])
                    .onTapGesture {
                        self.claimState[idx] = !self.isExpanded(idx)
                }
            }
        }
    }
    
    private func isExpanded(_ claim: Int) -> Bool {
        return claimState[claim] ?? false
    }
}

struct ClaimsOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        ClaimsOverviewView(eob: [testEOB], boxes: .constant([VitalRecordBox(status: .success)]))
    }
}
