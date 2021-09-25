//
//  ViewModel.swift
//  Swiftui Tutorials
//
//  Created by Hau Nguyen on 15/09/2021.
//

import SwiftUI

class Covid19ViewModel: ObservableObject {
    let urlApi = "https://data.covid19.go.id/public/api/update.json"
    @Published var covid = [Total]()
    
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
                let result = try JSONDecoder().decode(BeCome.self, from: data)
                
                DispatchQueue.main.async {
                    print("Result >>> \(result.update.total)")
                }
                
            } catch {
                print("Error fetching api at : \(error)")
                
            }
        }
        
        task.resume()
    }
}
