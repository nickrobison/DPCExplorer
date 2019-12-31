//
//  PatientAdd.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 11/23/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import FHIR
import DPCKit

struct PatientAdd: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var addModel = PatientAddViewModel()
    
    let completionHandler: CompletionHandler<FHIR.Patient>?
    
    private let genderValues = ["Male", "Female", "Other", "Unknown"]
    private let minDate = Calendar.current.date(byAdding: .year, value: -65, to: Date())!
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("First Name", text: self.$addModel.firstName)
                    TextField("Last Name", text: self.$addModel.lastName)
                    TextField("MBI", text: self.$addModel.mbi)
                }
                Section(header: Text("Birthday")) {
                    DatePicker(selection: self.$addModel.birthday, in: ...self.minDate, displayedComponents: .date, label: { EmptyView() })
                }
                Section {
                    Picker(selection: self.$addModel.gender, label: Text("Gender")) {
                        ForEach(0 ..< self.genderValues.count) {
                            Text(self.genderValues[$0])
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Add Patient"))
            .navigationBarItems(leading: Button(action: {
                debugPrint("Cancel")
                self.presentationMode.wrappedValue.dismiss()
            }, label: {Text("Cancel")}), trailing:
                Button(action: {
                    self.create()
                }, label: { Text("Add")})
                    .disabled(!self.addModel.isValid))
            
        }
        
    }
    
    private func create() -> Void {
        debugPrint("Creating")
        let patient = FHIR.Patient()
        
        let id = FHIR.Identifier()
        id.system = FHIRURL.init("https://bluebutton.cms.gov/resources/variables/bene_id")
        id.value =  FHIRString.init(self.addModel.mbi)
        patient.identifier = [id]
        
        let name = HumanName()
        name.given = [FHIRString.init(self.addModel.firstName)]
        name.family = FHIRString.init(self.addModel.lastName)
        patient.name = [name]
        patient.birthDate = self.addModel.birthday.fhir_asDate()
        patient.gender = AdministrativeGender.init(rawValue: self.genderValues[self.self.addModel.gender].lowercased())
        
        self.completionHandler?(patient)
        self.presentationMode.wrappedValue.dismiss();
    }
}

struct PatientAdd_Previews: PreviewProvider {
    static var previews: some View {
        PatientAdd(completionHandler: nil)
    }
}
