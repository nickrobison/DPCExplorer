//
//  Patient.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import CoreData

public extension PatientEntity {
    var getFirstName: NameEntity {
        let names = self.nameRelationship?.allObjects as? [NameEntity]
        return names![0]
    }
    var getFirstID: FHIRIdentifier {
        let ids = self.identifierRelationship?.allObjects as? [PatientIdentifier]
        return ids![0]
    }
}

extension PatientEntity: Person {
    public var name: [NameEntity] {
        let names = self.nameRelationship?.allObjects as? [NameEntity]
        return names ?? []
    }
}
