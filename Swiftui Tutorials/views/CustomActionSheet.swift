//
//  CustomActionSheet.swift
//  Swiftui Tutorials
//
//  Created by Hau Nguyen on 09/09/2021.
//

import SwiftUI

struct CustomActionSheet: View {
    var body: some View {
        Home()
    }
}

private var arrImage = [
    "001", "002", "003", "004", "005", "006"
]

private struct Home: View {
    @State var searchText = ""
    @State var scrollOffset: CGPoint = .zero
    
    // Gesture Properties..
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @GestureState var gestureOffset: CGFloat = 0
        
    var body: some View {
        ZStack(alignment: .top) {
            
            VStack {
                Image("\(arrImage[2])")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    
            }
            .blur(radius: getBlurRadious())
            .ignoresSafeArea()
            
            
            // Bottom sheet..
            // Using GeometryReader for getting height for drag gesture..
            GeometryReader { proxy -> AnyView in
                let height = proxy.frame(in: .global).height
                
                return AnyView(
                    ZStack {
                        
                        BlurView(style: .systemThinMaterialDark)
                            .clipShape(CustomCorner(corner: [.topLeft, .topRight], radius: 30))
                        // Bottom sheet..
                        // Using GeometryReader for getting height for drag gesture..
                        
                        VStack {
                            VStack {
                                Capsule()
                                    .fill(Color.white)
                                    .frame(width: 60, height: 4)
                                
                                TextField("Search", text: $searchText)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal)
                                    .background(BlurView(style: .dark))
                                    .cornerRadius(10)
                                    .colorScheme(.dark)
                                    .padding(.top, 10)
                            }
                            .frame(height: 100)
                            
                            // ScrollView Content..
                            ScrollView(.vertical, showsIndicators: false) {
                                BottomContent()
                            }
                            
                        }
                        .padding(.horizontal)
                        .frame(maxHeight: .infinity, alignment: .top)
                        
                    }
                    .offset(y: height - 100)
                    .offset(y: -offset > 0 ? -offset <= (height - 100) ? offset : -(height - 100) : 0)
                    .gesture(DragGesture().updating($gestureOffset, body: { value, out, _ in
                        out = value.translation.height
                        onChange()
                        
                    }).onEnded({ value in
                        let maxHeight = height - 100
                        
                        withAnimation() {
                            
                            // Logic conditions for moving states..
                            // Up down or mind..
                            if -offset > 100 && -offset < maxHeight/2 {
                                offset = -(maxHeight / 3)
                            }
                            else if -offset > maxHeight / 2 {
                                offset = -maxHeight
                            }
                            else  {
                                offset = 0
                            }
                            
                            // Storing last offset..
                            // So that the gesture can continue from the last position..
                            lastOffset = offset
                        }
                    }))
                )
            }
            .padding(.top, 30)
            .ignoresSafeArea(.all, edges: .bottom)
            
        }
    }
    
    func onChange() {
        DispatchQueue.main.async {
            self.offset = gestureOffset + lastOffset
        }
    }
    
    // Blur radious for background..
    func getBlurRadious() -> CGFloat {
        let progess = -offset / (UIScreen.main.bounds.height - 100)
        
        return progess * 30
    }
    
    func imageItem(imageName: String) -> some View {
        Image("\(imageName)")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

struct actionSheetCustomView<Content: View>: View {
    var content: Content
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>, @ViewBuilder content: ()-> Content) {
        self.content = content()
        self._isPresented = isPresented
    }
    
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @GestureState var gestureOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            
        }
    }
    
}

struct BottomContent: View {
    var body: some View {
        VStack {
            HStack {
                Text("Favorite")
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                
                Spacer()
                
                Button(action: {}) {
                    Text("See all")
                        .fontWeight(.bold)
                }
            }
            .padding(.top, 20)
            
            Divider()
                .background(Color.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    VStack {
                        Button(action: {}) {
                            Image(systemName: "house.fill")
                                .font(.title)
                                .frame(width: 65, height: 65)
                                .background(BlurView(style: .dark))
                                .clipShape(Circle())
                        }
                        
                        Text("Home")
                            .foregroundColor(Color.white)
                    }
                    
                    VStack {
                        Button(action: {}) {
                            Image(systemName: "briefcase.fill")
                                .font(.title)
                                .frame(width: 65, height: 65)
                                .background(BlurView(style: .dark))
                                .clipShape(Circle())
                        }
                        
                        Text("Home")
                            .foregroundColor(Color.white)
                    }
                    
                    VStack {
                        Button(action: {}) {
                            Image(systemName: "plus")
                                .font(.title)
                                .frame(width: 65, height: 65)
                                .background(BlurView(style: .dark))
                                .clipShape(Circle())
                        }
                        
                        Text("Home")
                            .foregroundColor(Color.white)
                    }
                }
            }
            .padding(.top)
            
            HStack {
                Text("Editor's Pick")
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                
                Spacer()
                
                Button(action: {}) {
                    Text("See all")
                        .fontWeight(.bold)
                }
            }
            .padding(.top, 25)
            
            Divider()
                .background(Color.white)
            
            ForEach(arrImage, id: \.self) { index in
                Image("\(index.description)")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 30, height: 250)
                    .cornerRadius(15)
            }
            
        }
    }
}

struct CustomActionSheet_Previews: PreviewProvider {
    static var previews: some View {
        CustomActionSheet()
    }
}
