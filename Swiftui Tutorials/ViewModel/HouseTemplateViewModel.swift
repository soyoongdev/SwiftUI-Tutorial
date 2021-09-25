//
//  HouseTemplateViewMode;l.swift
//  Swiftui Tutorials
//
//  Created by Hau Nguyen on 14/09/2021.
//

import SwiftUI
import Combine
import Foundation

class HouseTemplateViewModel: ObservableObject {
//    let urlApi: String = "https://api.thietthach.maytech.vn/api/PostTaxonomies/GetByPostType/\(PostType.HOUSE_TEMPLATE.rawValue)"
    let urlApi = "https://freewebking.000webhostapp.com/housetemplate.json"
    @Published var postTaxonomyArray = [PostTaxonomyObject]()
    
    init() {
        fetchApi()
    }
    
    func fetchApi() {
        
        guard let url =
                URL(string: urlApi) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, respone, error in
            guard let data = data, error == nil else {
                return
            }
            
            print("Data >>> \(data)")
            // Convert to JSON..
            do {
                let result = try JSONDecoder().decode(Item.self, from: data)
                
                DispatchQueue.main.async {
                    print("Result >>> \(result)")
                }
                
            } catch {
                print("Error fetching api at : \(error)")
                
            }
        }
        
        task.resume()
    }
}


