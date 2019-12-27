//
//  OnboardingView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 11/7/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import DPCKit

enum OnBoardingState: CaseIterable {
    case initial
    case host
    case clientID
    case key
    case finished
}

struct OnboardingView: View {
    
    static let defaultKeyText = "This is a public key"
    
    let handler: ((_ settings: ApplicationSettings) -> Void)?
    @State var onboardingState: OnBoardingState = .initial
    @State private var stateIdx = 0
    @State private var host: URL? = nil
    @State private var clientToken = ""
    @State private var privateKey = OnboardingView.defaultKeyText
    
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
    
    private func buildViews() -> some View {
        VStack(alignment: .leading) {
            Spacer()
            if (self.onboardingState == .initial) {
                InitialOnboardingView()
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0)))
            }
            else if (self.onboardingState == .host) {
                HostSelectionView()
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0)))
            } else if (self.onboardingState == .clientID) {
                ClientIDInputView()
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0)))
            } else if (self.onboardingState == .key) {
                PublicKeyUploadView(publicKey: $privateKey)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0)))
            } else {
                OnboardingCompleteView()
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0)))
            }
            Spacer()
            FullScreenButton(text: self.buttonText(), handler: self.incrementState)
        }
    }
    
    private func incrementState() -> Void {
        self.stateIdx += 1
        self.onboardingState = OnBoardingState.allCases[self.stateIdx]
    }
    
    private func buttonText() -> String {
        switch (self.onboardingState) {
        case .finished:
            return "Finish"
        default:
            return "Next"
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(OnBoardingState.allCases, id: \.self) {state in
            OnboardingView(handler: nil, onboardingState: state)
        }
        
    }
}
