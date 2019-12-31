//
//  ProviderAdd.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 11/24/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import FHIR
import DPCKit

struct ProviderAdd: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var viewModel = ProviderAddViewModel()
    
    let completionHandler: CompletionHandler<Practitioner>?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("First Name", text: self.$viewModel.firstName)
                    TextField("Last Name", text: self.$viewModel.lastName)
                    TextField("NPI", text: self.$viewModel.npi)
                }
            }
            .navigationBarTitle(Text("Add Provider"))
            .navigationBarItems(leading: Button(action: {
                debugPrint("Cancel")
                self.presentationMode.wrappedValue.dismiss()
            }, label: {Text("Cancel")}), trailing:
                Button(action: {
                    self.create()
                }, label: { Text("Add")})
                    .disabled(!self.viewModel.isValid))
        }
    }
    
    private func create() -> Void {
        let provider = FHIR.Practitioner()
        
        let id = FHIR.Identifier()
        id.system = FHIRURL.init("http://hl7.org/fhir/sid/us-npi")
        id.value = FHIRString.init(self.viewModel.npi)
        provider.identifier = [id]
        
        let name = HumanName()
        name.given = [FHIRString.init(self.viewModel.firstName)]
        name.family = FHIRString.init(self.viewModel.lastName)
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
