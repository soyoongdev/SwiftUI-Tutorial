//
//  ContentView.swift
//  SwiftUI_Tutorial
//
//  Created by Hau Nguyen on 15/12/2021.
//

import SwiftUI

struct ContentView: View {

    var body : some View {
        ZoomableImageViewOriginal(pathUrl: .constant("https://images.indianexpress.com/2022/06/Apple-WWDC-20221.jpg"))
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
