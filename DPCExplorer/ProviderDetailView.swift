//
//  PractitionerView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/27/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import CoreData

struct ProviderDetailView: View {
    @EnvironmentObject var client: DPCClient
    
    @State private var showAdd = false
    
    let provider: ProviderEntity
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
                    self.client.exportData(provider: self.provider)
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
            PatientAssign(assignablePatients: self.getPatientNames())
        })
    }
    
    func performDelete(at offsets: IndexSet) {
        debugPrint(offsets)
    }
    
    func getPatientNames() -> [String] {
        let names = self.client.fetchAssignablePatients(provider: provider)
            .map({
                return $0.getFirstName.given!
            })
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
