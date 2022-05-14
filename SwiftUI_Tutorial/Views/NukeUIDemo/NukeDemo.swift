//
//  Demo.swift
//  SwiftUI_Tutorial
//
//  Created by HauNguyen on 13/04/2022.
//

import SwiftUI
import NukeUI

struct NukeDemo: View {
    @State var progressing: Int64 = 0
    @State var total: Int64 = 0
    
    var body: some View {
        ZStack {
            LazyImage(source: "https://firebasestorage.googleapis.com/v0/b/imageuploads-466a2.appspot.com/o/topmusicvn%2Fbigcityboy.jpeg?alt=media&token=31b614e4-17a9-4293-b34c-0d6c59a7dbf8")
                .onProgress { response, completed, total in
                    self.total = total
                }

        }
    }
}

struct Demo_Previews: PreviewProvider {
    static var previews: some View {
        NukeDemo()
    }
}
