//
//  AlertView.swift
//  ThietThachClient
//
//  Created by HauNguyen on 17/06/2022.
//

import SwiftUI

extension View {
    func alertView<Content>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        modifier(AlertViewModifier(isPresented: isPresented, swiftUIContent: content))
    }
}

struct AlertViewModifier<SwiftUIContent : View>: ViewModifier {
    
    @Binding var isPresented: Bool
    
    let swiftUIContent: () -> SwiftUIContent
    
    init(isPresented: Binding<Bool>, @ViewBuilder swiftUIContent: @escaping () -> SwiftUIContent)
    {
        self._isPresented = isPresented
        self.swiftUIContent = swiftUIContent
    }
    
    func body(content: Content) -> some View {
        ZStack {
            AlertView(isPresented: $isPresented, content: self.swiftUIContent)
                .fixedSize()
            
            content
        }
    }
}

struct AlertView<Content : View>: UIViewControllerRepresentable {
    
    // 1
    init(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self.isPresented = isPresented
        self.content = content
    }
        
    private var content: () -> Content
    
    private var isPresented: Binding<Bool>
            
    func makeUIViewController(context: Context) -> UIViewController {
        
        return UIViewController()
    }
    
    func updateUIViewController(_ viewController: UIViewController, context: Context) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let hostedView = UIHostingController(rootView: self.content())
        
        hostedView.view.translatesAutoresizingMaskIntoConstraints = false
        hostedView.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        alertController.setValue(hostedView, forKey: "contentViewController") // importian 👈
        
        if isPresented.wrappedValue {
            viewController.present(alertController, animated: true, completion: nil)
        } else {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject {
        
    }
}

struct DemoAlertView: View {
    @State var isPresented: Bool = false
    
    var body: some View {
        VStack {
            Button(action: {
                self.isPresented = true
            }) {
                Text("Show alert!!!")
            }
        }
        .alertView(isPresented: $isPresented) {

            ZStack {
                Button(action: {
                    self.isPresented = false
                }) {
                    Text("Dismiss")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
            }
            
        }
    }
}


struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        DemoAlertView()
    }
}
