//
//  PractitionerView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/27/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import CoreData
import FHIR
import DPCKit

struct ProviderDetailView: View {
    @EnvironmentObject var client: DPCClient
    
    @State private var showAdd = false
    
    let provider: ProviderEntity
    let notificationCenter = NotificationDelegate()
    var body: some View {
        VStack {
            ProviderBioView(provider: provider)
                .padding()
            if (provider.patientRelationship!.count > 0) {
                Divider()
                List {
                    ForEach(provider.patientRelationship!.allObjects as! [PatientEntity], id: \.self){
                        patient in
                        NavigationLink(destination: PatientDetailView(patient: patient)) {
                            PersonCellView(person: patient)
                                .font(.body)
                        }
                    }
                    .onDelete(perform: self.performDelete)
                }
            } else {
                /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
            }
            Divider()
            HStack {
                Button(action: {
                    self.client.exportData(provider: self.provider) {
                        self.notificationCenter.sendNotification(notificationType: "Export Data", msg: "Export Completed")
                    }
                }) {
                    Text("Update Data")
                }
                Button(action: {
                    debugPrint("Adding patient")
                    self.showAdd = true
                }) {
                    Text("Add Patient")
                }
            }
            Spacer()
        }
        .onAppear() {
            self.client.fetchPatientsForProvider(provider: self.provider)
        }
        .sheet(isPresented: $showAdd, content: {
            PatientAssign(assignablePatients: self.getAssignablePatients(), completionHandler: self.assignPatients)
        })
    }
    
    func performDelete(at offsets: IndexSet) {
        debugPrint(offsets)
    }
    
    private func getAssignablePatients() -> [PatientEntity] {
        let names = self.client.fetchAssignablePatients(provider: provider)
            .collect()
            .result
        
        switch names {
        case .success(let data):
            return data
        case .failure(let error):
            debugPrint(error)
            return []
        }
    }
    
    private func assignPatients(patients: [PatientEntity]) -> Void {
        debugPrint("References:", patients)
        self.client.assignPatients(patients, to: self.provider)
    }
    
}

//struct ProviderDefailtView_Previews: PreviewProvider {
//
//
//    static var previews: some View {
//        ForEach(testProviders, id: \.self) {
//            provider in
//            ProviderDetailView(provider: provider)
//        }
//
//    }
//}
