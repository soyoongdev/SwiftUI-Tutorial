//
//  HouseTemplate.swift
//  Swiftui Tutorials
//
//  Created by Hau Nguyen on 14/09/2021.
//

import SwiftUI

struct DishplayHouseTemplate: View {
    @StateObject var postTaxonomy = HouseTemplateViewModel()
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            Button(action: {
                openUrl()
            }) {
                Text("Open url")
            }
            
        }
    }
    
    func openUrl() {
        if let url = URL(string: postTaxonomy.urlApi) {
            UIApplication.shared.open(url)
        }
    }
}

private struct ItemCard: View {
    let postTaxonomyId: String
    let postTaxonomyName: String
    let createdDate: String
    let postcateId: String
    
    var body: some View {
        VStack {
            HStack {
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    Text("\(postTaxonomyId)")
                        .font(.headline)
                        .foregroundColor(Color.black)
                        .fontWeight(.heavy)
                    
                    Text("\(postTaxonomyName)")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                        .fontWeight(.heavy)
                    
                    Text("\(createdDate)")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                        .fontWeight(.heavy)
                    
                    Text("\(postcateId)")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                        .fontWeight(.heavy)
                    
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.black)
                        .frame(width: 20, height: 20, alignment: .center)
                        .rotationEffect(Angle(degrees: 90), anchor: .center)
                }
                
                
            }
            .padding(.horizontal, 15)
        }
    }
}


struct DishplayHouseTemplate_Previews: PreviewProvider {
    static var previews: some View {
        DishplayHouseTemplate()
    }
}
