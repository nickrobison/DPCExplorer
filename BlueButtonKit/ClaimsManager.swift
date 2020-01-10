//
//  ClaimsManager.swift
//  BlueButtonKit
//
//  Created by Nicholas Robison on 12/24/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import Combine
import FHIR

public class ClaimsManager: ObservableObject {
    
    @Published public var claims: [ExplanationOfBenefit] = []
    @Published public var boxes: [BoxBuilder] = []
    
    private let checks = ["Annual Wellness", "Flu shot", "Mammogram"]
    private let statuses = RecordStatus.allCases
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var boxPublisher: AnyPublisher<Int, Never> {
        Publishers.Sequence(sequence: 0..<RecordStatus.allCases.count)
        .eraseToAnyPublisher()
    }
    
    public init(eob: [ExplanationOfBenefit]) {
        
        self.claims.append(contentsOf: eob)
        let boxCancel = boxPublisher
            .receive(on: RunLoop.main)
            .map { status in
                return DefaultBoxBuilder(name: self.checks[status], status: self.statuses[status])
        }
        .sink {box in
            self.boxes.append(box)
        }
        
        self.cancellableSet.insert(boxCancel)
    }
    
}
