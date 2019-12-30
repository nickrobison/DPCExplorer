//
//  EOBItemExtensions.swift
//  BlueButtonKit
//
//  Created by Nicholas Robison on 12/22/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import FHIR

// MARK: Hashable implementation

extension ExplanationOfBenefitItem: Hashable {
    public static func == (lhs: ExplanationOfBenefitItem, rhs: ExplanationOfBenefitItem) -> Bool {
        return lhs.sequence == rhs.sequence &&
            lhs.category?.text == rhs.category?.text
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher
            .combine(sequence?.int)
        
    }
}

// MARK: FHIR helpers for extracting mandatory values

extension ExplanationOfBenefitItem {
    public func procedureCode() -> CodeableConcept {
        let betos = extensions(forURI: "https://bluebutton.cms.gov/resources/variables/betos_cd")
        
        // We always have one
        return betos![0].valueCodeableConcept!
    }
    
    func getDate() -> Date? {
        if let date = self.servicedDate {
            return date.nsDate
        }
        
        return servicedPeriod?.start?.nsDate
    }
}
