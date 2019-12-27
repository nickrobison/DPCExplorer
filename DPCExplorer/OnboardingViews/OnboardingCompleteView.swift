//
//  OnboardingCompleteView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 12/26/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct OnboardingCompleteView: View {
    
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle")
                .resizable()
                .scaledToFit()
                .foregroundColor(.green)
                .padding(100)
            Text("Setup complete!")
                .font(.title)
        }
    }
}

struct OnboardingCompleteView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCompleteView()
    }
}
