//
//  OnboardingViewModel.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 12/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import Combine

class OnboardingViewModel: ObservableObject {
    // Input
    @Published var host = ""
    @Published var clientToken = ""
    @Published var keyID = ""
    
    // Output
    @Published var isValid = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var isOnboardingCompletePublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(stringNotEmpty(self.$host),
                                  stringNotEmpty(self.$clientToken),
                                  stringNotEmpty(self.$keyID))
            .map{
                $0 && $1 && $2
        }
        .eraseToAnyPublisher()
    }
    
    init() {
        isOnboardingCompletePublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }
}
