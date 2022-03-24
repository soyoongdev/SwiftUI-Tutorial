//
//  UITextFieldFocused.swift
//  ThietThachClient
//
//  Created by Hau Nguyen on 13/03/2022.
//

import SwiftUI
import UIKit

struct UITextFieldFocused: UIViewRepresentable {
    @Binding var text: String
    @Binding var nextResponder : Bool?
    @Binding var lastResponder : Bool?
    @Binding var isResponder : Bool?
    @Binding var isError: Bool
    
    init(text: Binding<String>, isResponder : Binding<Bool?>, nextResponder : Binding<Bool?>, lastResponder : Binding<Bool?>, isError: Binding<Bool>) {
        self._text = text
        self._isResponder = isResponder
        self._nextResponder = nextResponder
        self._lastResponder = lastResponder
        self._isError = isError
    }
    
    func makeUIView(context: UIViewRepresentableContext<UITextFieldFocused>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.isSecureTextEntry = false
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .numberPad
        textField.textAlignment = NSTextAlignment.center
        textField.delegate = context.coordinator
        return textField
    }
    
    func makeCoordinator() -> UITextFieldFocused.Coordinator {
        return Coordinator(text: self.$text, isResponder: self.$isResponder, nextResponder: self.$nextResponder, lastResponder: self.$lastResponder, isError: $isError)
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<UITextFieldFocused>) {
        uiView.text = text
        if self.isError {
            uiView.textColor = UIColor(Color.red)
        } else {
            uiView.textColor = UIColor(Color.blue)
        }
        if self.isResponder ?? false {
            uiView.becomeFirstResponder()
        }
    }
    
    // Coordinator
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        @Binding var nextResponder : Bool?
        @Binding var lastResponder : Bool?
        @Binding var isResponder : Bool?
        @Binding var isError: Bool
        
        init(text: Binding<String>, isResponder : Binding<Bool?>, nextResponder : Binding<Bool?>, lastResponder : Binding<Bool?>, isError: Binding<Bool>) {
            self._text = text
            self._isResponder = isResponder
            self._nextResponder = nextResponder
            self._lastResponder = lastResponder
            self._isError = isError
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            // Update
            DispatchQueue.main.async {
                self.text = textField.text ?? ""
                self.isResponder = false
                if self.text.count == 1 {
                    if self.nextResponder != nil {
                        self.nextResponder = true
                    } else {
                        UIApplication.shared.endEditing()
                    }
                } else {
                    self.lastResponder = true
                }
                
            }
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.isResponder = true
            }
        }
        
        private func textLimit(existingText: String?, newText: String, limit: Int) -> Bool {
            let text = existingText ?? ""
            let isAtLimit = text.count + newText.count <= limit
            return isAtLimit
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            let isLimitCharacter = self.textLimit(existingText: textField.text, newText: string, limit: 1)
            let isOnlyNumber = string == numberFiltered
            return isLimitCharacter && isOnlyNumber
        }
    }
}

public extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//
//  OTPInputView.swift
//  ThietThachClient
//
//  Created by Hau Nguyen on 12/03/2022.
//

enum OTPInputType {
    case LOGIN
    case PROFILE
}

struct OTPInputView: View {
    
    init(otpCode: Binding<String>, isError: Binding<Bool>, inputType: OTPInputType) {
        self._otpCode = otpCode
        self._isError = isError
        self.inputType = inputType
    }
    var inputType: OTPInputType
    @Binding var otpCode: String
    @Binding var isError: Bool
    // Text input
    @State var input1: String = ""
    @State var input2: String = ""
    @State var input3: String = ""
    @State var input4: String = ""
    @State var input5: String = ""
    @State var input6: String = ""
    
    // Responder
    @State var isInput1Responder: Bool? = true
    @State var isInput2Responder: Bool? = false
    @State var isInput3Responder: Bool? = false
    @State var isInput4Responder: Bool? = false
    @State var isInput5Responder: Bool? = false
    @State var isInput6Responder: Bool? = false
    
