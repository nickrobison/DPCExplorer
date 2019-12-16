//
//  TestProviders.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import DPCKit

extension Date {
    init?(dateString: String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        if let d = dateStringFormatter.date(from: dateString) {
            self.init(timeInterval: 0, since: d)
        } else {
            return nil
        }
    }
}

func createPatient(last: String, first: String) -> PatientEntity {
    let patient = PatientEntity()
    patient.id = UUID()
    patient.birthdate = Date(dateString: "2018-01-11")
    let id = PatientIdentifier()
    id.system = "MBI"
    id.value = "112233"
    patient.addToIdentifierRelationship(id)
    
    let name = NameEntity()
    name.family = last
    name.given = first
    patient.addToNameRelationship(name)
    
    return patient
}

func createTestOrg() -> OrganizationEntity {
    let addr = AddressEntity()
    addr.line = "1 Parkview Way"
    addr.city = "Fort Wayne"
    addr.state = "Indiana"
    addr.postalCode = "46815"
    
    let idr = OrganizationIdentifier()
    idr.system = "NPI"
    idr.value = "11883322"
    
    let org = OrganizationEntity()
    org.id = UUID()
    org.name = "Parkview Hospital"
//    org.addToIdRelationship(values: [addr])
    return org
}

let testUUID = UUID()

let orgAddress = Address(line: ["1 Parkview Way"], city: "Fort Wayne", state: "Indiana", postalCode: "46815")

let tOrgEntity = createTestOrg()

let testOrg = Organization(id: testUUID, name: "Parkview Hospital", npi:"11883322", address: orgAddress)

let blythe = createPatient(last: "Robison", first: "Blythe, Kristin")

let nickPatients = [
    blythe
]

let testName = { () -> NameEntity in
    let n = NameEntity()
    n.given = "Nick"
    n.family = "Robison"
    
    return n
}()

//let testProviders = [
//    Provider(name: Name(family: "Robison", given: ["Nicholas", "A"]), npi: "12345", specialty: "Primary care", patients: []),
//    Provider(name: Name(family: "Robison", given: ["Callie", "J"]), npi: "67890", specialty: "Oral surgery", patients: [])
//]
