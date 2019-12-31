//
//  DefaultBoxBuilder.swift
//  BlueButtonKit
//
//  Created by Nicholas Robison on 12/30/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation

struct DefaultBoxBuilder: BoxBuilder {
     
    let status: RecordStatus
    
    func build() -> VitalRecordBox {
        return VitalRecordBox(self.status)
    }
}
