//
//  OnboardingCompleteView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 12/26/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct OnboardingCompleteView: View {
    
    var handler: (() -> Void)
    
    var body: some View {
        VStack {
            Spacer()
            Text("Ready to start")
            Spacer()
            FullScreenButton(text: "Finish", handler: self.handler)
        }
    }
}

struct OnboardingCompleteView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCompleteView(handler: {})
    }
}