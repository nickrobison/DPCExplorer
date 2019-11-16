//
//  OnboardingView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 11/7/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var client: DPCClient
    var body: some View {
        Button(action: {self.client.fetchOrganization()}){
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
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
