//
//  SwiftUIApiCall.swift
//  Swiftui Tutorials
//
//  Created by Hau Nguyen on 13/09/2021.
//

import SwiftUI

struct SwiftUIApiCall: View {
    @StateObject var topMusic = Top100MusicViewModel()
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            if topMusic.topMusicArray.count > 0 {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(topMusic.topMusicArray, id: \.self) { value in
                            ItemCardMusic(urlImage: value.image_banner, singer: value.name_singer, music: value.name_song)
                            
                        }
                    }
                }
            }
            else {
                ProgressView()
            }
        }
        .onAppear() {
            topMusic.fetchApi()
        }
    }
    
    
}

private struct ItemCardMusic: View {
    let urlImage: String
    let singer: String
    let music: String
    @State private var progress: Double = 0
    private let total: Double = 1
    @State private var dataTask: URLSessionDataTask?
    @State private var observation: NSKeyValueObservation?
    @State private var image: UIImage?
    
    
    var body: some View {
        VStack {
            HStack {
                if image == nil {
                    Image("error_image")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 65, height: 65)
                        .clipShape(Rectangle())
                        .cornerRadius(5)
                    
                } else {
                    Image(uiImage: image!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 65, height: 65)
                        .clipShape(Rectangle())
                        .cornerRadius(5)
                }
                
                
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(music)")
                        .font(.headline)
                        .foregroundColor(Color.black)
                        .fontWeight(.heavy)
                    
                    Text("\(singer)")
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
            .hoverEffect(.automatic)
        }
        .onAppear() {
            loadingImage(urlImage: urlImage)
        }
    }
    func loadingImage(urlImage: String) {
        guard let url = URL(string: urlImage) else { return }
        
        dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.observation?.invalidate()
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
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

struct SwiftUIApiCall_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIApiCall()
    }
}
