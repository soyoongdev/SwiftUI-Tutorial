//
//  CustomCorner.swift
//  Swiftui Tutorials
//
//  Created by Hau Nguyen on 09/09/2021.
//

import SwiftUI

struct CustomCorner: Shape {
    var corner: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}
