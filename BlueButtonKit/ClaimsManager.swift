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
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var boxPublisher: AnyPublisher<RecordStatus, Never> {
        Publishers.Sequence(sequence: RecordStatus.allCases)
        .eraseToAnyPublisher()
    }
    
    public init(eob: [ExplanationOfBenefit]) {
        
        self.claims.append(contentsOf: eob)
        let boxCancel = boxPublisher
            .receive(on: RunLoop.main)
            .map { status in
                return DefaultBoxBuilder(status: status)
        }
        .sink {box in
            self.boxes.append(box)
        }
        
        self.cancellableSet.insert(boxCancel)
    }
    
}
