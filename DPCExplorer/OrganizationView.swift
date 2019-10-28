//
//  OrganizationScreen.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/27/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
struct OrganizationView: View {
    var body: some View {
        VStack(alignment: .leading) {
        Text("Organization")
            .font(.title)
            HStack {
                Text("Test Medical Center")
                Text("-")
                Text("1234")
            }
            .font(.subheadline)
        }
    }
}

struct OrganizationView_Previews: PreviewProvider {
    static var previews: some View {
            OrganizationView()
    }
}
