//
//  DPCClient.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

final class DPCClient: ObservableObject {
    let baseURL: String
    @Published var organization: Organization?
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func fetchOrganization() {
        self.organization = testOrg
    }
}
