//
//  NameView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 12/15/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import DPCKit
import FHIR

struct NameView: View {
    var name: HumanName
    var body: some View {
        HStack{
            Text("\(name.family!.string),").layoutPriority(1)
            Text(name.given![0].string)
        }.lineLimit(1)
    }
}

struct NameView_Previews: PreviewProvider {
    static var previews: some View {
        NameView(name: testName)
    }
}
