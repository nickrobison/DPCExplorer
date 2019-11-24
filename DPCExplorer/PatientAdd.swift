//
//  PatientAdd.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 11/23/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import FHIR

struct PatientAdd: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var client: DPCClient
    
    
    private let genderValues = ["Male", "Female", "Other", "Unknown"]
    private let minDate = Calendar.current.date(byAdding: .year, value: -65, to: Date())!
    @State private var lastName = ""
    @State private var firstName = ""
    @State private var mbi = ""
    @State private var birthday = Date()
    @State private var gender = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("MBI", text: $mbi)
                }
                Section(header: Text("Birthday")) {
                    DatePicker(selection: $birthday, in: ...self.minDate, displayedComponents: .date, label: { EmptyView() })
                }
                Section {
                    Picker(selection: $gender, label: Text("Gender")) {
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
                }, label: { Text("Add")}))
        }
        
    }
    
    private func create() -> Void {
        debugPrint("Creating")
        let patient = FHIR.Patient()
        
        let id = FHIR.Identifier()
        id.system = FHIRURL.init("http://not.real")
        id.value =  FHIRString.init(self.mbi)
        patient.identifier = [id]
        
        let name = HumanName()
        name.given = [FHIRString.init(self.firstName)]
        name.family = FHIRString.init(self.lastName)
        patient.name = [name]
        
        self.client.addPatient(patient: patient)
        //        let patient = PatientEntity(context: self.context)
        //
        //        let name = NameEntity(context: self.context)
        //        name.family = self.lastName
        //        name.given = self.firstName
        //        patient.addToNameRelationship(name)
        //
        //        let id = IdentitiferEntity(context: self.context)
        //        id.system = "http://test.system"
        //        id.value = self.mbi
        //        patient.addToIdentifierRelationship(id)
        //        patient.birthdate = self.birthday
        //
        //        do {
        //            try self.context.save()
        //        } catch {
        //            debugPrint(error)
        //        }
        
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct PatientAdd_Previews: PreviewProvider {
    static var previews: some View {
        PatientAdd()
    }
}
