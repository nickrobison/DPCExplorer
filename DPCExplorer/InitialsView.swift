//
//  InitialsView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 12/15/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import DPCKit
import FHIR

struct InitialsView: View {
    
    let name: HumanName
    var body: some View {
        Text("\(name.given![0].string)\(name.family!.string)")
            .font(.title)
            .fontWeight(.heavy)
            .foregroundColor(.white)
            .padding()
            .background(Circle()
                .fill(Color.gray)
                .clipped()
        )
    }
}

struct InitialsView_Previews: PreviewProvider {
    static var previews: some View {
        InitialsView(name: testName)
    }
}
