//
//  GridImageViewModel.swift
//  Swiftui Tutorials
//
//  Created by Hau Nguyen on 16/09/2021.
//

import SwiftUI

class GridAlbumImageViewModel: ObservableObject {
    
    @Published var allImage: [String] = ["image0", "image1", "image2", "image3"]
    @Published var showImageViewer = false
    @Published var selectedImageID: String = ""
    @Published var imageDragOffset: CGSize = .zero
    
    @Published var opacity: Double = 1
    
    func onChange(value: CGSize) {
        
        // Updating offset..
        self.imageDragOffset = value
        
        let height = UIScreen.main.bounds.height / 2
        
        // Calculating opacity..
        let progress = imageDragOffset.height / height
        
        withAnimation(.default) {
            self.opacity = Double(1 - progress)
        }
        
    }
    
    func onEnd(value: DragGesture.Value) {
        withAnimation(.easeInOut) {
            var translation = value.translation.height
            
            if translation < 0 {
                translation = -translation
            }
            
            if translation < 250 {
                self.imageDragOffset = .zero
                opacity = 1
            }
            else {
                self.showImageViewer.toggle()
                self.imageDragOffset = .zero
                opacity = 1
            }
        }
    }
}
