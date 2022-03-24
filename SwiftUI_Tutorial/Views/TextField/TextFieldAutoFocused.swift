//
//  TextFieldAutoFocused.swift
//  SwiftUI_Tutorial
//
//  Created by Hau Nguyen on 11/03/2022.
//

import SwiftUI

struct TextFieldAutoFocused: UIViewRepresentable {
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        @Binding var nextResponder : Bool?
        @Binding var isResponder : Bool?
        
        init(text: Binding<String>,nextResponder : Binding<Bool?> , isResponder : Binding<Bool?>) {
            self._text = text
            self._isResponder = isResponder
            self._nextResponder = nextResponder
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.isResponder = true
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.isResponder = false
                if self.nextResponder != nil {
                    self.nextResponder = true
                }
            }
        }
    }
    
    @Binding var text: String
    @Binding var nextResponder : Bool?
    @Binding var isResponder : Bool?
    
    var isSecured : Bool = false
    var keyboard : UIKeyboardType
    
    func makeUIView(context: UIViewRepresentableContext<TextFieldAutoFocused>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.isSecureTextEntry = isSecured
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = keyboard
        textField.frame = UIScreen.main.bounds
        textField.delegate = context.coordinator
        return textField
    }
    
    func makeCoordinator() -> TextFieldAutoFocused.Coordinator {
        return Coordinator(text: $text, nextResponder: $nextResponder, isResponder: $isResponder)
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<TextFieldAutoFocused>) {
        uiView.text = text
        if isResponder ?? false {
            uiView.becomeFirstResponder()
        }
    }
    
}
