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
    
    var handler: ((String) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            Group{
                Text("Copy and upload public key")
                    .font(.title)
                TextField("Public Key", text: $publicKey)
                    .foregroundColor(.gray)
                    .labelsHidden()
                Button(action: ({
                    debugPrint("Copied")
                })) {
                    Text("Copy key")
                }
            }
            .padding(.leading)
            FullScreenButton(text: "Next", handler: {
                self.handler?("This is a private key")
            })
        }
    }
}

struct PublicKeyUploadView_Previews: PreviewProvider {
    static var previews: some View {
        PublicKeyUploadView()
    }
}
