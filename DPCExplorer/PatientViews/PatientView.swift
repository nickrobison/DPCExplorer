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
        sortDescriptors: [
            NSSortDescriptor(keyPath: \PatientEntity.family, ascending: true)]
    )
    var patients: FetchedResults<PatientEntity>
    var body: some View {
        NavigationView {
            DeletableList(elements: self.patients, id: \.self, factory: { patient in
                NavigationLink(destination: PatientDetailView(patient: patient)) {
                    PersonCellView(person: patient)
                }
                .isDetailLink(true)
            }, deleteHandler: self.remove)
                .navigationBarTitle("Patients")
                .navigationBarItems(trailing:
                    Button(action: {
                        debugPrint("clicked")
                        self.showAdd = true
                    }, label: { Image(systemName: "plus")}))
        }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
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
    
    private func remove(at offsets: IndexSet) {
        for index in offsets {
            let patient = patients[index]
            self.client.delete(patient: patient)
        }
    }
}

struct PatientView_Previews: PreviewProvider {
    static var previews: some View {
        PatientView()
    }
}
