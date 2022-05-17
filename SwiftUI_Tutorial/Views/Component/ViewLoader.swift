//
//  ViewLoader.swift
//  SwiftUI_Tutorial
//
//  Created by HauNguyen on 15/05/2022.
//

import SwiftUI

struct ViewLoader: View {
    @Binding var isFailed: Bool
    
    var body: some View {
        Text(isFailed ? "Failed. Tap to retry." : "Loading..")
            .foregroundColor(isFailed ? .red : .green)
            .padding()
    }
}

struct ViewLoader_Previews: PreviewProvider {
    static var previews: some View {
        ViewLoader(isFailed: .constant(false))
    }
}
