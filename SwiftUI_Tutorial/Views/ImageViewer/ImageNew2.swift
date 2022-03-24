//
//  ImageNew2.swift
//  SwiftUI_Tutorial
//
//  Created by Hau Nguyen on 10/03/2022.
//

import SwiftUI

struct ImageNew2: View {
    
    var body: some View {
        ZStack {
            ZoomableScrollView2 {
                Image("flower5")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
}

struct ImageNew2_Previews: PreviewProvider {
    static var previews: some View {
        ImageNew2()
    }
}
