//
//  AlertToastPackageDemo.swift
//  SwiftUI_Tutorial
//
//  Created by HauNguyen on 20/06/2022.
//

import SwiftUI
import AlertToast

struct DemoAlertToast: View{

    @State private var simpleTextAlert = false
    @State private var errorTextAlert = false
    @State private var systemImageTextAlert = false
    @State private var imageAlert = false
    @State private var loadingAlert = false

    var body: some View{
        VStack(spacing: 20) {
            
            Button(action: {
                self.simpleTextAlert = true
            }) {
                self.text(string: "Simple text alert")
            }
            
            Button(action: {
                self.errorTextAlert = true
            }) {
                self.text(string: "Error alert")
            }
            
            Button(action: {
                self.systemImageTextAlert = true
            }) {
                self.text(string: "System Image Text Alert")
            }
            
            Button(action: {
                self.imageAlert = true
            }) {
                self.text(string: "Image Alert")
            }
            
            Button(action: {
                self.loadingAlert = true
            }) {
                self.text(string: "Loading Alert")
            }
        }
        .toast(isPresenting: $simpleTextAlert) {
            // Simple text alert
            AlertToast(displayMode: .alert, type: .regular, title: "Simple text", subTitle: "Sub title", style: .style(backgroundColor: Color.yellow, titleColor: .blue, subTitleColor: .cyan, titleFont: .title2, subTitleFont: .title3))
        }
        .toast(isPresenting: $errorTextAlert) {
            AlertToast(displayMode: .alert, type: .error(.red))
        }
        .toast(isPresenting: $systemImageTextAlert) {
            AlertToast(displayMode: .alert, type: .systemImage("paperplane.fill", .blue))
        }
        .toast(isPresenting: $imageAlert) {
            AlertToast(displayMode: .alert, type: .image("photo2", .blue))
        }
        .toast(isPresenting: $loadingAlert) {
            AlertToast(displayMode: .alert, type: .loading)
        }
    }
    
    func text(string: String) -> Text {
        let this = Text(string)
            .font(.title2)
            .foregroundColor(Color.blue)
            .fontWeight(.bold)
        
        return this
    }
}


struct DemoAlertToast_Previews: PreviewProvider {
    static var previews: some View {
        DemoAlertToast()
    }
}
