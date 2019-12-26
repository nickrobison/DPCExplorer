//
//  OnboardingView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 11/7/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import DPCKit

enum OnBoardingState {
    case initial
    case host
    case clientID
    case key
    case finished
}

struct OnboardingView: View {
    
    let handler: ((_ settings: ApplicationSettings) -> Void)?
    @State private var onboardingState: OnBoardingState = .initial
    
    @State private var host: URL? = nil
    @State private var clientToken = ""
    @State private var privateKey = ""
    
    var body: some View {
        VStack {
            Spacer()
            self.buildViews()
        }
    }
    
    private func updateSettings() {
        debugPrint("Setting settings")
        let settings = ApplicationSettings(url: self.host!, clientToken: self.clientToken)
        self.handler?(settings)
    }
    
    private func buildViews() -> AnyView {
        switch (self.onboardingState) {
        case .initial:
            return AnyView(InitialOnboardingView(handler: {
                self.onboardingState = .host
            }))
        case .host:
            return AnyView(HostSelectionView(handler: {
                debugPrint("Host: ", $0)
                self.host = $0
                self.onboardingState = .clientID
            }))
        case .clientID:
            return AnyView(ClientIDInputView(handler: {
                self.clientToken = $0
                self.onboardingState = .key
            }))
        case .key:
            return AnyView(PublicKeyUploadView(handler: {
                self.privateKey = $0
                self.onboardingState = .finished
            }))
        case .finished:
            return AnyView(OnboardingCompleteView(handler: {
                self.updateSettings()
            }))
        }
    }
    
    private func finalView() -> some View {
        return VStack(alignment: .leading) {
            Text("Ready to rock")
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(handler: nil)
    }
}
