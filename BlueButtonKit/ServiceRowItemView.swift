//
//  ServiceRowItemView.swift
//  BlueButtonKit
//
//  Created by Nicholas Robison on 12/22/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import FHIR

struct ServiceRowItemView: View {
    
    let item: ExplanationOfBenefitItem
    var body: some View {
        HStack {
            Text("Service \(item.sequence!.int):")
            Text("Service Code: \(item.serviceCode)")
            Image(systemName: "info.circle")
        }
    }
}

struct ServiceRowItemView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceRowItemView(item: testEOB.item![0])
    }
}
