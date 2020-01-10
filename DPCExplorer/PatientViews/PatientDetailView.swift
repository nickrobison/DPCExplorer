//
//  PatientDetailView.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 10/31/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import DPCKit
import BlueButtonKit

struct PatientTabView: View {
    
    let viewIdx: Int
    let patient: PatientEntity
    @EnvironmentObject var manager: ClaimsManager
    
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
        VStack {
            Text("Overview")
            ScrollView {
                if(self.manager.claims.count > 0) {
                    ClaimsOverviewView(boxes: self.manager.boxes)
                }
            }
        }
    }
    
    private func buildProviders() -> some View {
        return List(self.patient.providerRelationship?.allObjects as! [ProviderEntity], id: \.self) { provider in
            PersonCellView(person: provider)
        }
    }
    
    private func  buildClaims() -> AnyView  {
        if (self.patient.eobs?.count ?? 0 > 1) {
            return AnyView(buildWithClaims())
        } else {
            return AnyView(buildNoClaims())
        }
    }
    
    private func buildWithClaims() -> some View {
        return ScrollView {VStack {
            Text("Fetched EOBs: \(patient.claims.count)")
            Image(systemName: "checkmark.circle.fill")
                .font(.subheadline)
                .foregroundColor(.green)
            
            ClaimsHistoryView(eob: self.manager.claims)
            }
        }
    }
    
    private func buildNoClaims() -> some View {
        return Text("No claims history yet")
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
                .environmentObject(ClaimsManager(eob: self.patient.claims))
            
            Spacer()
        }
    }
}

struct PatientDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PatientDetailView(patient: blythe)
    }
}
