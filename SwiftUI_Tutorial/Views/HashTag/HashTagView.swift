//
//  HashTagView.swift
//  SwiftUI_Tutorial
//
//  Created by HauNguyen on 25/05/2022.
//

import SwiftUI

struct HashTagView: View {
    @State private var sheet: TermsOrPrivacySheet? = nil
    let string = "By signing up, you agree to XXXX's Terms & Conditions and Privacy Policy"
    
    
    enum TermsOrPrivacySheet: Identifiable {
        case terms, privacy
        
        var id: Int {
            hashValue
        }
    }
    
    
    func showSheet(_ string: String) {
        if ["Terms", "&", "Conditions"].contains(string) {
            sheet = .terms
        }
        else if ["Privacy", "Policy"].contains(string) {
            sheet = .privacy
        }
    }
    
    
    func fontWeight(_ string: String) -> Font.Weight {
        ["Terms", "&", "Conditions", "Privacy", "Policy"].contains(string) ? .medium : .light
    }
    
    
    private func createText(maxWidth: CGFloat) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        let stringArray = string.components(separatedBy: " ")
        
        
        return ZStack(alignment: .topLeading) {
            ForEach(stringArray, id: \.self) { string in
                Text(string + " ")
                    .font(.title)
                    .fontWeight(fontWeight(string))
                    .onTapGesture { showSheet(string) }
                    .alignmentGuide(.leading, computeValue: { dimension in
                        if (abs(width - dimension.width) > maxWidth) {
                            width = 0
                            height -= dimension.height
                        }
                        
                        let result = width
                        if string == stringArray.last {
                            width = 0
                        }
                        else {
                            width -= dimension.width
                        }
                        
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { dimension in
                        let result = height
                        if string == stringArray.last { height = 0 }
                        return result
                    })
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                createText(maxWidth: geo.size.width)
            }
        }
        .frame(maxWidth: .infinity)
        .sheet(item: $sheet) { item in
            switch item {
            case .terms:
                Text("Terms and Conditions")
                    .font(.title)
                    .foregroundColor(Color.primary)
            case .privacy:
                Text("Privacy and Policy")
                    .font(.title)
                    .foregroundColor(Color.primary)
            }
        }
    }
}

struct HashTagView_Previews: PreviewProvider {
    static var previews: some View {
        HashTagView()
    }
}
