//
//  FruitModel.swift
//  Swiftui Tutorials
//
//  Created by Hau Nguyen on 13/09/2021.
//

import SwiftUI

struct FruitModel: Identifiable {
    let id = UUID().uuidString
    let name: String
    let count: Int
}

class FruitViewModel: ObservableObject {
    @Published var fruitArray: [FruitModel] = []
    
    init() {
        getFruits()
    }
    
    func getFruits() {
        let fruit1 = FruitModel(name: "Apple", count: 20)
        let fruit2 = FruitModel(name: "Banana", count: 72)
        let fruit3 = FruitModel(name: "Watermelon", count: 68)
        
        fruitArray.append(fruit1)
        fruitArray.append(fruit2)
        fruitArray.append(fruit3)
    }
    
    func deleteFruit(index: IndexSet) {
        fruitArray.remove(atOffsets: index)
    }
    
    func addFruit() {
        
    }
}
