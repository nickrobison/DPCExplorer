//
//  Organization.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation

struct Identifier: Codable {
    var system: String
    var value: String
}

struct Organization: Identifiable, Decodable {
    let id: UUID
    let identifier: [Identifier]
    let name: String
    let address: [Address]
    
    init(id: UUID, name: String, npi:String, address: Address) {
        self.id = id
        self.name = name
        self.identifier = [Identifier(system: "NPI", value: npi)]
        self.address = [address]
    }
}
