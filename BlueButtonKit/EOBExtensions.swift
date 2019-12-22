//
//  EOBExtensions.swift
//  BlueButtonKit
//
//  Created by Nicholas Robison on 12/22/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import FHIR

extension FHIRURL: Hashable {
    public static func == (lhs: FHIRURL, rhs: FHIRURL) -> Bool {
        lhs.absoluteString == rhs.absoluteString
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.absoluteString)
    }
    
}

extension Coding: Hashable {
    public static func == (lhs: Coding, rhs: Coding) -> Bool {
        lhs.system == rhs.system &&
            lhs.code == rhs.code
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher
            .combine(self.system)
        
        hasher.combine(self.code)
        hasher.combine(self.display)
    }
}

extension CodeableConcept {
    public func containsCode(_ code: Coding) -> Bool {
        return !(coding?.filter { c in
            return c == code
        }.isEmpty ?? false)
    }
}

extension ExplanationOfBenefitDiagnosis {
    
    var icd9Code: String {
        self.diagnosisCodeableConcept!.coding![0].code!.string
    }
}

extension ExplanationOfBenefit {
    
    public func serviceType() -> String {
        "Nothing, yet"
    }
    
    var primaryDiagnosis: ExplanationOfBenefitDiagnosis? {
        let diag = diagnosis?.filter {diag in
            guard let typ = diag.type else {
                return false
            }
            
            let c = Coding()
            c.system = FHIRURL.init("http://hl7.org/fhir/ex-diagnosistype")
            c.code = FHIRString.init("[PRINCIPAL]")
            
            
            let fst = typ.first { code in
                return code.containsCode(c)
            }
            
            return fst != nil
        }
        
        return diag?[0]
    }
    
    var date: Date? {
        return item![0].getDate()
    }
}
