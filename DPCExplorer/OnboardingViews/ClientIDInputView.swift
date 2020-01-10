//
//  ClientIDInputView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 12/26/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct ClientIDInputView: View {
    
    @Binding var clientID: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Paste your client token:")
                .font(.title)
            TextField("client token", text: $clientID)
                .textFieldStyle(PlainTextFieldStyle())
        }
    }
}

struct ClientIDInputView_Previews: PreviewProvider {
    static var previews: some View {
        ClientIDInputView(clientID: .constant(""))
    }
}