    var body: some View {
        ZStack {
            HStack {
                ItemResponder(text: $input1,
                              isResponder: $isInput1Responder,
                              nextResponder: $isInput2Responder,
                              lastResponder: $isInput1Responder,
                              isError: $isError, inputType: inputType)
                    .onChange(of: self.input1) { _ in
                        self.updateChangeSelector()
                    }
                
                ItemResponder(text: $input2,
                              isResponder: $isInput2Responder,
                              nextResponder: $isInput3Responder,
                              lastResponder: $isInput1Responder,
                              isError: $isError, inputType: inputType)
                    .onChange(of: self.input2) { _ in
                        self.updateChangeSelector()
                    }
                
                ItemResponder(text: $input3,
                              isResponder: $isInput3Responder,
                              nextResponder: $isInput4Responder,
                              lastResponder: $isInput2Responder,
                              isError: $isError, inputType: inputType)
                    .onChange(of: self.input3) { _ in
                        self.updateChangeSelector()
                    }
                
                ItemResponder(text: $input4,
                              isResponder: $isInput4Responder,
                              nextResponder: $isInput5Responder,
                              lastResponder: $isInput3Responder,
                              isError: $isError, inputType: inputType)
                    .onChange(of: self.input4) { _ in
                        self.updateChangeSelector()
                    }
                
                ItemResponder(text: $input5,
                              isResponder: $isInput5Responder,
                              nextResponder: $isInput6Responder,
                              lastResponder: $isInput4Responder,
                              isError: $isError, inputType: inputType)
                    .onChange(of: self.input5) { _ in
                        self.updateChangeSelector()
                    }
                
                ItemResponder(text: $input6,
                              isResponder: $isInput6Responder,
                              nextResponder: .constant(nil),
                              lastResponder: $isInput5Responder,
                              isError: $isError, inputType: inputType)
                    .onChange(of: self.input6) { _ in
                        self.updateChangeSelector()
                    }
                
            }
            
        }
    }
    
    func updateChangeSelector() {
        self.otpCode = "\(self.input1)\(self.input2)\(self.input3)\(self.input4)\(self.input5)\(self.input6)"
        if self.otpCode.count != 6 && self.isError {
            self.isError = false
        }
    }
}

private struct ItemResponder: View {
    init(text: Binding<String>, isResponder : Binding<Bool?>, nextResponder : Binding<Bool?>, lastResponder : Binding<Bool?>, isError: Binding<Bool>, inputType: OTPInputType) {
        self._text = text
        self._isResponder = isResponder
        self._nextResponder = nextResponder
        self._lastResponder = lastResponder
        self._isError = isError
        self.inputType = inputType
    }
    var inputType: OTPInputType
    @Binding var text: String
    @Binding var nextResponder: Bool?
    @Binding var lastResponder: Bool?
    @Binding var isResponder: Bool?
    @Binding var isError: Bool
    
    var body: some View {
        ZStack {
            
            if inputType == .LOGIN {
                Rectangle()
                    .fill(Color.white)
                    .cornerRadius(5)
                    .frame(width: 46, height: 46, alignment: .center)
                    .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 0)
                    .zIndex(0)
            } else {
                Rectangle()
                    .fill(Color.white)
                    .cornerRadius(5)
                    .frame(width: 46, height: 46, alignment: .center)
                    .zIndex(0)
            }
            
            UITextFieldFocused(text: $text,
                               isResponder: $isResponder,
                               nextResponder: $nextResponder,
                               lastResponder: $lastResponder,
                               isError: $isError)
                .frame(width: 46, height: 46, alignment: .center)
            
            
        }
    }
}

struct InputOTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPInputView(otpCode: .constant(""), isError: .constant(false), inputType: .PROFILE)
            
    }
}
