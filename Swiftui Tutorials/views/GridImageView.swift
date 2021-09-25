//
//  GridImageView.swift
//  Swiftui Tutorials
//
//  Created by Hau Nguyen on 16/09/2021.
//

import SwiftUI

struct GridImageView: View {
    @StateObject var allArrayImage = GridAlbumImageViewModel()
    @State var columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
    
    var body: some View {
        ZStack {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 5) {
                ForEach(allArrayImage.allImage.indices) { i in
                    GridImageCardView(gridImage: allArrayImage, index: i)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .overlay(
            ZStack {
                if allArrayImage.showImageViewer {
                    ImageSelectedView(gridImage: allArrayImage)
                }
            }
        )
        
    }
}

private struct GridImageCardView: View {
    //  Can be editing..
    @ObservedObject var gridImage: GridAlbumImageViewModel
    var index: Int
    var corner: CGFloat?
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                self.gridImage.showImageViewer.toggle()
                self.gridImage.selectedImageID = gridImage.allImage[index]
            }
        }) {
            ZStack {
                if index <= 3 {
                    Image("\(gridImage.allImage[index])")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: getWidth(index: index), height: 120)
                        .cornerRadius(0)
                }
                
                if gridImage.allImage.count > 4 && index == 3 {
                    RoundedRectangle(cornerRadius: corner ?? 0)
                        .fill(Color.gray.opacity(0.5))
                    
                    let remainingImages = gridImage.allImage.count - 4
                    
                    Text("+\(remainingImages)")
                        .font(.body)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.white)
                }
            }
        }
    }
    
    func getWidth(index: Int) -> CGFloat {
        let width = react.width
        
        if gridImage.allImage.count % 2 == 0 {
            return width / 2
        }
        else {
            if index == gridImage.allImage.count - 1 {
                return width
            }
            else {
                return width / 2
            }
        }
    }
}

private struct ImageSelectedView: View {
    @ObservedObject var gridImage: GridAlbumImageViewModel
    @GestureState var draggingOffset: CGSize = .zero
    @State var state: Bool = false
    
    init(gridImage: GridAlbumImageViewModel) {
        UIScrollView.appearance().bounces = false
        self.gridImage = gridImage
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(gridImage.opacity).ignoresSafeArea()
            
            ScrollView(.init()) {
                TabView(selection: $gridImage.selectedImageID) {
                    ForEach(gridImage.allImage, id: \.self) { image in
                        Image("\(image)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .tag(image)
                            .offset(y: gridImage.imageDragOffset.height)
                            
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .overlay(
                    Button(action: {
                        withAnimation(.easeInOut) {
                            self.gridImage.showImageViewer.toggle()
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding(5)
                            .background(BlurView(style: UIBlurEffect.Style.systemMaterialLight))
                            .clipShape(Circle())
                    }
                    .padding(10), alignment: .topTrailing
                )
            }
            
        }
        .gesture(DragGesture().updating($draggingOffset, body: { (value, outValue, _) in
            outValue = value.translation
            gridImage.onChange(value: draggingOffset)
            
            // Drag On Bottom => draggingOffset.height > outValue.height
            // Drag On Top => draggingOffset.height > outValue.height
            
        }).onEnded(gridImage.onEnd(value:)))
    }
}

struct GridImageView_Previews: PreviewProvider {
    static var previews: some View {
        GridImageView()
    }
}
