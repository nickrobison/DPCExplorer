//
//  ProviderAddView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 12/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import Combine

class ProviderAddViewModel: ObservableObject {
    // Input
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var npi = ""
    
    // Output
    @Published var isValid = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(stringNotEmpty(self.$firstName), stringNotEmpty(self.$lastName), stringNotEmpty(self.$npi))
            .map{
                $0 && $1 && $2
        }
        .eraseToAnyPublisher()
    }
    
    init() {
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }
}
