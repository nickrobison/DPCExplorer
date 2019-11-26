//
//  PatientDetailView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct PatientTabView: View {
    
    let viewIdx: Int
    let patient: PatientEntity
    
    var body: some View {
        switch viewIdx {
        case 0:
            return AnyView(buildOverview())
        case 1:
            return AnyView(buildProviders())
        case 2:
            return buildClaims()
        default:
            return AnyView(buildDefault())
        }
    }
    
    private func buildOverview() -> some View {
        return Text("Overview")
    }
    
    private func buildProviders() -> some View {
        return List(self.patient.providerRelationship?.allObjects as! [ProviderEntity], id: \.self) { provider in
            PersonCellView(person: provider)
        }
    }
    
    private func buildClaims() -> AnyView  {
        if (self.patient.eob != nil) {
            return AnyView(buildWithClaims())
        } else {
            return AnyView(buildNoClaims())
        }
    }
    
    private func buildWithClaims() -> some View {
        return HStack {
            Text("Fetched EOBs")
            Image(systemName: "checkmark.circle.fill")
                .font(.subheadline)
                .foregroundColor(.green)
            
        }
    }
    
    private func buildNoClaims() -> some View {
        return EmptyView()
    }
    
    private func buildDefault() -> some View {
        return EmptyView()
    }
}

struct PatientDetailView: View {
    @State private var selectorIndex = 0
    let patient: PatientEntity
    var body: some View {
        VStack {
            PatientBioView(patient: patient)
                .padding()
            Divider()
            Picker("Tabs", selection: $selectorIndex) {
                Text("Overview").tag(0)
                Text("Providers").tag(1)
                Text("Claims").tag(2)
                
            }
            .pickerStyle(SegmentedPickerStyle())
            PatientTabView(viewIdx: $selectorIndex.wrappedValue, patient: self.patient)
            
            Spacer()
        }
    }
}

struct PatientDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PatientDetailView(patient: blythe)
    }
}
