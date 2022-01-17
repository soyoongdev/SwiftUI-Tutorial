//
//  LoadMoreScrolView.swift
//  SwiftUI_Tutorial
//
//  Created by Hau Nguyen on 24/12/2021.
//

import SwiftUI

struct LoadMoreScrolView: View {
    @State var isLoadMore: Bool = false
    @State var textfieldText: String = "String "
    private let chunkSize = 10
    @State var range: Range<Int> = 0..<1

    var body: some View {
        ZStack(alignment: .top) {
            Text(isLoadMore.description)
                .zIndex(1)
            
            List {
                ForEach(range) { number in
                    Text("\(self.textfieldText) \(number)")
                }
                Button(action: loadMore) {
                    Text("Load more")
                }
            }
        }
    }

    func loadMore() {
        isLoadMore = true
        self.range = 0..<self.range.upperBound + self.chunkSize
    }
}

struct LoadMoreScrolView_Previews: PreviewProvider {
    static var previews: some View {
        LoadMoreScrolView()
    }
}
