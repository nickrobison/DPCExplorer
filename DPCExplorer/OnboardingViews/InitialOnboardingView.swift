//
//  InitialOnboardingView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 12/26/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct InitialOnboardingView: View {
    
    let handler: () -> Void
    var body: some View {
        return VStack(alignment: .leading) {
            Spacer()
            Group {
                Text("Hello,")
                Text("Let's get started")
            }
            .padding(.leading)
            Spacer()
            FullScreenButton(text: "Next", handler: self.handler)
        }
        .font(.title)
    }
}

struct InitialOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        InitialOnboardingView(handler: {})
    }
}
