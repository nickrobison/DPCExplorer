//
//  PatientAssign.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 11/27/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import Combine
import FHIR
import DPCKit

struct PatientAssign: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let assignablePatients: [PatientEntity]
    let completionHandler: ((_ patients: [PatientEntity]) -> Void)?
    
    @State var assignedPatients: [PatientEntity] = []
    var body: some View {
        NavigationView {
            List(assignablePatients, id:\.self) { patient in
                SelectableRow(title: self.formatName(patient), isSelected: self.assignedPatients.contains(patient), action: {
                    if self.assignedPatients.contains(patient) {
                        self.assignedPatients.removeAll(where: {$0 == patient})
                    } else {
                        self.assignedPatients.append(patient)
                    }
                })
            }
            .navigationBarTitle(Text("Assignable Patients"))
            .navigationBarItems(leading: Button(action: {
                debugPrint("Cancel")
                self.presentationMode.wrappedValue.dismiss()
            }, label: {Text("Cancel")}), trailing:
                Button(action: {
                    self.create()
                }, label: { Text("Add")}))
        }
    }
    
    private func create() -> Void {
        self.completionHandler?(self.assignedPatients)
        self.presentationMode.wrappedValue.dismiss();
    }
    
    private func formatName(_ patient: PatientEntity) -> String {
        let name = patient.getFirstName
        return "\(name.family!), \(name.given!)"
    }
}

struct PatientAssign_Previews: PreviewProvider {
    static var previews: some View {
        PatientAssign(assignablePatients: nickPatients, completionHandler: nil)
    }
}
