//
//  File.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import CoreData

public extension ProviderEntity {
    public var getFirstName: NameEntity {
        let names = self.nameRelationship?.allObjects as? [NameEntity]
        return names![0]
    }
    public var getFirstID: FHIRIdentifier {
        let ids = self.idRelationship?.allObjects as? [ProviderIdentifier]
        return ids![0]
    }
}

extension ProviderEntity: Person {
    public var name: [NameEntity] {
        let names = self.nameRelationship?.allObjects as? [NameEntity]
        return names ?? []
    }
}
