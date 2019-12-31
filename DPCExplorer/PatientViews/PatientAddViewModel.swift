//
//  PatientAddViewModel.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 12/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import Combine

class PatientAddViewModel: ObservableObject {
    private static let today = Date()
    // Input
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var mbi = ""
    @Published var birthday = today
    @Published var gender = 0
    
    // Output
    @Published var isValid = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(stringNotEmpty(self.$firstName), stringNotEmpty(self.$lastName), stringNotEmpty(self.$mbi),
                                  isDateValidPublisher)
            .map{
                $0 && $1 && $2 && $3
        }
        .eraseToAnyPublisher()
    }
    
    private var isDateValidPublisher: AnyPublisher<Bool, Never> {
        return self.$birthday
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map {
                $0 != PatientAddViewModel.today
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
