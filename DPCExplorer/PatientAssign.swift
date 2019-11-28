//
//  PatientAssign.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 11/27/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import Combine

struct PatientAssign: View {
    @Environment(\.presentationMode) var presentationMode
    
    let assignablePatients: [String]
    var body: some View {
        NavigationView {
            List(assignablePatients, id:\.self) { patient in
                Text(patient)
            }
                
            .navigationBarTitle(Text("Assignable Patients"))
            .navigationBarItems(leading: Button(action: {
                debugPrint("Cancel")
                self.presentationMode.wrappedValue.dismiss()
            }, label: {Text("Cancel")}), trailing:
                Button(action: {
                    //                self.create()
                }, label: { Text("Add")}))
        }
    }
}

struct PatientAssign_Previews: PreviewProvider {
    static var previews: some View {
        PatientAssign(assignablePatients: ["Nick", "Callie"])
    }
}
