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

let testOrg = Organization(name: "Parkview Hospital", npi:"11883322")

let blythe = Patient(name: Name(family: "Robison", given: ["Blythe", "Kristen"]), mbi: "112233", birthdate: Date(dateString: "2018-01-11")!)

let nickPatients = [
    blythe
]

let testProviders = [
    Provider(name: Name(family: "Robison", given: ["Nicholas", "A"]), npi: "12345", specialty: "Primary care", patients: nickPatients),
    Provider(name: Name(family: "Robison", given: ["Callie", "J"]), npi: "67890", specialty: "Oral surgery", patients: [])
]
