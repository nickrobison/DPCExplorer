//
//  Organization.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation

struct Organization: Identifiable {
    let id: UUID
    let name: String
    let npi: String
    let address: Address
}
