//
//  ImageViewPresentable.swift
//  SwiftUI_Tutorial
//
//  Created by Hau Nguyen on 15/12/2021.
//

import SwiftUI
import UIKit

struct ImageViewPresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageViewPresentable>) -> UIViewController {
        let storyboard = UIStoryboard(name: "ImageViewSB", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "ImageViewer")
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ImageViewPresentable>) {
        
    }

}
