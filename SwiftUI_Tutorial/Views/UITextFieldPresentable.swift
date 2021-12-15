//
//  UITextFieldPresentable.swift
//  SwiftUI_Tutorial
//
//  Created by Hau Nguyen on 15/12/2021.
//

import UIKit
import SwiftUI

struct UITextFieldPresentable: UIViewRepresentable {
    
    init(text: Binding<String>) {
        self._text = text
    }
    
    @Binding var text: String
    
    // Convert from SwiftUI to UIKit
    func makeUIView(context: Context) -> UITextField {
        let textField = getTextField()
        textField.delegate = context.coordinator
        
        return textField
    }
    
    // Update value from UIKit to SwiftUI
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    
    func getTextField() -> UITextField {
        let textField = UITextField(frame: .zero)
        let placeHolder = NSAttributedString(string: "Type here..", attributes: [
            .foregroundColor : UIColor.red
        ])
        textField.attributedPlaceholder = placeHolder
        
        return textField
        
    }
    
    
    // Convert from UIKit to SwiftUI
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    // Convert from UIKit to SwiftUI
    class Coordinator: NSObject, UITextFieldDelegate {
        init (text: Binding<String>) {
            self._text = text
        }
        
        @Binding var text: String
        
        // Update change value from UIKit (UITextField) to SwiftUI
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
        
    }
}
