//
//  AlertToastPackageDemo.swift
//  SwiftUI_Tutorial
//
//  Created by HauNguyen on 20/06/2022.
//

import SwiftUI
import AlertToast

struct AlertToastPackageDemo: View {
    @State private var showToast = false
    
    var body: some View {
        VStack{
            
            Button(action: {
                self.showToast = true
            }){
                Text("Show alert")
            }
        }
        .toast(isPresenting: $showToast){
            
            // `.alert` is the default displayMode
            
            //Choose .hud to toast alert from the top of the screen
            AlertToast(displayMode: .alert, type: .regular, title: "Message Sent!")
        }
    }
}

struct AlertToastPackageDemo_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.yellow.ignoresSafeArea()
            
            AlertToastPackageDemo()
            
        }
    }
}
