//
//  SelectableRow.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 11/28/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct SelectableRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

struct SelectableRow_Previews: PreviewProvider {
    static var previews: some View {
        SelectableRow(title: "Test", isSelected: true, action: {
            debugPrint("Do action")
        })
    }
}
