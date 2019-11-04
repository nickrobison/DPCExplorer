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
import CoreData

final class DPCClient: ObservableObject {
    let baseURL: String
    let context: NSManagedObjectContext
    @Published var organization: OrganizationEntity?
    @Published var providers: [Provider]
    
    init(baseURL: String, context: NSManagedObjectContext) {
        self.baseURL = baseURL
        self.providers = []
        self.context = context;
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
                    
                    // Create a new Managed Organization and go from there
                    guard let value = response.value else {
                        return
                    }
                    self.organization = value.toEntity(ctx: self.context)
                    
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
    
    func fetchPatients() {
        guard self.organization != nil else {
            print("No organization yet")
            return
        }
        
        let uri = self.baseURL + "Patient"
        
        let dateStringFormatter = DateFormatter()
        // FHIR date formatter
        dateStringFormatter.dateFormat = "YYYY-MM-DD"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateStringFormatter)
        
        AF.request(uri)
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/fhir+json"])
            .responseDecodable(of: Bundle<Patient>.self, decoder: decoder){ response in
                debugPrint(response)
                switch response.result {
                case .success:
                    print("Succeeded!")
                    
                    guard let value = response.value else {
                        return
                    }
                    
                    value.entry.forEach{entry in
                        entry.resource.toEntity(ctx: self.context)
                    }
                    
                    // Try to save it
                    do {
                        try self.context.save()
                    } catch {
                        debugPrint("Error saving!")
                    }
                case let .failure(error):
                    print(error)
                }
    }
    }
}
