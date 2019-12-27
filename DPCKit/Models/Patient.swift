//
//  Patient.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import CoreData
import FHIR
import Compression

public extension PatientEntity {
    var getFirstName: HumanName {
        let name = HumanName()
        name.family = FHIRString.init(self.family ?? "")
        name.given = [FHIRString.init(self.given ?? "")]
        return name
    }
    var getFirstID: FHIRIdentifier {
        let ids = self.identifierRelationship?.allObjects as? [PatientIdentifier]
        return ids![0]
    }
}

extension PatientEntity: Person {
    public var name: [HumanName] {
        let name = HumanName()
        name.family = FHIRString.init(self.family ?? "")
        name.given = [FHIRString.init(self.given ?? "")]
        return [name]
    }
}

extension PatientEntity {
    public var claims: [ExplanationOfBenefit] {
        guard let eobs = self.eobs else {
            return []
        }
        
        var returnValues: [ExplanationOfBenefit] = []
        eobs.forEach { eob in
            guard let decompressed = decompressData(input: (eob as! EOBEntity).eob) else {
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: decompressed, options: []) as? FHIRJSON
            
            // Disable validation, because we have custom extensions
            var ctx = FHIRInstantiationContext(strict: false)
            let eob = FHIR.ExplanationOfBenefit.init(json: json!, context: &ctx)
            returnValues.append(eob)
        }
        
        return returnValues
    }
}


func decompressData(input: Data?) -> Data? {
    guard let input = input else {
        return nil
    }
    
    let pageSize = 128
    var decompressed = Data()
    do {
        var index = 0
        let bufferSize = input.count
        debugPrint("Compressed size: \(bufferSize)")
        
        let inputFilter = try InputFilter(.decompress, using: .lzfse) { (length: Int) -> Data? in
            let rangeLength = min(length, bufferSize - index)
            let subdata = input.subdata(in: index ..< index + rangeLength)
            index += rangeLength
            return subdata
        }
        
        while let page = try inputFilter.readData(ofLength: pageSize) {
            decompressed.append(page)
        }
        
    } catch {
        fatalError("Error occurred during decoding: \(error.localizedDescription).")
    }
    
    return decompressed;
}
