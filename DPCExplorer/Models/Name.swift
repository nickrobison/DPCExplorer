//
//  Name.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import CoreData

struct Name: Hashable, Codable {
    let family: String
    let given: [String]
    
    func toEntity(ctx: NSManagedObjectContext) -> NameEntity {
        let entity = NameEntity(context: ctx)
        entity.family = self.family
        entity.given = self.given.joined(separator: ", ")
        return entity
    }
}
