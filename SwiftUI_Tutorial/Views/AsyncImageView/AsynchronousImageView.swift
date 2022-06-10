//
//  AsynchronousImageView.swift
//  ThietThachClient
//
//  Created by HauNguyen on 14/04/2022.
//  https://github.com/kean/NukeUI.git
//

import SwiftUI
import NukeUI

struct AsynchronousImageView: View {
    init(source: Binding<String>, resizingMode: ImageResizingMode) {
        self._source = source
        self.resizingMode = resizingMode
    }
    @Binding var source: String
    var resizingMode: ImageResizingMode
    @State private var urlConvertable: ImageRequest = ImageRequest(url: URL(string: ""))
    
    var body: some View {
        LazyImage(source: urlConvertable, resizingMode: resizingMode)
            .onChange(of: source) { _ in
                self.loadData()
            }
            .onAppear() {
                self.loadData()
            }
    }
    
    private func loadData() {
        DispatchQueue.main.async {
            if self.source.isEmpty {
                self.urlConvertable = ImageRequest(url: noImage.parseURL())
            } else {
                self.urlConvertable = ImageRequest(url: source.parseURL())
            }
        }
    }
}

struct DemoAsynchronousImageView: View {
    var body: some View {
        AsynchronousImageView(source: .constant("https://www.apple.com/v/home/takeover/c/images/overview/hero/hero__x15fcac9fw2q_large_2x.png"), resizingMode: .center)
            .frame(height: 300)
    }
}

struct AsynchronousImageView_Previews: PreviewProvider {
    static var previews: some View {
        DemoAsynchronousImageView()
    }
}
