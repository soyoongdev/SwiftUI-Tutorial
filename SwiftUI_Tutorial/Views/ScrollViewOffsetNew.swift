//
//  ScrollViewOffsetNew.swift
//  ThietThachClient
//
//  Created by HauNguyen on 29/03/2022.
//  Source: https://www.fivestars.blog/articles/scrollview-offset/
//

import SwiftUI

struct ScrollViewOffsetNew<Content: View>: View {
    let content: () -> Content
    let onOffsetChange: (CGFloat) -> Void
    
    init(
        @ViewBuilder content: @escaping () -> Content,
        onOffsetChange: @escaping (CGFloat) -> Void
    ) {
        self.content = content
        self.onOffsetChange = onOffsetChange
    }
    
    @State private var startOffset: CGFloat = 0
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            content()
                .overlay(
                    offsetReader, alignment: .bottom
                )
            
            Spacer()
        }
        .coordinateSpace(name: "frameLayer")
        .onPreferenceChange(OffsetPreferenceKey.self, perform: onOffsetChange)
    }
    
    var offsetReader: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: OffsetPreferenceKey.self,
                    value: self.getOffset(proxy)
                )
        }
        .frame(maxHeight: 0) // 👈🏻 make sure that the reader doesn't affect the content height
    }
    
    func getOffset(_ proxy: GeometryProxy) -> CGFloat {
        
        let minY = proxy.frame(in: .named("frameLayer")).minY
        
        if self.startOffset == 0 {
            DispatchQueue.main.async {
                self.startOffset = minY
            }
        }
        
        let total = self.startOffset - minY
        
        return total
    }
}

/// Contains the gap between the smallest value for the y-coordinate of
/// the frame layer and the content layer.
private struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
