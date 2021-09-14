//
//  MusicModelView.swift
//  Swiftui Tutorials
//
//  Created by Hau Nguyen on 13/09/2021.
//

import SwiftUI

struct Top100Music: Hashable, Codable {
    let id: String
    let name_singer: String
    let name_song: String
    let id_type: String
    let image_banner: String
    let id_country: String
    let updated_at: String
}


class Top100MusicViewModel: ObservableObject {
    let urlApiCall: String = "https://freewebking.000webhostapp.com/topmusic.php?apicall=\(MusicApiCall.GetAllMusic)"
    @Published var topMusicArray: [Top100Music] = []
    
    @State private var progress: Double = 0
    private let total: Double = 1
    @State private var dataTask: URLSessionDataTask?
    @State private var observation: NSKeyValueObservation?
    @State private var image: UIImage?
    
    
    init() {
        fetchApi()
    }
    
    func fetchApi() {
        guard let url =
                URL(string: urlApiCall) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            // Convert to JSON..
            do {
                let music = try JSONDecoder().decode([Top100Music].self, from: data)
                
                DispatchQueue.main.async {
                    self?.topMusicArray = music
                    print("\(music)")
                }
                
            } catch {
                print("Error fetching api at : \(error)")
                
            }
        }
        
        task.resume()
    }
    
    func loadingImage(urlImage: String) {
        guard let url = URL(string: urlImage) else { return }
        
        dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            self.observation?.invalidate()
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
            print("Response here: \(String(describing: response))")
        }
        
        observation = dataTask?.progress.observe(\.fractionCompleted) {observationProgress , _ in
            DispatchQueue.main.async {
                self.progress = observationProgress.fractionCompleted
            }
        }
        dataTask?.resume()
    }
    
    private func reset() {
        dataTask?.cancel()
        self.progress = 0
        image = nil
    }
}
