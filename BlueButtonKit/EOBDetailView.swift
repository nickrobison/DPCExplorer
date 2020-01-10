//
//  EOBDetailView.swift
//  BlueButtonKit
//
//  Created by Nicholas Robison on 12/30/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import FHIR

struct EOBDetailView: View {
    
    let eob: ExplanationOfBenefit
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack {
                    Text("Provider:")
                    Text(eob.primaryPhysician?.identifier?.value?.string ?? "A. Smith")
                        .underline()
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding([.leading])
                }
                Spacer()
                VStack {
                    Text("Location:")
                        .padding([.trailing])
                    Text("Methodist")
                        .underline()
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            Text("Services")
                .font(.headline)
                .padding([.top])
            Divider()
            ForEach(eob.item!, id: \.self) { item in
                ServiceRowItemView(item: item)
            }
        }
    }
}

struct EOBDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EOBDetailView(eob: testEOB)
    }
}
