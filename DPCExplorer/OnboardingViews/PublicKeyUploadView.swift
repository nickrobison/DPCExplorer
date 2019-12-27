//
//  PublicKeyUploadView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 12/26/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct PublicKeyUploadView: View {
    
    @State private var publicKey = "This is a public key"
    
    var body: some View {
        VStack(alignment: .leading) {
            Group{
                Text("Use this public key:")
                Text("Copy and paste it into the web UI")
                TextField("Public Key", text: $publicKey)
                    .foregroundColor(.gray)
                    .labelsHidden()
                Button(action: ({
                    debugPrint("Copied")
                })) {
                    Text("Copy key")
                }
                .padding([.top, .bottom])
            }
            .padding(.leading)
        }
    }
}

struct PublicKeyUploadView_Previews: PreviewProvider {
    static var previews: some View {
        PublicKeyUploadView()
    }
}
