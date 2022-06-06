//
//  ImageUIDemo.swift
//  SwiftUI_Tutorial
//
//  Created by HauNguyen on 03/06/2022.
//

import SwiftUI

struct ImageUIDemo: View {
    var body: some View {
        ZStack{
            Text("Hello world!")
                .font(.title2)
                .foregroundColor(Color.primary)
        }
    }
}

struct ImageUIDemo_Previews: PreviewProvider {
    static var previews: some View {
        ImageUIDemo()
    }
}
