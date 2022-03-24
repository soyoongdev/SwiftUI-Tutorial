//
//  ContentView.swift
//  SwiftUI_Tutorial
//
//  Created by Hau Nguyen on 15/12/2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modalManager: ModalManager
    @State private var username =  ""
    @State private var password =  ""
    
    // set true , if you want to focus it initially, and set false if you want to focus it by tapping on it.
    @State private var isUsernameFirstResponder : Bool? = true
    @State private var isPasswordFirstResponder : Bool? =  false
    
    
    var body : some View {
        VStack(alignment: .center) {
            
            Button {
                
                withAnimation {
                    if isUsernameFirstResponder! { // true
                        self.isUsernameFirstResponder = false
                    } else {
                        self.isUsernameFirstResponder = true
                    }
                    
                    if isPasswordFirstResponder! {
                        self.isPasswordFirstResponder = false
                    } else {
                        self.isPasswordFirstResponder = true
                    }
                }
                
            } label: {
                Text("Next")
            }
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray)
                    .frame(width: 46, height: 46)
                    .zIndex(0)
                
                TextFieldAutoFocused(text: $username,
                                     nextResponder: $isPasswordFirstResponder,
                                     isResponder: $isUsernameFirstResponder,
                                     isSecured: false,
                                     keyboard: .default)
                    .frame(width: 0, height: 02)
                    .zIndex(1)
            }
            
            // assigning the next responder to nil , as this will be last textfield on the view.
            TextFieldAutoFocused(text: $password,
                                 nextResponder: .constant(nil),
                                 isResponder: $isPasswordFirstResponder,
                                 isSecured: true,
                                 keyboard: .default)
        }
        .padding(.horizontal, 50)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
