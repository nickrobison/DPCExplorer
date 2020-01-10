//
//  TabIcon.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 1/10/20.
//  Copyright © 2020 Nicholas Robison. All rights reserved.
//

import SwiftUI
import SwiftIcons

struct TabIcon: View {
    
    let icon: FontType
    var body: some View {
        Image(uiImage: UIImage.init(icon: self.icon, size: CGSize(width: 35, height: 35)))
    }
}

struct TabIcon_Previews: PreviewProvider {
    static var previews: some View {
        TabIcon(icon: .fontAwesomeSolid(.hospital))
    }
}
