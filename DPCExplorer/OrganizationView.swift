//
//  OrganizationScreen.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/27/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import Foundation
import DPCKit

struct OrganizationView: View {
    var o: OrganizationEntity
    var body: some View {
        VStack(alignment: .leading) {
            Text(o.name!).lineLimit(1)
            .font(.title)
            HStack {
                Text("NPI")
                Text("-")
                Text(o.getFirstID.value!).lineLimit(1)
                Spacer()
            }
            .font(.subheadline)
            Spacer()
            Divider()
            VStack {
                Text(o.getFirstAddr.line!)
                HStack {
                    Text("\(o.getFirstAddr.city!),")
                    Text(o.getFirstAddr.state!).layoutPriority(1)
                    Text(o.getFirstAddr.postalCode!)
                }
            }
        }
    .padding()
        .background(Image("WalterReed").resizable())
    }
}

struct OrganizationView_Previews: PreviewProvider {
    static var previews: some View {
        OrganizationView(o: tOrgEntity)
    }
}
