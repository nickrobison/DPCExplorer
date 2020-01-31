//
//  InitialOnboardingView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 12/26/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct InitialOnboardingView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("Hello,")
                    .bold()
                    .font(.largeTitle)
                Text("Let's get started")
                    .font(.title)
            }
        }
    }
}

struct InitialOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        InitialOnboardingView()
    }
}
