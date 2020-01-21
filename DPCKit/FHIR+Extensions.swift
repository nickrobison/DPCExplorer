//
//  FHIR+Extensions.swift
//  DPCKit
//
//  Created by Nicholas Robison on 1/20/20.
//  Copyright © 2020 Nicholas Robison. All rights reserved.
//

import Foundation
import FHIR

extension Reference: Hashable {
    public static func == (lhs: Reference, rhs: Reference) -> Bool {
        lhs.reference == rhs.reference
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.reference?.string)
    }
}
