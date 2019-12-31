//
//  BoxBuilder.swift
//  BlueButtonKit
//
//  Created by Nicholas Robison on 12/30/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation

public protocol BoxBuilder {
    func build() -> VitalRecordBox
}
