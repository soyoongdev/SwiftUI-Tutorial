//
//  SliderRange4.swift
//  SwiftUI_Tutorial
//
//  Created by Hau Nguyen on 20/01/2022.
//

import SwiftUI
import SliderRangeSwiftUI

struct SliderRange4: View {
    @State var value = 0.5
    @State var range = 0.0...6.0
    @State var state = false
    
    @State var x = 0.5
    @State var y = 0.5
    
    var body: some View {
        VStack(spacing: 50) {
            Text("From: \(range.lowerBound) - to: \(range.upperBound)")
            
            HRangeSlider(range: $range, in: 0.0...10.0, step: 1,
                         track:
                            HRangeTrack(
                                range: range,
                                in: 0.0...10.0,
                                view: sliderView,
                                mask: Capsule(),
                                configuration: .defaultConfiguration)
                            .background(Color.gray.opacity(0.25))
                         ,
                         lowerThumb:
                            sliderButton
                         ,
                         upperThumb:
                            sliderButton
                         ,
                         configuration:
                                .init(
                                    options: .defaultOptions,
                                    thumbSize: CGSize(width: 0, height: 16),
                                    thumbInteractiveSize: CGSize(width: 16, height: 116)
                                )
            )
                .frame(height: 12)
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
                .frame(width: 10, height: 10)
                .zIndex(1)
        }
    }
    
    var sliderView: some View {
        Capsule()
            .foregroundColor(.red)
    }
    
    var maskView: some View {
        Capsule()
            .fill(Color.gray)
            .cornerRadius(1.5)
    }
}

struct SliderRange4_Previews: PreviewProvider {
    static var previews: some View {
        SliderRange4()
    }
}
