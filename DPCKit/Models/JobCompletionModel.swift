//
//  JobCompletionModel.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 11/17/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation

struct JobOutputModel: Codable {
    let type: String
    let url: URL
    let count: Int32
}

struct JobCompletionModel: Codable {
    let request: URL
    let output: [JobOutputModel]
}
