//
//  ImageUIView.swift
//  SwiftUI_Tutorial
//
//  Created by HauNguyen on 03/06/2022.
//

import SwiftUI
import UIKit

struct ImageUIView: UIViewControllerRepresentable {
    @State private var images = IFImage.mock

    func makeUIViewController(context: Context) -> IFBrowserViewController {
        let viewController = IFBrowserViewController(images: self.images)
        viewController.navigationController?.pushViewController(context.coordinator.browserViewController, animated: true)
        return viewController
    }
    
    func updateUIViewController(_ viewController: IFBrowserViewController, context: Context) {
        viewController.delegate = context.coordinator
    }
    
    // MARK: - ViewController
    func makeCoordinator() -> Coordinator {
        Coordinator(images: $images)
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, IFBrowserViewControllerDelegate {
        init(images: Binding<[IFImage]>) {
            self._images = images
        }
        @Binding var images: [IFImage]
                
        var browserViewController: IFBrowserViewController {
            let viewController = IFBrowserViewController(images: self.images, initialImageIndex: .random(in: self.images.indices))
            
            viewController.configuration.actions = [.share, .delete]
            viewController.delegate = self

            return viewController
        }
    }
}
