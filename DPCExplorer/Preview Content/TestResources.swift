//
//  TestProviders.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation

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

let testUUID = UUID()

let orgAddress = Address(line: ["1 Parkview Way"], city: "Fort Wayne", state: "Indiana", postalCode: "46815")

let testOrg = Organization(id: testUUID, name: "Parkview Hospital", npi:"11883322", address: orgAddress)

let blythe = Patient(name: [Name(family: "Robison", given: ["Blythe", "Kristin"])], mbi: "112233", birthdate: Date(dateString: "2018-01-11")!)

let nickPatients = [
    blythe
]

let testProviders = [
    Provider(name: Name(family: "Robison", given: ["Nicholas", "A"]), npi: "12345", specialty: "Primary care", patients: nickPatients),
    Provider(name: Name(family: "Robison", given: ["Callie", "J"]), npi: "67890", specialty: "Oral surgery", patients: [])
]
