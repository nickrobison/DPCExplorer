//
//  ExportManager.swift
//  DPCKit
//
//  Created by Nicholas Robison on 1/20/20.
//  Copyright © 2020 Nicholas Robison. All rights reserved.
//

import Foundation
import Alamofire
import CoreData
import FHIR

extension ProviderEntity {
    var reference: Reference {
        let ref = Reference()
        ref.reference = FHIRString("Practitioner/\(self.id!)")
        return ref
    }
}

class ExportManager {
    
    private let baseURL: String
    private let session: Session
    private let context: NSManagedObjectContext
    private var exportsInProgress: [Reference: ExportClient] = [:]
    private let token: String
    
    
    init(with baseURL: String, interceptor: SMARTAuthHandler, context: NSManagedObjectContext) {
        debugPrint("Initializing Export Manager")
        self.baseURL = baseURL
        
        // Create the retriers and the default session
        // Eventually, this will need to be setup for background requests
        self.session = Session(configuration: URLSessionConfiguration.default, interceptor: interceptor as RequestInterceptor)
        self.context = context
        self.token = interceptor.accessToken
    }
    
    func beginExport(for provider: ProviderEntity, handler: @escaping () -> Void) {
        let client = ExportClient(with: self.baseURL, provider: provider, context: self.context, token: self.token)
        client.exportData(handler)
        exportsInProgress[provider.reference] = client
    }
    
    func cancelExport(for provider: ProviderEntity) {
        guard let _ = self.exportsInProgress[provider.reference] else {
            return
        }
        
        // Cancel the export job
    }
}
