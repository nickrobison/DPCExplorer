//
//  FullScreenButton.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 12/26/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct FullScreenButton: View {
    
    let text: String
    let handler: (() -> Void)
    var body: some View {
        Button(action: self.handler){
            Text(self.text)
                .fontWeight(.semibold)
                .font(.title)
                .padding()
                .foregroundColor(Color.white)
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color.accentColor)
                .cornerRadius(40)
                .padding()
        }
    }
}

struct FullScreenButton_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenButton(text: "Load Data", handler: ({
            // Nothing
        }))
    }
}
