//
//  DeletableList.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 1/10/20.
//  Copyright © 2020 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct DeletableList<Elements, ID, Content: View>: View where Elements: RandomAccessCollection, ID: Hashable  {
    
    var elements: Elements
    let id: KeyPath<Elements.Element, ID>
    let factory: (_ element: Elements.Element) -> Content
    let deleteHandler: (_ offsets: IndexSet) -> Void
    
    var body: some View {
        List {
            ForEach(elements, id: id) { element in
                self.factory(element)
            }
            .onDelete(perform: self.deleteHandler)
        }
    }
}

struct DeletableList_Previews: PreviewProvider {
    
    static var previews: some View {
        DeletableList(
            elements: ["Hello", "World"],
            id: \.self,
            factory: {element in
                Text(element)
        },
            deleteHandler: {_ in
                // Nothing yet
        })
    }
}
