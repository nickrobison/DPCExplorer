//
//  FormValidationHelpers.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 12/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import Combine


func stringNotEmpty(_ publisher: Published<String>.Publisher) -> AnyPublisher<Bool, Never> {
    publisher
        .debounce(for: 0.8, scheduler: RunLoop.main)
        .removeDuplicates()
        .map { $0 != ""
    }
    .eraseToAnyPublisher()
}
