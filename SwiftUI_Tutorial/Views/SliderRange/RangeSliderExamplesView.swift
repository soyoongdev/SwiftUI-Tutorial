//
//  RangeSliderExamplesView.swift
//  SwiftUI_Tutorial
//
//  Created by HauNguyen on 24/06/2022.
//

import SwiftUI

struct RangeSliderExamplesView: View {
    @State var range1 = Double(10)...Double(155.0)
    @State var range2 = 1250.0...1750.0
    @State var range3 = 0.1...0.9
    @State var range4 = 0.1...0.9
    
    var body: some View {
        ScrollView {
            self.textView(range: range1)
            RangeSlider(range: $range1, in: 0...155, step: 0.5) { state in
                
            }
            
            self.textView(range: range2)
            RangeSlider(range: $range2, in: 1000...2000)
                .clippedValue(false)
            
            self.textView(range: range3)
            RangeSlider(range: $range3)
                .sliderStyle(
                    GradientSliderStyle(colors: [.blue, .red])
                )
            
            self.textView(range: range4)
            RangeSlider(range: $range4)
                .clippedValue(false)
                .sliderStyle(
                    GradientSliderStyle()
                )
        }
        .padding()
    }
    
    func textView(range: ClosedRange<Double>) -> some View {
        HStack {
            Text("Range")
            Spacer()
            Text("\(range.description)")
                .foregroundColor(.secondary)
        }
    }
}

struct RangeSliderExamplesView_Previews: PreviewProvider {
    static var previews: some View {
        RangeSliderExamplesView()
    }
}
