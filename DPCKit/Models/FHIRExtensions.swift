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

public typealias CompletionHandler<T: FHIRAbstractBase> = (_ provider: T) -> Void
public typealias CollectionCompletionHandler<T: FHIRAbstractBase> = (_ collection: [T]) -> Void

public protocol FHIRIdentifier {
    var system: String? { get }
    var value: String? { get }
}

extension PatientIdentifier: FHIRIdentifier {
    @discardableResult
    func toEntity(ctx: NSManagedObjectContext) -> PatientIdentifier {
        let entity = PatientIdentifier(context: ctx)
        entity.system = self.system
        entity.value = self.value
        
        return entity
    }
}

extension ProviderIdentifier: FHIRIdentifier {
    @discardableResult
    func toEntity(ctx: NSManagedObjectContext) -> ProviderIdentifier {
        let entity = ProviderIdentifier(context: ctx)
        entity.system = self.system
        entity.value = self.value
        
        return entity
    }
}

extension OrganizationIdentifier: FHIRIdentifier {
    @discardableResult
    func toEntity(ctx: NSManagedObjectContext) -> OrganizationIdentifier {
        let entity = OrganizationIdentifier(context: ctx)
        entity.system = self.system
        entity.value = self.value
        
        return entity
    }
}

extension FHIR.Patient {
    
    @discardableResult
    func toEntity(ctx: NSManagedObjectContext) -> PatientEntity {
        let entity = PatientEntity(context: ctx)
        entity.birthdate = self.birthDate?.nsDate
        entity.id = UUID.init(uuidString: self.id!.string)
        entity.gender = self.gender?.rawValue
        
        // Many ids
        self.identifier?.forEach{identifier in
            let id = PatientIdentifier(context: ctx)
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
    
    func getFirstId() -> FHIR.Identifier {
        self.identifier![0]
    }
}

extension FHIR.Practitioner {
    
    @discardableResult
    func toEntity(ctx: NSManagedObjectContext) -> ProviderEntity {
        let entity = ProviderEntity(context: ctx)
        entity.id = UUID.init(uuidString: self.id!.string)
        
        // Many ids
        self.identifier?.forEach{identifier in
            let id = ProviderIdentifier(context: ctx)
            id.system = identifier.system?.absoluteString
            id.value = identifier.value?.string
            entity.addToIdRelationship(id)
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
    
    func getFirstId() -> FHIR.Identifier {
        self.identifier![0]
    }
}
