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
    @Published var settings: ApplicationSettings?
    
    init() {
        self.settings = loadSettings()
    }
    
    func loadSettings() -> ApplicationSettings? {
        let defaults = UserDefaults.standard
        if let savedSettings = defaults.data(forKey: PreferencesManager.SettingsKey) {
            let decoder = JSONDecoder()
            return try? decoder.decode(ApplicationSettings.self, from: savedSettings)
        }
        
        return nil
    }
    
    func saveSettings(_ settings: ApplicationSettings) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(settings) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: PreferencesManager.SettingsKey)
            self.settings = settings
        }
    }
}


struct ApplicationSettings: Codable {
    var url: URL
    var clientToken: String
}
