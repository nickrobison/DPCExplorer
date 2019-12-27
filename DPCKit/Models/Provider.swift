//
//  File.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import CoreData
import FHIR

public extension ProviderEntity {
    var getFirstName: HumanName {
        let name = HumanName()
        name.family = FHIRString.init(self.family ?? "")
        name.given = [FHIRString.init(self.given ?? "")]
        return name
    }
    var getFirstID: FHIRIdentifier {
        let ids = self.idRelationship?.allObjects as? [ProviderIdentifier]
        return ids![0]
    }
}

extension ProviderEntity: Person {
    public var name: [HumanName] {
        let name = HumanName()
        name.family = FHIRString.init(self.family ?? "")
        name.given = [FHIRString.init(self.given ?? "")]
        return [name]
    }
}
