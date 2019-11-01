//
//  File.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation

struct Provider: Person {
    let name: Name
    let npi: String
    let specialty: String
    let patients: [Patient]
}
