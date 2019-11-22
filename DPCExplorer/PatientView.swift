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

struct PatientView: View {
    @EnvironmentObject var client: DPCClient
    
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
            }, label: { Image(systemName: "plus")}))
    }
        .onAppear() {
            debugPrint("Here are the patients")
            self.client.fetchPatients()
        }
    }
}

struct PatientView_Previews: PreviewProvider {
    static var previews: some View {
        PatientView()
    }
}
