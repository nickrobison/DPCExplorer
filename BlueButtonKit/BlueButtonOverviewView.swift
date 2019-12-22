//
//  BlueButtonOverviewView.swift
//  BlueButtonKit
//
//  Created by Nicholas Robison on 12/18/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import FHIR

struct BlueButtonOverviewView: View {
    
    let eob: ExplanationOfBenefit
    var body: some View {
        Text(eob.id?.string ?? "Nothing")
    }
}

struct BlueButtonOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        BlueButtonOverviewView(eob: testEOB)
    }
}
