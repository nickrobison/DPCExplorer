//
//  InitialsView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 12/15/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import DPCKit

struct InitialsView: View {
    
    let name: NameEntity
    var body: some View {
        Text("\(stringUnwrap(value: name.given))\(stringUnwrap(value: name.family))")
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

func stringUnwrap(value: String?) -> String {
    guard let v = value?.character(at: 0) else {
        return ""
    }
    
    return String(v)
}

struct InitialsView_Previews: PreviewProvider {
    static var previews: some View {
        InitialsView(name: testName)
    }
}
