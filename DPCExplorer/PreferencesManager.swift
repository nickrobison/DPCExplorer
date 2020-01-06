//
//  PreferencesManager.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 12/26/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import DPCKit
import Combine
import CoreData

class PreferencesManager: ObservableObject {
    static let SettingsKey = "ApplicationSettings"
    
    @Published var client: DPCClient?
    @Published var settings: ApplicationSettings? {
        willSet(newSettings) {
            self.saveSettings(newSettings)
        }
    }
    @Published var publicKey: String
    @Published var privateKey: SecKey // DON'T DO THIS, we should simply return the value and then forget about it
    
    init() {
        let manager = KeyPairManager()
        self.publicKey = try! manager.convertToPEM(key: manager.getPublicKey()!)!
        self.privateKey = manager.getPrivateKey()!
        self.settings = loadSettings()
    }
    
    private func loadSettings() -> ApplicationSettings? {
        let defaults = UserDefaults.standard
        if let savedSettings = defaults.data(forKey: PreferencesManager.SettingsKey) {
            let decoder = JSONDecoder()
            return try? decoder.decode(ApplicationSettings.self, from: savedSettings)
        }
        
        return nil
    }
    
    private func saveSettings(_ settings: ApplicationSettings?) {
        guard let settings = settings else {
            return
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(settings) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: PreferencesManager.SettingsKey)
        }
    }
}


struct ApplicationSettings: Codable {
    var url: URL
    var clientToken: String
    var keyID: String
}
