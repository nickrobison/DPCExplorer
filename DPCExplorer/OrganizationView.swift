//
//  OrganizationScreen.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/27/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
struct OrganizationView: View {
    var o: Organization
    var body: some View {
        VStack(alignment: .leading) {
            Text(o.name)
            .font(.title)
            HStack {
                Text("NPI")
                Text("-")
                Text(o.npi)
                Spacer()
            }
            .font(.subheadline)
            Spacer()
        }
    .padding()
    }
}

struct OrganizationView_Previews: PreviewProvider {
    static var previews: some View {
        OrganizationView(o: testOrg)
    }
}