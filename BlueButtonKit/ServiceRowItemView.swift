//
//  ServiceRowItemView.swift
//  BlueButtonKit
//
//  Created by Nicholas Robison on 12/22/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import FHIR

extension ExplanationOfBenefitItem {
    var serviceCode: String {
        self.productOrService?.coding?[0].code?.string ?? "Nada"
    }
}

struct ServiceRowItemView: View {
    
    let item: ExplanationOfBenefitItem
    var body: some View {
        HStack {
            Text("Service \(item.sequence!.int):")
            Text("Code: \(item.serviceCode)")
        }
    }
}

struct ServiceRowItemView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceRowItemView(item: testEOB.item![0])
    }
}
