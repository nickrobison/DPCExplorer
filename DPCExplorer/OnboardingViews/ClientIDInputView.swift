//
//  ClientIDInputView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 12/26/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct ClientIDInputView: View {
    
    @State private var clientID: String = ""
    
    var handler: ((String) -> Void)?
    
    var body: some View {
        VStack {
            Spacer()
            TextField("Paste your client token", text: $clientID)
                .textFieldStyle(PlainTextFieldStyle())
                .padding()
            Spacer()
            FullScreenButton(text: "Next", handler: {
                self.handler?(self.clientID)
            })
        }
    }
}

struct ClientIDInputView_Previews: PreviewProvider {
    static var previews: some View {
        ClientIDInputView()
    }
}