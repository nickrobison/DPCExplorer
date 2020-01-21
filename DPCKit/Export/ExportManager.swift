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
    private let token: String
    private let interceptor: SMARTAuthHandler
    
    private let monitorQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Export Monitor Queue"
        return queue
    }()
    
    private let downloadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Export Download Queue"
        return queue
    }()
    
    private var exportsInProgress: [Reference: ExportWatcher] = [:]
    
    init(with baseURL: String, interceptor: SMARTAuthHandler, context: NSManagedObjectContext) {
        debugPrint("Initializing Export Manager")
        self.baseURL = baseURL
        
        // Create the retriers and the default session
        // Eventually, this will need to be setup for background requests
        self.interceptor = interceptor
        self.session = Session(configuration: URLSessionConfiguration.default, interceptor: interceptor as RequestInterceptor)
        self.context = context
        self.token = interceptor.accessToken
    }
    
    func beginExport(for provider: ProviderEntity, handler: @escaping () -> Void) {
        
        guard let groupID = provider.rosterID else {
            debugPrint("No roster, nothing to export")
            return
        }
        let watcher = ExportWatcher(groupID: groupID.uuidString, interceptor: self.interceptor) { response in
            debugPrint("Ready to download \(response.count) files.")
        }
        exportsInProgress[provider.reference] = watcher
        self.downloadQueue.addOperation(watcher as Operation)
    }
    
    func cancelExport(for provider: ProviderEntity) {
        guard let _ = self.exportsInProgress[provider.reference] else {
            return
        }
        // Cancel the export job
    }
    
    func exportInProgress(for provider: ProviderEntity) -> Bool {
        self.exportsInProgress[provider.reference] != nil
    }
}
