//
//  DemoScrollViewOffset.swift
//  SwiftUI_Tutorial
//
//  Created by HauNguyen on 29/03/2022.
//

import SwiftUI

struct DemoScrollViewOffset: View {
    @State var scrollOffset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollViewOffsetNew {
                VStack(alignment: .leading) {
                    Header()
                        .padding(.top, 60)

                    Text("3 min read • 22. November 2019")
                        .font(.custom("AvenirNext-Regular", size: 15))
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                    
                    Text(articleContent)
                        .font(.custom("AvenirNext-Regular", size: 20))
                        .lineLimit(nil)
                        .padding(.top, 30)
                    
                }
            } onOffsetChange: { value in
                self.scrollOffset = value
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 0)
                    .frame(height: 85)
                    
                Text("This is bottom : \(scrollOffset)")
                    .foregroundColor(Color.black)
                    .zIndex(10)
            }
            .zIndex(10)
                
        }
        .ignoresSafeArea()
    }
}

private struct Header: View {
    var body: some View {

        HStack {
            Image("IMAGE1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipped()
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text("Article by")
                    .font(.custom("AvenirNext-Regular", size: 15))
                    .foregroundColor(.gray)
                Text("Johne Doe")
                    .font(.custom("AvenirNext-Demibold", size: 15))
            }
        }
    }
}

struct DemoScrollViewOffset_Previews: PreviewProvider {
    static var previews: some View {
        DemoScrollViewOffset()
    }
}
