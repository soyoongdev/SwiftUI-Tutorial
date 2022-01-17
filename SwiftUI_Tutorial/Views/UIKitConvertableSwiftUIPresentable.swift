//
//  UIKitConvertableSwiftUIPresentable.swift
//  SwiftUI_Tutorial
//
//  Created by Hau Nguyen on 15/12/2021.
//

import SwiftUI

struct UIKitConvertableSwiftUIPresentable: View {
    @State var text: String = ""
    
    var body: some View {   
        
        VStack {
            Text(text == "" ? "Hello" : text)
                .font(.title)
            
            HStack {
                Text("SwiftUI:")
                TextField("Type here...", text: $text)
                    .frame(height: 48)
                    .padding(.horizontal, 10)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            
            HStack {
                Text("UIKit:")
                UITextFieldPresentable(text: $text)
                    .frame(height: 48)
                    .padding(.horizontal, 10)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
        }
        
    }
}

struct UIKitConvertableSwiftUIPresentable_Previews: PreviewProvider {
    static var previews: some View {
        UIKitConvertableSwiftUIPresentable()
    }
}
