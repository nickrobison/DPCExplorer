//
//  ClaimsOverviewView.swift
//  BlueButtonKit
//
//  Created by Nicholas Robison on 12/22/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import FHIR

public struct ClaimsOverviewView: View {
    let boxes: [BoxBuilder]
    
    public init(boxes: [BoxBuilder]) {
        self.boxes = boxes
    }
    
    public var body: some View {
        VStack {
            HStack {
                Text("Patient Overview")
                    .font(.title)
                Spacer()
            }
            .padding([.bottom])
            Text("Quick look")
            ForEach(0..<self.boxes.count, id:\.self){ idx in
                self.boxes[idx].build()
                    .padding([.trailing, .leading])
            }
        }
    }
}

struct ClaimsOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        ClaimsOverviewView(boxes: [DefaultBoxBuilder(name: "Flu Shot", status: .success)])
    }
}
