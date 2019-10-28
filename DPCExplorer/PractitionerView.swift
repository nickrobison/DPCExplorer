//
//  PractitionerView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/27/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct PractitionerView: View {
    var body: some View {
        VStack {
        HStack {
            Image(systemName: "person.fill")
                .imageScale(.large)
            VStack(alignment: .leading) {
                Text("Robison, Nicholas A")
                    .font(.title)
                Text("Primary care")
                    .font(.subheadline)
            }
            Spacer()
        }
                    Spacer()
    }
    }
}

struct PractitionerView_Previews: PreviewProvider {
    static var previews: some View {
            PractitionerView()
    }
}
