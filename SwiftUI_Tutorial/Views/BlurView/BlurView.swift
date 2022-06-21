//
//  BlurView.swift
//  ThietThachClient
//
//  Created by HauNguyen on 08/06/2022.
//

import SwiftUI

extension View {
    func blurView(style: UIBlurEffect.Style = .systemMaterialDark) -> some View {
        return self.background(BlurView(style: style))
    }
}

struct BlurView: UIViewRepresentable {
    
    let style: UIBlurEffect.Style
    
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: self.style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<BlurView>) {
        
    }

}

struct BlurView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            
            BlurView(style: .regular)
                .frame(width: 300, height: 300)
            Text("Hey there, I'm on top of the blur")
            
        }
    }
}
