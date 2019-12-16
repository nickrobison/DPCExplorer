//
//  PatientView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import Foundation
import CoreData
import FHIR
import DPCKit

struct PatientView: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var client: DPCClient
    
    @State private var showAdd = false
    
    @FetchRequest(
        entity: PatientEntity.entity(),
        sortDescriptors: []
    )
    var patients: FetchedResults<PatientEntity>
    var body: some View {
        NavigationView {
            List(patients, id:\.id) {patient in
                NavigationLink(destination: PatientDetailView(patient: patient)) {
                    PersonCellView(person: patient)
                }
            }
            .navigationBarTitle("Patients")
            .navigationBarItems(trailing:
                Button(action: {
                    debugPrint("clicked")
                    self.showAdd = true
                }, label: { Image(systemName: "plus")}))
        }
        .onAppear() {
            debugPrint("Here are the patients")
            self.client.fetchPatients()
        }
        .sheet(isPresented: $showAdd, content: {
            PatientAdd(completionHandler: self.submitPatient)
        })
    }
    
    private func submitPatient(patient: FHIR.Patient) {
        self.client.addPatient(patient: patient)
    }
}

struct PatientView_Previews: PreviewProvider {
    static var previews: some View {
        PatientView()
    }
}
