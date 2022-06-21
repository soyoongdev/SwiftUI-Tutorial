//
//  AlertView.swift
//  ThietThachClient
//
//  Created by HauNguyen on 17/06/2022.
//

import SwiftUI
import Combine

public extension View {
    /// Present `AlertToast`.
    /// - Parameters:
    ///   - show: Binding<Bool>
    ///   - alert: () -> AlertToast
    /// - Returns: `AlertToast`
    func alertView(isPresented: Binding<Bool>, offsetY: CGFloat = 0, alert: @escaping () -> AlertView) -> some View{
        modifier(AlertViewModifier(isPresented: isPresented, offsetY: offsetY, alert: alert))
    }
}

public struct AlertViewModifier: ViewModifier {
    ///Presentation `Binding<Bool>`
    @Binding var isPresented: Bool
    
    var offsetY: CGFloat = 0
    
    ///Init `AlertToast` View
    var alert: () -> AlertView
    
    let screen = UIScreen.main.bounds
    
    @State private var hostRect: CGRect = .zero
    @State private var alertRect: CGRect = .zero
    
    private var offset: CGFloat{
#if os(iOS)
        return -hostRect.midY + alertRect.height
#else
        return (-hostRect.midY + screen.midY) + alertRect.height
#endif
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                ZStack{
                    self.alert()
                        .offset(y: self.offsetY)
                }
                    .frame(maxWidth: self.screen.width,
                           maxHeight: self.screen.height,
                           alignment: .center)
                    .edgesIgnoringSafeArea(.all)
                    .animation(Animation.spring(), value: self.isPresented)
            )
    }
}

public struct AlertView: View {
    
    ///The title of the alert (`Optional(String)`)
    public var title: String? = nil
    
    /// Set action on  tap title
    public var onTapTitle: (() -> Void)?

    /// Set action on  tap subTitle
    public var subTitle: String? = nil
    
    /// Get title color
    public var onTapSubTitle: (() -> Void)?

    /// Get title color
    public var titleColor: Color? = nil
    
    public var content: () -> AnyView
    
    
    ///Alert View
    public var alert: some View{
        VStack{
            Spacer()
            self.content()
            Spacer()
            
            VStack(spacing: 8){
                if title != nil{
                    Button(action: {self.onTapTitle?()}) {
                        Text(LocalizedStringKey(title ?? ""))
                            .font(Font.body.bold())
                            .multilineTextAlignment(.center)
                            .foregroundColor(titleColor != nil ? titleColor! : Color.blue)
                    }
                }
                if subTitle != nil{
                    Button(action: {self.onTapSubTitle?()}) {
                        Text(LocalizedStringKey(subTitle ?? ""))
                            .font(Font.footnote)
                            .opacity(0.7)
                            .multilineTextAlignment(.center)
                            .foregroundColor(titleColor != nil ? titleColor! : Color.blue)
                    }
                }
            }
        }
        .fixedSize(horizontal: true, vertical: false)
        .padding()
        .frame(maxWidth: 175, maxHeight: 175, alignment: .center)
        .blurView()
        .cornerRadius(10)
    }
    
    ///Body init determine by `displayMode`
    public var body: some View{
        self.alert
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
            AlertView(title: "Title", subTitle: "Subtitle") {
                AnyView(
                    Image("photo2")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                )
            }
        }
    }
}


struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        DemoAlertView()
    }
}
