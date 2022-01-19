//
//  SliderRange.swift
//  ThietThachClient
//
//  Created by Hau Nguyen on 10/01/2022.
//

import SwiftUI

struct SliderRange_Previews: PreviewProvider {
    static var previews: some View {
        //        SliderRange()
        UseLockerSlider()
    }
}

struct LockerSlider<V>: View where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
    
    // MARK: - Value
    // MARK: Private
    @Binding private var value: V
    private let bounds: ClosedRange<V>
    private let step: V.Stride
    
    private let length: CGFloat = 50
    private let lineWidth: CGFloat = 2
    
    @State private var ratio: CGFloat = 0
    @State private var startX: CGFloat? = nil
    @State private var remainder: CGFloat = 0
    @State private var point: CGFloat = 0
    @State private var delta: CGFloat = 0
    @State private var unit: CGFloat = 0
    @State private var a: CGFloat = 0
    @State private var b: CGFloat = 0
    @State private var c: CGFloat = 0
    @State private var d: CGFloat = 0
    
    // MARK: - Initializer
    init(value: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1) {
        _value  = value
        self.bounds = bounds
        self.step = step
    }
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        GeometryReader { proxy in
            
            VStack {
                VStack(alignment: .center, spacing: 0) {
                    
                    // Thumb Min
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: length / 2)
                            .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                        
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: length, height: length)
                            .offset(x: ((proxy.size.width - length) * ratio))
                            .gesture(DragGesture(minimumDistance: 0)
                                        .onChanged({ updateStatus(value: $0, proxy: proxy) })
                                        .onEnded { _ in startX = nil })
                            .overlay(
                                ZStack {
                                    Text("\(String(format: "%.2f", (proxy.size.width - length) * ratio))")
                                        .font(.system(size: 10))
                                }
                                    .offset(x: ((proxy.size.width - length) * ratio))
                            )
                    }
                    
                }
                .frame(height: length)
                .overlay(overlay)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ update(value: $0, proxy: proxy) })
                )
                .onAppear {
                    ratio = min(1, max(0,CGFloat(value / bounds.upperBound)))
                }
                
                VStack(alignment: .leading) {
                    Group {
                        Text("ratio: \(ratio)")
                        Text("startX: \(startX ?? 0)")
                        Text("remainder: \(remainder)")
                        Text("point: \(point)")
                        Text("delta: \(delta)")
                        Text("unit: \(unit)")
                        Text("value.location.x: \(a)")
                        Text("x: \(b)")
                        Text("ratio - CGFloat(remainder): \(c)")
                        Text("ratio_: \(d)")
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
            }
        }
    }
    
    // MARK: Private
    private var overlay: some View {
        RoundedRectangle(cornerRadius: (length + lineWidth) / 2)
            .stroke(Color.gray, lineWidth: lineWidth)
            .frame(height: length + lineWidth)
    }
    
    
    // MARK: - Function
    // MARK: Private
    private func updateStatus(value: DragGesture.Value, proxy: GeometryProxy) {
        DispatchQueue.main.async {
            guard startX == nil else { return }
            
            delta = value.startLocation.x - (proxy.size.width - length) * ratio
            startX = (length < value.startLocation.x && 0 < delta) ? delta : value.startLocation.x
        }
        
    }
    
    private func update(value: DragGesture.Value, proxy: GeometryProxy) {
        DispatchQueue.main.async {
            guard let x = startX else { return }
            startX = min(length, max(0, x))
                    
            point = value.location.x - x
            
            a = value.location.x
            b = x
            
            delta = proxy.size.width - length
            
            // Check the boundary
            if point < 0 {
                startX = value.location.x
                point = 0
                
            } else if delta < point {
                startX = value.location.x - delta
                point = delta
            }
            
            // Ratio
            var ratio = point / delta
            d = ratio
            
            // Step
            if step > 0 {
                unit = CGFloat(step) / CGFloat(bounds.upperBound)
                
                remainder = ratio.remainder(dividingBy: unit)
                if remainder != 0 {
                    ratio = ratio - CGFloat(remainder)
                    c = ratio - CGFloat(remainder)
                }
            }
            
            self.ratio = ratio
            self.value = V(bounds.upperBound) * V(ratio)
        }
    }
}



struct UseLockerSlider: View {
    @State var value = 0.0
    var list: [Int] = [0, 1, 2, 3, 4]
    
    var body: some View {
        VStack(spacing: 40) {
            
            Text("Value: \(value)")
            
            LockerSlider(value: $value, in: 0...Double(list.count - 1), step: 1)
            
        }
    }
}
