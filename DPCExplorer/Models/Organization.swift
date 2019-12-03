//
//  Organization.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import CoreData

 extension OrganizationEntity {
    var getFirstAddr: AddressEntity {
        let addrs = (self.addressRelationship?.allObjects as? [AddressEntity])
        return addrs![0]
    }
    var getFirstID: FHIRIdentifier {
        let ids = self.idRelationship?.allObjects as? [OrganizationIdentifier]
        return ids![0]
    }
}

struct Identifier: Codable {
    let system: String
    let value: String

    func toEntity(ctx: NSManagedObjectContext) -> OrganizationIdentifier {
        let entity = OrganizationIdentifier(context: ctx)
        entity.system = self.system
        entity.value = self.value
        return entity
    }
}

struct Organization: Identifiable, Decodable {
    let id: UUID
    let identifier: [Identifier]
    let name: String
    let address: [Address]
    
    init(id: UUID, name: String, npi:String, address: Address) {
        self.id = id
        self.name = name
        self.identifier = [Identifier(system: "NPI", value: npi)]
        self.address = [address]
    }
    
    func toEntity(ctx: NSManagedObjectContext) -> OrganizationEntity {
        let entity = OrganizationEntity(context: ctx)
        entity.id = self.id
        entity.name = self.name
        
        // Do the addresses
        self.address
            .map { addr in
                addr.toEntity(ctx: ctx)
        }
        .forEach { addrE in
            entity.addToAddressRelationship(addrE)
        }
        
        // Identifiers
        self.identifier
            .forEach{identifier in
                entity.addToIdRelationship(identifier.toEntity(ctx: ctx))
        }
        
        return entity
    }
}
