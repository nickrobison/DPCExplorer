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
import FHIR

final class DPCClient: ObservableObject {
    let baseURL: String
    let context: NSManagedObjectContext
    @Published var organization: OrganizationEntity?
    @Published var providers: [Provider]
    
    init(baseURL: String, context: NSManagedObjectContext) {
        self.baseURL = baseURL
        self.providers = []
        self.context = context
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
                    guard let value = response.value else {
                        return
                    }
                    
                    value.entry.forEach{entry in
                        // Check if the entry already exists, if so, move on
                        let req = NSFetchRequest<ProviderEntity>(entityName: "ProviderEntity")
                        req.predicate = NSPredicate(format: "id = %@", entry.resource.id.uuidString)
                        let existing = try! self.context.fetch(req)
                        guard existing.isEmpty else {
                            return
                        }
                        entry.resource.toEntity(ctx: self.context)
                    }
                    
                    // Try to save it
                    do {
                        try self.context.save()
                    } catch {
                        debugPrint("Error saving!", error)
                    }
                case let .failure(error):
                    print(error)
                }
        }
    }
    
    func fetchPatientsForProvider(provider: ProviderEntity) {
        let url = self.baseURL + "Group"
        let params: Alamofire.Parameters = [
            "characteristic-value": "|attributed-to$|\(provider.getFirstID.value!)"
        ]
        
        AF.request(url, method: .get, parameters: params,
                   encoding: URLEncoding(destination: .queryString))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/fhir+json"])
            .responseData { response in
                debugPrint(response)
                guard let value = response.value else {
                    return
                }
                var json: FHIRJSON?
                do {
                    json = try JSONSerialization.jsonObject(with: value, options: []) as? FHIRJSON
                }
                catch let error as NSError {
                    debugPrint(error)
                    return
                }
                do {
                    let bundle = try FHIR.Bundle.init(json: json!)
                    guard let entry = bundle.entry else {
                        return
                    }
                    let group = entry[0].resource as! FHIR.Group
                    // Do things with the members
                    guard let members = group.member else {
                        return
                    }
                    
                    if  let id = group.id?.string {
                        provider.rosterID = UUID(uuidString: id)
                    }
                    
                    // Create Roster entries for each group
                    members.forEach { member in
                        let reference = member.entity!.reference!
                        
                        let split = reference.string.components(separatedBy: "/")
                        // Get the patient ID
                        let patientID = split[1]
                        
                        // Look them up in Core Data
                        let req = NSFetchRequest<PatientEntity>(entityName: "PatientEntity")
                        req.predicate = NSPredicate(format: "id = %@", patientID)
                        let patientFetch = try! self.context.fetch(req)
                        
                        guard !patientFetch.isEmpty else {
                            return
                        }
                        let patient = patientFetch[0]
                        provider.addToPatientRelationship(patient)
                    }
                    
                    // Save the changes
                    do {
                        try self.context.save()
                    } catch {
                        debugPrint("Error saving!")
                    }
                    self.context.refreshAllObjects()
                }
                catch let error as NSError {
                    debugPrint(error)
                    return
                }
        }
    }
    
    func fetchAssignablePatients(provider: ProviderEntity) -> Publishers.Sequence<[PatientEntity], Never> {
        let req = NSFetchRequest<PatientEntity>(entityName: "PatientEntity")
        // Find all the unassigned patients
        req.predicate = NSPredicate(format: "ANY providerRelationship != %@", provider)
        return try! self.context.fetch(req).publisher
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
                        // Check if the entry already exists, if so, move on
                        let req = NSFetchRequest<PatientEntity>(entityName: "PatientEntity")
                        req.predicate = NSPredicate(format: "id = %@", entry.resource.id.uuidString)
                        let existing = try! self.context.fetch(req)
                        guard existing.isEmpty else {
                            return
                        }
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
    
    func exportData(provider: ProviderEntity) -> Void {
        let client = ExportClient(with: "http://localhost:3002/v1", provider: provider, context: self.context)
        client.exportData()
    }
    
    func addPatient(patient: FHIR.Patient) -> Void {
        // Submit to DPC
        var errors: [FHIRValidationError] = []
        let params = patient.asJSON(errors: &errors)
        let uri = self.baseURL + "Patient"
        let headers: HTTPHeaders = [
            "Content-Type": "application/fhir+json"
        ]
        AF.request(uri, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/fhir+json"])
            .responseData { response in
                debugPrint(response)
                
                debugPrint(response)
                guard let value = response.value else {
                    return
                }
                var json: FHIRJSON?
                do {
                    json = try JSONSerialization.jsonObject(with: value, options: []) as? FHIRJSON
                }
                catch let error as NSError {
                    debugPrint(error)
                    return
                }
                
                let patient = try! FHIR.Patient.init(json: json!)
                
                self.context.perform {
                    do {
                        let _ = patient.toEntity(ctx: self.context)
                        try self.context.save()
                    } catch {
                        debugPrint("Error saving!", error)
                    }
                }
        }
    }
    
    func addProvider(provider: FHIR.Practitioner) -> Void {
        let uri = self.baseURL + "Practitioner"
        
        var errors: [FHIRValidationError] = []
        let params = provider.asJSON(errors: &errors)
        let headers: HTTPHeaders = [
            "Content-Type": "application/fhir+json"
        ]
        AF.request(uri, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/fhir+json"])
            .responseFHIRResource(of: Practitioner.self){ response in
                debugPrint(response)
                
                guard let value = response.value else {
                    return
                }
                
                self.context.perform {
                    do {
                        let _ = value.toEntity(ctx: self.context)
                        try self.context.save()
                    } catch {
                        debugPrint("Error saving!", error)
                    }
                }
        }
    }
}
