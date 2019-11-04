//
//  OrganizationScreen.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/27/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import Foundation
struct OrganizationView: View {
    var o: OrganizationEntity
    var body: some View {
        VStack(alignment: .leading) {
            Text(o.name!)
            .font(.title)
            HStack {
                Text("NPI")
                Text("-")
                Text(o.getFirstID.value!)
                Spacer()
            }
            .font(.subheadline)
            Spacer()
            Divider()
            HStack {
                Text(o.getFirstAddr.line!)
                HStack {
                    Text("\(o.getFirstAddr.city!),")
                    Text(o.getFirstAddr.state!)
                    Text(o.getFirstAddr.postalCode!)
                }
            }
        }
    .padding()
    }
}

struct OrganizationView_Previews: PreviewProvider {
    static var previews: some View {
        OrganizationView(o: tOrgEntity)
    }
}
