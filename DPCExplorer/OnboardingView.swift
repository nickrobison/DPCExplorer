//
//  OnboardingView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 11/7/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import DPCKit

struct OnboardingView: View {
    let handler: ((_ settings: ApplicationSettings) -> Void)?
    var body: some View {
        Button(action: self.updateSettings){
            Text("Load data")
            .fontWeight(.semibold)
            .font(.title)
            .padding()
            .foregroundColor(Color.white)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.accentColor)
            .cornerRadius(40)
            .padding()
        }
                            
    }
    
    private func updateSettings() {
        debugPrint("Setting settings")
        let settings = ApplicationSettings(url: URL.init(string: "http://localhost:3002/v1/")!, clientToken: "")
        self.handler?(settings)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(handler: nil)
    }
}
