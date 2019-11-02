//
//  File.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation

struct Provider: Person, Decodable {
    let id: UUID
    let name: [Name]
    let identifier: [Identifier]
    var patients: [Patient]?
    
    init(name: Name, npi: String, specialty: String) {
        self.id = UUID.init()
        self.name = [name]
        self.identifier = [Identifier(system: "NPI", value: npi)]
        self.patients = []
    }
    
    init(name: Name, npi: String, specialty: String, patients: [Patient]) {
        self.id = UUID.init()
        self.name = [name]
        self.identifier = [Identifier(system: "NPI", value: npi)]
        self.patients = patients
    }
}
