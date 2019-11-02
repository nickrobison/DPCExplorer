//
//  Address.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation

struct Address: Decodable {
    var use: String?
    var type: String?
    var line: [String]
    var city: String
    var state: String
    var postalCode: String
}
