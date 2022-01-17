//
//  ContentView.swift
//  SwiftUI_Tutorial
//
//  Created by Hau Nguyen on 15/12/2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modalManager: ModalManager
    var body: some View {
        ZStack {
//            PinchImageView {
//                AsyncImageView(url: .constant(URL(string: "https://developer.apple.com/swift/images/swift-og.png")!))
//                    .aspectRatio(contentMode: .fit)
//            }
//            SliderRangeView()
            ScrollViewOffsetNewPreview()
            
        }
//        VStack {
//            ImageViewPresentable()
//                .frame(height: UIScreen.main.bounds.height)
//                Spacer()
//        }
//        .ignoresSafeArea()
        
//        StatefulPreviewWrapper("") {
//            PinEntryView(pinCode: $0)
//        }
//        DisplayViewFresh()
        
        
//        RefreshableScrollView {
//            ZStack(alignment: .top) {
//                DemoRefreshable()
//                    .zIndex(10)
//
//                VStack(alignment: .leading) {
//                    ForEach(0..<20, id: \.self) { item in
//                        Text("Item number: \(item)")
//                    }
//                }
//                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
//                .zIndex(1)
//            }
//        }
        
        
//        SectionedTextField()
        
//        StatefulPreviewWrapper("12") {
//            PinEntryView(pinLimit: 6, pinCode: $0)
//        }
//        .background(Color.black)
//        .colorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
