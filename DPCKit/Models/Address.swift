//
//  Address.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import CoreData

public struct Address: Decodable {
    var use: String?
    var type: String?
    var line: [String]
    var city: String
    var state: String
    var postalCode: String
    
    public init(line: [String], city: String, state: String, postalCode: String) {
        self.use = nil
        self.type = nil
        self.line = line
        self.city = city
        self.state = state
        self.postalCode = postalCode
    }
    
    func toEntity(ctx: NSManagedObjectContext) -> AddressEntity {
        let addr = AddressEntity(context: ctx)
        addr.line = self.line.joined(separator: ", ")
        addr.postalCode = self.postalCode
        addr.state = self.state
        addr.city = self.city
        return addr
    }
}
