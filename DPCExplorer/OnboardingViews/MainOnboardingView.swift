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

struct MainOnboardingView: View {
    static let defaultKeyText = "This is a public key"
    
    let handler: ((_ settings: ApplicationSettings) -> Void)?
    let publicKey: String
    @State var onboardingState: OnBoardingState = .initial
    @State private var stateIdx = 0
    @State private var buttonAnimating = false
    
    @ObservedObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            self.buildViews()
        }
    }
    
    private func buildViews() -> some View {
        VStack(alignment: .leading) {
            Spacer()
            if (self.onboardingState == .initial) {
                InitialOnboardingView()
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0)))
            }
            else if (self.onboardingState == .host) {
                HostSelectionView(hostURL: self.$viewModel.host)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0)))
            } else if (self.onboardingState == .clientID) {
                ClientIDInputView(clientID: self.$viewModel.clientToken)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0)))
            } else if (self.onboardingState == .key) {
                PublicKeyUploadView(publicKey: self.publicKey, keyID: self.$viewModel.keyID)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0)))
            } else {
                OnboardingCompleteView()
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0)))
            }
            Spacer()
            FullScreenButton(text: self.buttonText(), isAnimating: self.$buttonAnimating, handler: self.buttonHandler())
                .disabled(self.buttonDisabled())
        }
    }
    
    private func buttonHandler() -> (() -> Void) {
        switch (self.onboardingState) {
        case.finished:
            return {
                self.buttonAnimating = true; defer { self.buttonAnimating = false}
                self.updateSettings()
            }
        default:
            return self.incrementState
        }
    }
    
    private func incrementState() -> Void {
        self.stateIdx += 1
        self.onboardingState = OnBoardingState.allCases[self.stateIdx]
    }
    
    private func buttonDisabled() -> Bool {
        switch (self.onboardingState) {
        case .host:
            return self.viewModel.host == ""
        case .clientID:
            return self.viewModel.clientToken == ""
        case .key:
            return self.viewModel.keyID == ""
        case .finished:
            return !self.viewModel.isValid
        default:
            return false
        }
    }
    
    private func updateSettings() {
        debugPrint("Setting settings")
        debugPrint("Host: ", self.viewModel.host)
        debugPrint("Token: ", self.viewModel.clientToken)
        let settings = ApplicationSettings(url: URL.init(string: self.viewModel.host)!, clientToken: self.viewModel.clientToken, keyID: self.viewModel.keyID)
        self.handler?(settings)
    }
    
    private func buttonText() -> String {
        switch (self.onboardingState) {
        case .finished:
            debugPrint("Host: ", self.viewModel.host);
            debugPrint("Token: ", self.viewModel.clientToken);
            debugPrint("Key ID: ", self.viewModel.keyID);
            return "Finish"
        default:
            return "Next"
        }
    }
}

struct MainOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(OnBoardingState.allCases, id: \.self) {state in
            MainOnboardingView(handler: nil, publicKey: "", onboardingState: state)
        }
        
    }
}
