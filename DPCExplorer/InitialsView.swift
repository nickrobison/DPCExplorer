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
        Text("\(stringUnwrap(name.given![0]))\(stringUnwrap(name.family))")
            .font(.title)
            .fontWeight(.heavy)
            .foregroundColor(.white)
            .padding()
            .background(Circle()
                .fill(Color.gray)
                .clipped()
        )
    }
    
    private func stringUnwrap(_ value: FHIRString?) -> String {
        guard let v = value?.string.character(at: 0) else {
            return ""
        }
        
        return String(v)
    }
}

struct InitialsView_Previews: PreviewProvider {
    static var previews: some View {
        InitialsView(name: testName)
    }
}
