//
//  BlueButtonOverviewView.swift
//  BlueButtonKit
//
//  Created by Nicholas Robison on 12/18/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI

struct BlueButtonOverviewView: View {
    
    let str: String
    var body: some View {
        Text(str)
    }
}

struct BlueButtonOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        BlueButtonOverviewView(str: testString)
    }
}
