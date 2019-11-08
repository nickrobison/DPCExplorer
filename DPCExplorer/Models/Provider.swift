//
//  File.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import CoreData

extension ProviderEntity {
    var getFirstName: NameEntity {
        let names = self.nameRelationship?.allObjects as? [NameEntity]
        return names![0]
    }
    var getFirstID: IdentitiferEntity {
        let ids = self.idRelationship?.allObjects as? [IdentitiferEntity]
        return ids![0]
    }
}

extension ProviderEntity: Person {
    var name: [NameEntity] {
        let names = self.nameRelationship?.allObjects as? [NameEntity]
        return names ?? []
    }
}

struct Provider: Decodable {
    let id: UUID
    let name: [Name]
    let identifier: [Identifier]
    var patients: [Patient]?
    
    init(name: Name, npi: String, specialty: String) {
        self.id = UUID.init()
        self.name = [name]
        self.identifier = [Identifier(system: "NPI", value: npi)]
        self.patients = []
    }
    
    init(name: Name, npi: String, specialty: String, patients: [Patient]) {
        self.id = UUID.init()
        self.name = [name]
        self.identifier = [Identifier(system: "NPI", value: npi)]
        self.patients = patients
    }
    
    @discardableResult
    func toEntity(ctx: NSManagedObjectContext) -> ProviderEntity {
        let entity = ProviderEntity(context: ctx)
        entity.id = self.id
        
        self.identifier.forEach{ identifier in
            entity.addToIdRelationship(identifier.toEntity(ctx: ctx))
        }
        
        self.name.forEach{ name in
            entity.addToNameRelationship(name.toEntity(ctx: ctx))
        }
        return entity;
    }
}
