//
//  BlurView.swift
//  ThietThachClient
//
//  Created by HauNguyen on 08/06/2022.
//

import SwiftUI

extension View {
    func blurView(style: UIBlurEffect.Style = .systemMaterialDark) -> some View {
        return self.background(BlurView())
    }
}

@available(iOS 13, *)
public struct BlurView: UIViewRepresentable {
    public typealias UIViewType = UIVisualEffectView
    
    public func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: .systemMaterial)
    }
}

struct BlurView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            
            BlurView()
                .frame(width: 300, height: 300)
            Text("Hey there, I'm on top of the blur")
            
        }
    }
}
