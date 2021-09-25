//
//  ActionSheetCustomView.swift
//  Swiftui Tutorials
//
//  Created by Hau Nguyen on 18/09/2021.
//

import SwiftUI


struct ActionSheetCustomView: View {
    @State var isShowing: Bool = true
    var heightSheet = react.height / 2
    
    var body: some View {
        ZStack {
            Button(action: {
                withAnimation() {
                    self.isShowing.toggle()
                }
            }) {
                Text("Show sheet!")
                    .foregroundColor(.blue)
                    
            }
            ActionBottomSheet(isPresented: $isShowing, height: heightSheet, backgroundColor: Color.white) {
                ViewCustomer()
            }
            
        }
        
    }
}

struct CustomShapActionSheet: Shape {
    var corners: UIRectCorner
    var cornerRadius: Int
    
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        return Path(path.cgPath)
    }
}

private struct ViewCustomer: View {
    var body: some View {
        VStack(spacing: 18) {
            Text("Photo Collage")
                .foregroundColor(Color.gray)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(userData) {index in
                        userItem(image: index.image, name: index.name, age: index.age)
                    }
                }
            }
            
        }
        
    }
}


struct ActionBottomSheet<Content: View>: View {
    let content: Content
    @Binding var isPresented: Bool
    let backgroundColor: Color
    
    @State var offset: CGFloat = 0
    
    var height: CGFloat
    
    init(isPresented: Binding<Bool>, height: CGFloat, backgroundColor: Color, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.height = height
        self.backgroundColor = backgroundColor
        self.content = content()
    }
    
    var body: some View {
        
        VStack {
            Spacer()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    Capsule()
                        .fill(Color.gray)
                        .frame(width: 60, height: 4)
                    
                    Spacer()
                }
                .padding(.vertical)
                
                VStack {
                    content
                        .padding(.bottom, edges?.bottom)

                }
                .frame(height: height)
                
            }
            .background(
                Rectangle()
                    .fill(backgroundColor)
                    .clipShape(CustomShapActionSheet(corners: [.topLeft, .topRight], cornerRadius: 35))
            )
            .offset(y: offset)
                .offset(y: self.isPresented ? 0 : UIScreen.main.bounds.height)
            .gesture(DragGesture().onChanged(onChange(value:)).onEnded(onEnd(value:)))
            .transition(.move(edge: self.isPresented ? .top : .bottom))
        }
        .background(
            Color.black.opacity(self.isPresented ? 0.3 : 0).ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.default) {
                        self.isPresented.toggle()
                    }
                }
        )
        .ignoresSafeArea()
    }
    
    func onChange(value: DragGesture.Value) {
        if value.translation.height > 0 {
            offset = value.translation.height
        }
    }
    
    func onEnd(value: DragGesture.Value) {
        if value.translation.height > 0 {
            
            if value.translation.height > height / 1.5 {
                
                withAnimation(.linear) {
                    self.isPresented.toggle()
                }
            }
            offset = 0
        }
    }
}


struct ActionSheetCustomView_Previews: PreviewProvider {
    static var previews: some View {
        ActionSheetCustomView()
    }
}
