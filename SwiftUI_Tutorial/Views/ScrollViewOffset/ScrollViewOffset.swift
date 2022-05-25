//
//  ScrollViewOffset.swift
//  MaytechFramework
//
//  Created by Hau Nguyen on 06/09/2021.
//

import SwiftUI

public struct ScrollViewOffset<Content: View>: View {
    public init(footerOffset: Binding<CGFloat> = .constant(0), onRefresh: @escaping () -> (), @ViewBuilder content: () -> Content) {
        self.content = content()
        self.onRefresh = onRefresh
        self._footerOffset = footerOffset
        self.content = content()
        UIScrollView.appearance().bounces = true
    }
    
    @Binding private var footerOffset: CGFloat
    private var onRefresh: () -> ()
    private var content: Content
    private var showsIndicators: Bool = false
    private var axis: Axis.Set = .vertical
    @State private var isLoading: Int = 0
    @State private var startOffset: CGFloat = 0
    @State private var offset: CGFloat = 0
    @State private var topScrollOffset: CGFloat = 0
    @State private var bottomScrollOffset: CGFloat = 0
    @State private var started: Bool = false
    @State private var calculator: CGFloat = 0
    @State private var maxOffset: CGFloat = 0
    
    // Hidden Header when scroll up with offset >= 0 => 0...(.infinity)
    // Show Header when scroll down with offset >= -25 =>
    
    public var body: some View {
        ScrollView(axis, showsIndicators: showsIndicators, content: {

            ZStack(alignment:.top) {
//                Color.LGHeader
                
                if isLoading > 0 {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
//                        .offset(y: (UIScreen.edges?.top ?? 0) + 10)
                        .zIndex(10)
                        .scaleEffect(1.2)
                        
                } else {
                    Image(systemName: "arrow.down")
//                        .font(.custom(TextDictionary.RobotoBold, size: 16))
                        .foregroundColor(.white)
                        .rotationEffect(.init(degrees: started ? 180 : 0))
                        .offset(y: -25)
                        .animation(.easeIn)
                        .zIndex(10)
                }
                
                
                content.overlay(
                    GeometryReader { proxy -> Color in
                        let minY = proxy.frame(in: .global).minY
                        
                        DispatchQueue.main.async {
                            if self.startOffset == 0 {
                                self.topScrollOffset = self.offset
                                self.startOffset = minY
                            }
                            
                            let offset_ = self.startOffset - minY
                            
                            
                            // Use for stationary header
                            //                            let a = minY - offset_
                            //                            let b = minY - offset
                            //                            // Updating new..
                            //                            if (a > b) && (a > 700) && !started {
                            //                                withAnimation {
                            //                                    self.isUpdating = false
                            //                                    self.started = true
                            //                                }
                            //                            }
                            //                            if (a < b) && started && !isUpdating {
                            //                                withAnimation {
                            //                                    self.isUpdating = true
                            //                                    self.started = false
                            //                                }
                            //                            }
                            
                            // Use for movable header
                            let a = startOffset - offset
//                            let b = (100 + (UIScreen.edges?.top ?? 0))
//                            if (a > b) && !started {
//                                self.isLoading = 0
//                                self.started = true
//                            }
//                            if (a < b) && started && isLoading == 0 {
//                                withAnimation(.linear) {
//                                    self.isLoading = 0
//                                    self.started = false
//                                }
//                            }
                            
                            // print("startOffset: \(startOffset) and minY \(minY) and offset: \(offset) and offset_: \(offset_) \n")
                            
                            if offset_ > self.offset {
                                
                                self.bottomScrollOffset = 0
                                
                                if topScrollOffset == 0 {
                                    self.topScrollOffset = offset_
                                }
                                
                                let progress = (self.topScrollOffset + getMaxOffset()) - offset_
                                
                                let offsetCondition = (topScrollOffset + getMaxOffset()) >= getMaxOffset() && getMaxOffset() - progress <= getMaxOffset()
                                
                                let footerOffset_ = offsetCondition ? -(getMaxOffset() - progress) : -getMaxOffset()
                                
                                // from 0 - 500
                                withAnimation {
                                    if minY < 0 {
                                        self.footerOffset = footerOffset_ - 100
                                    }
                                }
                            }
                            
                            if offset_ < self.offset {
                                
                                self.topScrollOffset = 0
                                
                                if self.bottomScrollOffset == 0 {
                                    self.bottomScrollOffset = offset_
                                }
                                
                                withAnimation(.easeOut(duration: 0.25)) {
                                    let footerOffset_ = self.footerOffset
                                    
                                    self.footerOffset = (self.bottomScrollOffset > (offset_ + 40)) ? 0 : (footerOffset_ != -getMaxOffset() ? 0 : footerOffset_)
                                    
                                }
                            }
                            
                            self.offset = offset_
                        }
                        
                        return Color.clear
                    }
                        .frame(height: 0), alignment: .top
                )
                    
            }
//            .onChange(of: isUpdating) { newValue in
//                if newValue {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        withAnimation(.linear) {
//                            onRefresh()
//                            self.isUpdating = false
//                        }
//                    }
//                }
//            }
        })
    }
    
    func getMaxOffset() -> CGFloat {
        return startOffset + (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + 10
    }
}
