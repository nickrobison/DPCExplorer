//
//  OnboardingViewModel.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 12/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    @Published var url: URL?
    @Published var clientToken = ""
    @Published var keyID = ""
    
    @Published var isValid = false
}
