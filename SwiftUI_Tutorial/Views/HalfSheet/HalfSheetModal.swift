//
//  HalfSheet.swift
//  ThietThachClient
//
//  Created by Hau Nguyen on 14/12/2021.
//

import UIKit
import SwiftUI

extension View {
    func halfSheetModal<Content : View> (isPresented: Binding<Bool>, @ViewBuilder content : @escaping () -> Content, onEnd: @escaping () -> Void) -> some View {
        // Why we use overlay...
        // Because it will automatically use the swiftui frame size only..
        return self.background(HalfSheetModal(isPresented: isPresented, content: content, onEnd: onEnd))
    }
}

struct HalfSheetModal<Content: View>: UIViewControllerRepresentable {
    let content: Content
    @Binding var isPresented: Bool
    private let controller = UIViewController()
    var onEnd: () -> Void
    
    init(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content, onEnd: @escaping () -> Void) {
        self._isPresented = isPresented
        self.content = content()
        self.onEnd = onEnd
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        controller.view.backgroundColor = .clear
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            // Presenting Modal View..
            let sheetController = CustomHostingController(rootView: content)
            sheetController.presentationController?.delegate = context.coordinator
            
            uiViewController.present(sheetController, animated: true)
        } else {
            uiViewController.dismiss(animated: true)
        }
    }
    
    class CustomHostingController<Content : View> : UIHostingController<Content> {
        
        override func viewDidLoad() {
            //view.backgroundColor = .clear
            // Setting presentation controller properties...
            if let presentationController = presentationController as? UISheetPresentationController {
                presentationController.detents = [
                    .medium(), .large()
                ]
                
                // To show grab protion..
                presentationController.prefersGrabberVisible = true
            }
        }
    }
    
    // MARK : Coordinator
    class Coordinator : NSObject, UISheetPresentationControllerDelegate {
        init(parent: HalfSheetModal<Content>) {
            self.parent = parent
        }
        
        var parent : HalfSheetModal
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            self.parent.isPresented = false
            self.parent.onEnd()
        }
        
    }
}


struct DemoSheet: View {
    @State var isPresented: Bool = false
    
    var body: some View {
        ZStack {
            
            Button(action: {
                self.isPresented.toggle()
            }) {
                Text("Click me!")
            }
            
        }
        .halfSheetModal(isPresented: $isPresented) {
            Button(action: {
                self.isPresented.toggle()
            }) {
                Text("Dismiss")
            }
        } onEnd: {
            print("Disissed")
        }
    }
}

struct CustomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        DemoSheet()
    }
}
