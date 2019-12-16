//
//  NameView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 12/15/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import DPCKit

struct NameView: View {
    var name: NameEntity
    var body: some View {
        HStack{
            Text("\(name.family!),").layoutPriority(1)
            Text(name.given!)
        }.lineLimit(1)
    }
}

struct NameView_Previews: PreviewProvider {
    static var previews: some View {
        NameView(name: testName)
    }
}
