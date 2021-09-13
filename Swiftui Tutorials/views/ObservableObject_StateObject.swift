//
//  ObservableObject_StateObject.swift
//  Swiftui Tutorials
//
//  Created by Hau Nguyen on 13/09/2021.
//

import SwiftUI

struct ObservableObject_StateObject: View {
    // @StateObject -> USE THIS ON CREATION / INIT
    // @ObservedObject -> USE THIS FOR SUBVIEW
    @StateObject var fruitViewModel: FruitViewModel = FruitViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(fruitViewModel.fruitArray) {fruit in
                    itemList(name: fruit.name, count: fruit.count)
                }
                .onDelete(perform: fruitViewModel.deleteFruit(index:))
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Fruit List")
            .navigationBarItems(trailing: NavigationLink(destination: SecondView(fruitViewModel: fruitViewModel),
                                                   label: {
                                                    Image(systemName: "arrow.right")
                                                        .font(.title)
                                                   })
            )
        }
    }
    
    func itemList(name: String, count: Int) -> some View {
        HStack {
            Text("\(count)")
                .foregroundColor(Color.red)
            
            
            Text("\(name)")
                .font(.headline)
                .fontWeight(.semibold)
            
        }
    }
}

struct SecondView: View {
    @ObservedObject var fruitViewModel: FruitViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                ForEach(fruitViewModel.fruitArray) { value in
                    Text("\(value.name)")
                        .foregroundColor(Color.primary)
                }
            }
        }
    }
}

struct ObservableObject_StateObject_Previews: PreviewProvider {
    static var previews: some View {
        ObservableObject_StateObject()
    }
}
