//
//  FHIRExtensions.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 11/23/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import FHIR
import CoreData

extension FHIR.Patient {
    
    @discardableResult
    func toEntity(ctx: NSManagedObjectContext) -> PatientEntity {
        let entity = PatientEntity(context: ctx)
        entity.birthdate = self.birthDate?.nsDate
        entity.id = UUID.init(uuidString: self.id!.string)
        entity.gender = self.gender?.rawValue
        
        // Many ids
        self.identifier?.forEach{identifier in
            let id = IdentitiferEntity(context: ctx)
            id.system = identifier.system?.absoluteString
            id.value = identifier.value?.string
            entity.addToIdentifierRelationship(id)
        }
        
        // Many names
        self.name?.forEach{name in
            let nameEntity = NameEntity(context: ctx)
            nameEntity.family = name.family?.string
            nameEntity.given = name.given?[0].string
            entity.addToNameRelationship(nameEntity)
        }
        
        return entity
    }
}
