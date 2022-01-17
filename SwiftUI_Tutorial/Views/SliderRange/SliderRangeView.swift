//
//  SliderRangeView.swift
//  SwiftUI_Tutorial
//
//  Created by Hau Nguyen on 10/01/2022.
//

import SwiftUI

var sliderW = CGFloat(UIScreen.main.bounds.width - 0)

struct SliderRangeView: View {
    @State var minValue: CGFloat = 0
    @State var maxValue: CGFloat = sliderWidth
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            let total =  ((maxValue / sliderWidth) * 100) - ((minValue / sliderWidth) * 100)
            
            Text("Range Slider value: \(getValue(value: total))")
            let min = (minValue / sliderWidth) * 100
            let max = (maxValue / sliderWidth) * 100
            HStack {
                Text("Min: \(min)")
                
                Spacer()
                
                Text("Max: \(max)")
            }
            
            RRRangeSliderSwiftUI2(
                minValue: self.$minValue, // mimimum value
                maxValue: self.$maxValue, // maximum value
                sliderWidth: sliderWidth // set slider width
            )
        }
    }
    
    func getValue(value: CGFloat) -> String {
        return String(format: "%.0f", value)
    }
}

public struct RRRangeSliderSwiftUI2: View {
    /// ` Slider` Binding min & max values
    @Binding var minValue: CGFloat
    @Binding var maxValue: CGFloat
    
    /// Set slider width
    let sliderWidth: CGFloat
    
    /// `Slider` init
    public init(minValue: Binding<CGFloat>,
               maxValue: Binding<CGFloat>,
               sliderWidth: CGFloat = 0) {
        self._minValue = minValue
        self._maxValue = maxValue
        self.sliderWidth = sliderWidth
    }
    
    /// `Slider` view setup
    public var body: some View {
        
        VStack {
            
            /// `Slider` track view with glob view
            ZStack (alignment: Alignment(horizontal: .leading, vertical: .center), content: {
                // background track view
                Capsule()
                    .fill(Color.gray)
                    .frame(width: CGFloat(self.sliderWidth), height: 2)
                
                // selected track view
                Capsule()
                    .fill(Color.blue)
                    .offset(x: CGFloat(self.minValue))
                    .frame(width: CGFloat((self.maxValue) - self.minValue), height: 2)
                
                // minimum value glob view
                sliderButton
                    .offset(x: CGFloat(self.minValue))
                    .gesture(DragGesture().onChanged({ (value) in
                        /// drag validation
                        if value.location.x > 0 && value.location.x <= self.sliderWidth &&
                            value.location.x < CGFloat(self.maxValue) {
                            // set min value of slider
                            self.minValue = CGFloat(value.location.x)
                        }
                    }))
                      
                // maximum value glob view
                sliderButton
                    .offset(x: CGFloat(self.maxValue - 16))
                    .gesture(
                        DragGesture()
                            .onChanged({ (value) in
                                /// drag validation
                                if value.location.x <= self.sliderWidth &&
                                    value.location.x > CGFloat(self.minValue) {
                                    // set max value of slider
                                    self.maxValue = CGFloat(value.location.x)
                                }
                            })
                    )
            })
            .padding()
        }
    }
    
    var sliderButton: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 16, height: 16)
                .shadow(color: Color.white.opacity(0.8), radius: 4, x: -4, y: -4)
                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 4, y: 4)
                .zIndex(0)
            
            Circle()
                .fill(Color.blue)
                .frame(width: 10, height: 10)
                .zIndex(1)
        }
    }
}

struct SliderRangeView_Previews: PreviewProvider {
    static var previews: some View {
        SliderRangeView()
    }
}
