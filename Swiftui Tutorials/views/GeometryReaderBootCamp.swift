//
//  GeometryReaderBootCamp.swift
//  Swiftui Tutorials
//
//  Created by Hau Nguyen on 21/08/2021.
//

import SwiftUI

struct GeometryReaderBootCamp: View {
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(0..<10) {index in
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 20)
                            .rotation3DEffect(
                                Angle(degrees: getPercentage(geo: geometry) * 40),
                                axis: (x: 0.0, y: 1.0, z: 0.0)
                            )
                    }
                    .frame(width: 300, height: 250)
                    padding()
                }
            }
        }
    }
    func getPercentage(geo: GeometryProxy) -> Double {
        let maxDistance = UIScreen.main.bounds.width / 2
        let currentX = geo.frame(in: .global).midX
        
        return Double(1 - (currentX / maxDistance))
    }
}

struct GeometryReaderBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReaderBootCamp()
    }
}
