//
//  Test Resources.swift
//  BlueButtonKit
//
//  Created by Nicholas Robison on 12/18/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import FHIR

let testEOB: ExplanationOfBenefit = load("test_eob.json")

let testString  = "This is a test"

let testPatient: Patient = {
    let patient = Patient()
    
    let name = HumanName()
    name.family = "Patient"
    name.given = [FHIRString("Test")]
    
    patient.name = [name]
    return patient
}()
