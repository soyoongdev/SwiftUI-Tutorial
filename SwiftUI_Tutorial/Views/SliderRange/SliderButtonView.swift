//
//  SliderButtonView.swift
//  SwiftUI_Tutorial
//
//  Created by Hau Nguyen on 10/01/2022.
//

import SwiftUI

struct SliderButtonView: View {
    init(sliderWidth: Binding<CGFloat>)
    {
        self._sliderWidth = sliderWidth
    }
    @Binding private var sliderWidth: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 16, height: 16)
                .offset(x: self.sliderWidth)
                .zIndex(0)
                .shadow(color: Color.white.opacity(0.8), radius: 4, x: -2, y: -2)
                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 2, y: 2)
            
            
            Circle()
                .fill(Color.blue)
                .frame(width: 10, height: 10)
                .offset(x: self.sliderWidth)
                .zIndex(1)
        }
    }
}

struct SliderButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SliderRangeView()
    }
}
