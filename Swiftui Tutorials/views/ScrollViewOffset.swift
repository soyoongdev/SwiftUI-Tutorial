//
//  ScrollViewOffset.swift
//  Swiftui Tutorials
//
//  Created by Hau Nguyen on 05/09/2021.
//

import SwiftUI

struct ScrollViewOffset: View {
    @State var offset: CGPoint = .zero
    
    var isHiddenHead: Bool {
        switch offset.y {
        case -160...0:
            return false
        case 160:
            return true
        default:
            return true
        }
    }
    
    var body: some View {
//            CustomScrollView(offset: $offset, showsIndicators: true, axis: .vertical) {
//                VStack {
//                    ForEach(0..<30, id: \.self) { _ in
//                        Circle()
//                            .fill(Color.gray.opacity(0.6))
//                            .frame(width: 70, height: 70)
//                    }
//                }
//            }.navigationTitle("Offset: \(String(format: "%.1f", offset.y))")
//            .statusBar(hidden: true)
            
        Home()
    }
}


struct CustomScrollView<Content: View>: View {
    var content: Content

    @State var offset: CGFloat = 0
    @State var currentOffset: CGFloat = 0
    @Binding var state: Bool
    var showsIndicators: Bool
    var axis: Axis.Set
    @State var startOffset: CGFloat = 0
    @State var currentSize: CGFloat = 0

    init(state: Binding<Bool>, showsIndicators: Bool, axis: Axis.Set, @ViewBuilder content: ()-> Content) {
        self.content = content()
        self._state = state
        self.showsIndicators = showsIndicators
        self.axis = axis
    }
    
    var currentState: Bool {
        switch currentSize {
        case -(.infinity)...0:
            return true
        case 0...(.infinity) :
            return false
        default:
            return false
        }
    }

    var body: some View {
        ScrollView(axis, showsIndicators: showsIndicators, content: {
            content.overlay(
                GeometryReader {proxy -> Color in
                    let minY = proxy.frame(in: .global).minY

                    DispatchQueue.main.async {
                        if self.startOffset == 0 {
                            self.startOffset = minY
                        }
                        
                        currentOffset = self.startOffset - minY
                        
                        if currentOffset > self.offset {
                            currentSize = currentOffset - self.offset
//                            print("Current size >>>: \(String(format: "%.2f", currentSize))\n")
//                            print("Current state >>>: \(currentState)\n")
                        }
                        
                        if currentOffset < self.offset {
                            currentSize = currentOffset - self.offset
//                            print("Current size <<<n: \(String(format: "%.2f", currentSize))\n")
//                            print("Current state <<<: \(currentState)\n")
                        }
                        
                        self.offset = currentOffset
                    }

                    return Color.clear
                }
                .frame(height: 0), alignment: .top
            )
            .onChange(of: currentState) { value in
                if value {
                    withAnimation() {
                        self.state.toggle()
                    }
                } else {
                    withAnimation() {
                        self.state.toggle()
                    }
                }
                print("State: \(state)")
            }
        })
    }
}

private struct Home: View {
    
    @State var state: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            headerFriends()
                .zIndex(1)
                
            CustomScrollView(state: $state, showsIndicators: false, axis: .vertical) {
                VStack(spacing: 10) {
                    ForEach(1..<100, id: \.self) { index in
                        userItem(index: index)
                    }
                }
            }
            .padding(.top, 80)
        }
    }
    func headerFriends() -> some View {
        VStack {
            HStack {
                Image("maxresdefault")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 46, height: 46)
                    .clipShape(Circle())
                
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Anna")
                        .font(.headline)
                        .foregroundColor(.black)
                        .fontWeight(.heavy)
                    
                    Text("Youtuber")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .fontWeight(.regular)
                }
                
                Spacer(minLength: 0)
                
                HStack(spacing: 15) {
                    Button(action: {}) {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
                            .frame(width: 20, height: 20, alignment: .center)
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
                            .frame(width: 20, height: 20, alignment: .center)
                            .rotationEffect(Angle(degrees: 90), anchor: .center)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                Rectangle()
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0.0, y: 5)
            )
        }
    }
    
    func userItem(index: Int) -> some View {
        VStack {
            HStack {
                Image("maxresdefault")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 46, height: 46)
                    .background(Color.gray)
                    .clipShape(Circle())
                
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Anna")
                        .font(.headline)
                        .foregroundColor(.black)
                        .fontWeight(.heavy)
                    
                    Text("\(index)")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .fontWeight(.regular)
                }
                
                Spacer(minLength: 0)
                
                HStack(spacing: 15) {
                    
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
                            .frame(width: 20, height: 20, alignment: .center)
                            .rotationEffect(Angle(degrees: 90), anchor: .center)
                    }
                }
                
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Rectangle()
                    .fill(Color.white)
            )
        }
    }
}


struct User: Identifiable {
    let id = UUID()
    var image: String
    var name: String
    var age: Int
}
var userData = [
    User(image: "maxresdefault", name: "Anna", age: 20),
    User(image: "maxresdefault", name: "Anna", age: 21),
    User(image: "maxresdefault", name: "Anna", age: 22),
    User(image: "maxresdefault", name: "Anna", age: 23),
    User(image: "maxresdefault", name: "Anna", age: 24),
    User(image: "maxresdefault", name: "Anna", age: 20),
    User(image: "maxresdefault", name: "Anna", age: 21),
    User(image: "maxresdefault", name: "Anna", age: 22),
    User(image: "maxresdefault", name: "Anna", age: 23),
    User(image: "maxresdefault", name: "Anna", age: 24),
    User(image: "maxresdefault", name: "Anna", age: 20),
    User(image: "maxresdefault", name: "Anna", age: 21),
    User(image: "maxresdefault", name: "Anna", age: 22),
    User(image: "maxresdefault", name: "Anna", age: 23),
    User(image: "maxresdefault", name: "Anna", age: 24),
]

struct ScrollViewOffset_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
