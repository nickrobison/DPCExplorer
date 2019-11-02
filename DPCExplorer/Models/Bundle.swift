//
//  Bundle.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 11/1/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation

struct Resource<T: Decodable>: Decodable {
    let resource: T
}

struct Bundle<T: Decodable>: Decodable {
    let resourceType: String
    let type: String
    let total: Int
    let entry: [Resource<T>]
}
