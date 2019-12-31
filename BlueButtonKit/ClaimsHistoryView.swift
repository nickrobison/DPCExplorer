//
//  ClaimsHistoryView.swift
//  BlueButtonKit
//
//  Created by Nicholas Robison on 12/30/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import FHIR

public struct ClaimsHistoryView: View {
    
    let eob: [ExplanationOfBenefit]
    @State var claimState: [Int: Bool] = [:]
    
    public init(eob: [ExplanationOfBenefit]) {
        self.eob = eob
    }
    
    public var body: some View {
        VStack {
            HStack {
                Text("Last 10 claims")
                    .font(.headline)
                Spacer()
            }
            Divider()
            ForEach(0..<10) { idx in
                BlueButtonOverviewView(isExpanded: .constant(self.isExpanded(idx)), eob: self.eob[idx])
                    .onTapGesture {
                        self.claimState[idx] = !self.isExpanded(idx)
                }
            }
            Button("More...") {
                debugPrint("More clicked")
            }
        }
    }
    
    private func isExpanded(_ claim: Int) -> Bool {
        return claimState[claim] ?? false
    }
}

struct ClaimsHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ClaimsHistoryView(eob: [testEOB])
    }
}
