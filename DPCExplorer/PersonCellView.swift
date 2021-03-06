//
//  PersonBio.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import DPCKit

struct PersonCellView: View {
    let person: Person
    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .imageScale(.large)
            NameView(name: person.name[0])
        }
    }
}

//struct PersonCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        PersonCellView(person: blythe)
//    }
//}

