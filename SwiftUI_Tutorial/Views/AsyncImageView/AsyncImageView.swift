//
//  AsyncImageView.swift
//  SwiftUI_Tutorial
//
//  Created by Hau Nguyen on 04/01/2022.
//

import SwiftUI

struct AsyncImageView: View {
    @StateObject private var loader: AsyncImageViewController
    //private let placeholder: Placeholder
    private let image: (UIImage) -> Image
    @Binding var url: URL
    
    init(
        url: Binding<URL>
    ) {
        self.image = { Image(uiImage: $0).resizable() }
        self._url = url
        _loader = StateObject(wrappedValue: AsyncImageViewController(cache: Environment(\.imageCache).wrappedValue))
    }
    
    var body: some View {
        content
            .onAppear {
                loader.url = url
                loader.load()
            }
            .onChange(of: self.url) { newValue in
                loader.url = newValue
                loader.load()
            }
    }
    
    private var content: some View {
        Group {
            if loader.image != nil {
                image(loader.image!)

            } else {
                Image("no-img").resizable()
            }
        }
    }
}

struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageView(url: .constant(URL(string: "https://developer.apple.com/swift/images/swift-og.png")!))
    }
}
