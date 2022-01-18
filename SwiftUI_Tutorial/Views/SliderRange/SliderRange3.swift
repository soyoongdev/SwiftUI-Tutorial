//
//  SliderRange3.swift
//  SwiftUI_Tutorial
//
//  Created by Hau Nguyen on 10/01/2022.
//

import SwiftUI

struct SliderRange3: View {
    private let length: CGFloat = 10
    @State var offsetX: CGFloat = 0
    
    var body: some View {
        GeometryReader{ proxy in
            
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray)
                    .frame(height: length)
                
                sliderButton
            }
            
        }
        
    }
    
    var sliderButton: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 26, height: 26)
                .shadow(color: Color.white.opacity(0.8), radius: 4, x: -4, y: -4)
                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 4, y: 4)
                .zIndex(0)
            
            Circle()
                .fill(Color.blue)
                .frame(width: 20, height: 20)
                .zIndex(1)
        }
        .offset(x: offsetX)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged({ value in
                    let a = value.location.x
                    if a >= 0 {
                        offsetX = a
                    }
                })
        )
    }
}

struct SliderRange3_Previews: PreviewProvider {
    static var previews: some View {
        SliderRange3()
    }
}
