//
//  LoadData.swift
//  BlueButtonKit
//
//  Created by Nicholas Robison on 12/18/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import FHIR


func load<T: FHIRAbstractBase>(_ filename: String) -> T {
    let data: Data
    
    guard let bundle = Bundle(identifier: "com.nickrobison.BlueButtonKit") else {
        fatalError("Cannot find shared bundle")
    }
    
    guard let file = bundle.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in the main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? FHIRJSON
    
    var ctx = FHIRInstantiationContext(strict: false)
    let resource = T.init(json: json!, context: &ctx)
    
    ctx.errors.forEach {
        debugPrint($0)
    }
    
    return resource
}
