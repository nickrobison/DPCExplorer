//
//  ViewHelpers.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

func nameFormatter(name: Name) -> some View {
    HStack{
        Text("\(name.family),")
        ForEach(name.given, id: \.self) { g in
            Text(g)
        }
    }
}
