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
import Alamofire

final class DPCClient: ObservableObject {
    let baseURL: String
    @Published var organization: Organization?
    @Published var providers: [Provider]
    
    init(baseURL: String) {
        self.baseURL = baseURL
        self.providers = []
    }
    
    func fetchOrganization() {
        let uri = self.baseURL + "Organization/46ac7ad6-7487-4dd0-baa0-6e2c8cae76a0"
        AF.request(uri)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/fhir+json"])
            .responseDecodable(of: Organization.self){ response in
            debugPrint(response)
                switch response.result {
                case .success:
                    print("Succeeded!")
                    self.organization = response.value
                case let .failure(error):
                    print(error)
                }
        }
    }
    
    func fetchProviders() {
        guard self.organization != nil else {
            print("No organization yet")
            return
        }
        
        // Fetch providers from the server
        let uri = self.baseURL + "Practitioner"
        
        AF.request(uri)
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/fhir+json"])
            .responseDecodable(of: Bundle<Provider>.self){ response in
            debugPrint(response)
            switch response.result {
            case .success:
                print("Succeeded!")
                self.providers = testProviders
            case let .failure(error):
                print(error)
            }
        }
    }
}
