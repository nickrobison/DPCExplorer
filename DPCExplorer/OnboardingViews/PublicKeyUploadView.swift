//
//  PublicKeyUploadView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 12/26/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

extension AnyTransition {
    static func moveAndFade(edge: Edge) -> AnyTransition {
        AnyTransition.move(edge: edge).combined(with: .opacity)
    }
}

struct PublicKeyUploadView: View {
    
    let publicKey: String
    @Binding var keyID: String
    @State private var keyCopied = false
//    @State private var buttonText = "Copy key"
    
    var body: some View {
        VStack(alignment: .leading) {
            Group{
                Text("Use this public key:")
                    .font(.title)
                Text("Copy and paste it into the web UI")
                    .font(.subheadline)
                TextField("Public Key", text: .constant(publicKey))
                    .foregroundColor(.gray)
                    .labelsHidden()
                Button(action: ({
                    debugPrint("Copied")
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = self.publicKey
                    withAnimation(.easeInOut(duration: 0.75)) {
                        self.keyCopied = true
                    }
                })) {
                    Text(self.buttonText())
                        .font(.title)
                }
                .padding([.top, .bottom])
            }
            .animation(.spring())
            if (self.keyCopied) {
                Group {
                    Text("Paste the key ID")
                        .font(.title)
                    Text("Paste it from the UI")
                        .font(.caption)
                    TextField("Public Key ID", text: self.$keyID)
                        .labelsHidden()
                }
                .transition(.moveAndFade(edge: .bottom))
            }
        }
    }
    
    private func buttonText() -> String {
        return self.keyCopied ? "Copied" : "Copy Key"
    }
}

struct PublicKeyUploadView_Previews: PreviewProvider {
    static var previews: some View {
        PublicKeyUploadView(publicKey: MainOnboardingView.defaultKeyText, keyID: .constant(""))
    }
}
