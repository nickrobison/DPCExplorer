//
//  VitalRecordBox.swift
//  BlueButtonKit
//
//  Created by Nicholas Robison on 12/21/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import SwiftUI
import SwiftIcons

enum RecordStatus: CaseIterable {
    case success
    case failure
    case unknown
}

struct VitalRecordBox: View {
    
    let status: RecordStatus
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
                generateStatusIcon(status)
            }
        }
        .padding()
        .background(Color.gray)
        .cornerRadius(20)
    }
    
    private func generateStatusIcon(_ status: RecordStatus) -> some View {
        let icon: String
        let color: Color
        switch (status) {
        case .success:
            icon = "checkmark.circle"
            color = .green
        case .failure:
            icon = "multiply.circle"
            color = .red
        case .unknown:
            icon = "questionmark.circle"
            color = .orange
        }
        
        return Image(systemName: icon)
            .foregroundColor(color)
            .imageScale(.large)
    }
}

struct VitalRecordBox_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(RecordStatus.allCases, id: \.self) { status in
            VitalRecordBox(status: status)
        }
    }
}
