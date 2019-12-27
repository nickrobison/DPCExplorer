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
    
    var body: some View {
        VStack {
            Text("Past your client token here:")
            TextField("client token", text: $clientID)
                .textFieldStyle(PlainTextFieldStyle())
                .padding()
        }
    }
}

struct ClientIDInputView_Previews: PreviewProvider {
    static var previews: some View {
        ClientIDInputView()
    }
}
