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
    func toEntity(ctx: NSManagedObjectContext) -> PatientEntity {
        let entity = PatientEntity(context: ctx)
        entity.birthdate = self.birthDate?.nsDate
//        entity.id = UUID.init(uuidString: self.id!.string)
        
        // Many ids
        self.identifier?.forEach{identifier in
            let id = IdentitiferEntity(context: ctx)
            id.system = identifier.system?.absoluteString
            id.value = identifier.value?.string
            entity.addToIdentifierRelationship(id)
        }
        
        // Many names
        self.name?.forEach{name in
            let entity = NameEntity(context: ctx)
            entity.family = name.family?.string
            entity.given = name.given?[0].string
        }
        
        return entity
    }
}
