//
//  ClaimsManager.swift
//  BlueButtonKit
//
//  Created by Nicholas Robison on 12/23/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import FHIR
import Combine

struct ClaimsManager {
    
    private let claims: [ExplanationOfBenefit]
    
    public init(with claims: [ExplanationOfBenefit]) {
        self.claims = claims
    }
    
    func getVitalRecords() -> AnyPublisher<VitalRecordBox, Never> {
        return Publishers.Sequence(sequence: RecordStatus.allCases)
        .map({ status in
            return VitalRecordBox(status: status)
        })
        .eraseToAnyPublisher()
    }
}
