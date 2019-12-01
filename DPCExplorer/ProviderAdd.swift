//
//  ProviderAdd.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 11/24/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import FHIR

struct ProviderAdd: View {
    @Environment(\.presentationMode) var presentationMode
    
    let completionHandler: CompletionHandler<Practitioner>?
    
    @State private var lastName = ""
    @State private var firstName = ""
    @State private var npi = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("NPI", text: $npi)
                }
            }
            .navigationBarTitle(Text("Add Provider"))
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
        let provider = FHIR.Practitioner()
        
        let id = FHIR.Identifier()
        id.system = FHIRURL.init("http://hl7.org/fhir/sid/us-npi")
        id.value = FHIRString.init(self.npi)
        provider.identifier = [id]
        
        let name = HumanName()
        name.given = [FHIRString.init(self.firstName)]
        name.family = FHIRString.init(self.lastName)
        provider.name = [name]
        
        self.completionHandler?(provider)
        self.presentationMode.wrappedValue.dismiss();
    }
}

struct ProviderAdd_Previews: PreviewProvider {
    static var previews: some View {
        ProviderAdd(completionHandler: nil)
    }
}
