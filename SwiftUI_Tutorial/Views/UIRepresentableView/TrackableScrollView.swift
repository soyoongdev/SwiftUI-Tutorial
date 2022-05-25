//
//  TrackableScrollView.swift
//  SwiftUI_Tutorial
//
//  Created by Hau Nguyen on 22/03/2022.
//

import SwiftUI
import SwiftUITrackableScrollView

struct TrackableScrollView2: View {
    @State private var scrollViewContentOffset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(Color.white)
                .frame(height: 100)
                .overlay(
                    Text("\(scrollViewContentOffset)")
                )
                .zIndex(1)
            
            TrackableScrollView(.vertical, showIndicators: false, contentOffset: $scrollViewContentOffset) {
                VStack {
                    ForEach(0..<100, id: \.self) { i in
                        Text("\(i)")
                            .padding()
                            .frame(width: 100, alignment: .leading)
                    }
                }
            }
        }
    }
}

struct TrackableScrollView2_Previews: PreviewProvider {
    static var previews: some View {
        TrackableScrollView2()
    }
}
