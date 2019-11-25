//
//  Patient.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import CoreData

extension PatientEntity {
    var getFirstName: NameEntity {
        let names = self.nameRelationship?.allObjects as? [NameEntity]
        return names![0]
    }
    var getFirstID: IdentitiferEntity {
        let ids = self.identifierRelationship?.allObjects as? [IdentitiferEntity]
        return ids![0]
    }
}

extension PatientEntity: Person {
    var name: [NameEntity] {
        let names = self.nameRelationship?.allObjects as? [NameEntity]
        return names ?? []
    }
}

struct Patient: Decodable {
    let id: UUID
    let name: [Name]
    let identifier: [Identifier]
    let birthDate: Date
    let gender: String
    
    @discardableResult
    func toEntity(ctx: NSManagedObjectContext) -> PatientEntity {
        let entity = PatientEntity(context: ctx)
        entity.id = self.id
        entity.birthdate = self.birthDate
        entity.gender = self.gender
        
        // Identifiers
        self.identifier
            .forEach{identifier in                entity.addToIdentifierRelationship(identifier.toEntity(ctx: ctx))
        }
        
        // Names
        self.name.forEach{ name in
            entity.addToNameRelationship(name.toEntity(ctx: ctx))
        }
        return entity
    }
}
