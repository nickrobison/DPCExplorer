//
//  VitalRecordBox.swift
//  BlueButtonKit
//
//  Created by Nicholas Robison on 12/21/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import SwiftIcons

struct VitalRecordBox: View {
    var body: some View {
        VStack {
            HStack {
                Image(uiImage: UIImage.init(icon: .fontAwesomeSolid(.syringe), size: CGSize(width: 50, height: 50)))
                Spacer()
                Text("Flu Shot")
                    .foregroundColor(.white)
                    .font(.title)
                Spacer()
            }
            Text("1/3/18")
                .font(.subheadline)
            HStack {
                Spacer()
                Image(systemName: "checkmark.circle")
                    .foregroundColor(Color.green)
                    .imageScale(.large)
                    .padding()
            }
        }
        .padding()
        .background(Color.gray)
        .cornerRadius(20)
    }
}

struct VitalRecordBox_Previews: PreviewProvider {
    static var previews: some View {
        VitalRecordBox()
    }
}
